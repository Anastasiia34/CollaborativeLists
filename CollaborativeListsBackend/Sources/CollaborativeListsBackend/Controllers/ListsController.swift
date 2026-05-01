//
//  ListsController.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 08.04.2026.
//

import Fluent
import Vapor

struct ListsController: RouteCollection {
	func boot(routes: any RoutesBuilder) throws {
		let lists = routes.grouped("api", "v1", "lists")
		let authGroup = lists.grouped(Token.authenticator(), User.guardMiddleware())
		
		authGroup.post(use: create)
		authGroup.get(use: index)
		authGroup.get(":listId", use: getList)
		authGroup.patch(":listId", use: updateTitle)
		authGroup.delete(":listId", use: removeList)
		authGroup.post(":listId", "items", use: addItem)
		authGroup.delete(":listId", "items", ":itemId", use: removeItem)
		authGroup.patch(":listId", "items", ":itemId", use: updateItem)
		authGroup.put(":listId", "items", "order", use: reorderItems)
		authGroup.post(":listId", "editors", use: addEditor)
		authGroup.delete(":listId", "editors", ":editorId", use: removeEditor)
	}
	
	// MARK: - List
	func create(req: Request) async throws -> CreateListResponse {
		let user = try req.auth.require(User.self)
		let data = try req.content.decode(CreateListRequest.self)
		let list = try List(title: data.title, ownerId: user.requireID())
		try await list.save(on: req.db)
		return try CreateListResponse(id: list.requireID())
	}
	
	func index(req: Request) async throws -> [ListResponse] {
		let userId = try req.userId()
		
		let createdLists = try await List.query(on: req.db)
			.filter(\.$owner.$id == userId)
			.all()
		
		let ownedResponses = try createdLists.map { ListResponse(id: try $0.requireID(), title: $0.title, access: .owner, createdAt: $0.createdAt, updatedAt: $0.updatedAt) }
		
		let joinedLists = try await ListEditor.query(on: req.db)
			.filter(\.$user.$id == userId)
			.with(\.$list)
			.all()
		
		let editorResponses = try joinedLists.map { ListResponse(id: try $0.list.requireID(), title: $0.list.title, access: .editor, createdAt: $0.list.createdAt, updatedAt: $0.list.updatedAt) }
		
		return (ownedResponses + editorResponses).sorted { $0.updatedAt ?? .distantPast > $1.updatedAt ?? .distantPast }
	}
	
	func getList(req: Request) async throws -> ListDetailsResponse {
		guard let listId = req.parameters.get("listId", as: UUID.self) else {
			throw Abort(.badRequest)
		}
		
		let userId = try req.userId()
		let list = try await requireEditableList(listId: listId, userId: userId, db: req.db)
		
		let items = try await ListItem.query(on: req.db)
			.filter(\.$list.$id == listId)
			.sort(\.$position, .ascending)
			.all()
			.map { ItemResponse(id: try $0.requireID(), title: $0.title, completed: $0.isCompleted, position: $0.position) }
		
		let owner = try await list.$owner.get(on: req.db)
		let ownerResponse = ListMemberResponse(id: try owner.requireID(), email: owner.email, role: .owner)
		
		let editors = try await ListEditor.query(on: req.db)
			.filter(\.$list.$id == listId)
			.with(\.$user)
			.all()
		
		let editorsResponse = try editors.map { ListMemberResponse(id: try $0.user.requireID(), email: $0.user.email, role: .editor) }
		
		return ListDetailsResponse(id: try list.requireID(), title: list.title, items: items, members: [ownerResponse] + editorsResponse, createdAt: list.createdAt, updatedAt: list.updatedAt)
	}
	
	func updateTitle(req: Request) async throws -> HTTPStatus {
		let userId = try req.userId()
		
		guard let listId = req.parameters.get("listId", as: UUID.self) else {
			throw Abort(.badRequest)
		}
		
		let list = try await requireOwnedList(listId: listId, userId: userId, db: req.db)
		let title = try req.content.decode(UpdateTitleRequest.self).title
		list.title = title
		try await list.save(on: req.db)
		return .ok
	}
	
	func removeList(req: Request) async throws -> HTTPStatus {
		guard let listId = req.parameters.get("listId", as: UUID.self) else {
			throw Abort(.badRequest)
		}
		
		let userId = try req.userId()
		let list = try await requireOwnedList(listId: listId, userId: userId, db: req.db)
		try await list.delete(on: req.db)
		return .noContent
	}
	
	// MARK: - Items
	func addItem(req: Request) async throws -> ItemResponse {
		let userId = try req.userId()
		
		guard let listId = req.parameters.get("listId", as: UUID.self) else {
			throw Abort(.badRequest)
		}
		
		let title = try req.content.decode(CreateItemRequest.self).title
		_ = try await requireEditableList(listId: listId, userId: userId, db: req.db)
		
		let itemsCount = try await ListItem.query(on: req.db)
			.filter(\.$list.$id == listId)
			.count()
		
		let item = ListItem(listId: listId, title: title, position: itemsCount)
		try await item.save(on: req.db)
		return ItemResponse(id: try item.requireID(), title: item.title, completed: item.isCompleted, position: item.position)
	}
	
	func removeItem(req: Request) async throws -> HTTPStatus {
		let userId = try req.userId()
		
		guard let listId = req.parameters.get("listId", as: UUID.self), let itemId = req.parameters.get("itemId", as: UUID.self) else {
			throw Abort(.badRequest)
		}
		
		return try await req.db.transaction { db in
			_ = try await requireEditableList(listId: listId, userId: userId, db: db)
			
			guard let item = try await ListItem.query(on: db)
				.filter(\.$id == itemId)
				.filter(\.$list.$id == listId)
				.first() else {
				throw Abort(.notFound)
			}
			
			try await item.delete(on: db)
			
			let items = try await ListItem.query(on: db)
				.filter(\.$list.$id == listId)
				.sort(\.$position, .ascending)
				.all()
			
			for (i, item) in items.enumerated() {
				item.position = i
				try await item.save(on: db)
			}
			
			return .noContent
		}
	}
	
	func updateItem(req: Request) async throws -> HTTPStatus {
		guard let listId = req.parameters.get("listId", as: UUID.self), let itemId = req.parameters.get("itemId", as: UUID.self) else {
			throw Abort(.badRequest)
		}
		
		let userId = try req.userId()
		_ = try await requireEditableList(listId: listId, userId: userId, db: req.db)
		let data = try req.content.decode(UpdateItemRequest.self)
		
		guard data.title?.isEmpty == false || data.completed != nil else {
			throw Abort(.badRequest)
		}
		
		guard let item = try await ListItem.query(on: req.db)
			.filter(\.$id == itemId)
			.filter(\.$list.$id == listId)
			.first() else {
			throw Abort(.notFound)
		}
		
		if let title = data.title {
			item.title = title
		}
		
		if let completed = data.completed {
			item.isCompleted = completed
		}
		
		try await item.save(on: req.db)
		return .noContent
	}
	
	func reorderItems(req: Request) async throws -> HTTPStatus {
		guard let listId = req.parameters.get("listId", as: UUID.self) else {
			throw Abort(.badRequest)
		}
		
		let userId = try req.userId()
		let itemIds = try req.content.decode(ReorderItemsRequest.self).itemIds
		
		return try await req.db.transaction { db in
			_ = try await requireEditableList(listId: listId, userId: userId, db: db)
			
			let items = try await ListItem.query(on: db)
				.filter(\.$list.$id == listId)
				.all()
			
			let idsFromDb = Set(try items.map { try $0.requireID() })
			let idsFromRequest = Set(itemIds)
			
			guard idsFromDb == idsFromRequest, itemIds.count == idsFromRequest.count else {
				throw Abort(.badRequest)
			}
			
			let positionDict = Dictionary(uniqueKeysWithValues: itemIds.enumerated().map { ($1, $0) })
			
			for item in items {
				let id = try item.requireID()
				guard let position = positionDict[id] else {
					throw Abort(.badRequest)
				}
				
				item.position = position
				try await item.save(on: db)
			}
			
			return .noContent
		}
	}
	
	// MARK: - Editors
	func addEditor(req: Request) async throws -> EditorResponse {
		guard let listId = req.parameters.get("listId", as: UUID.self) else {
			throw Abort(.badRequest)
		}
		
		let userId = try req.userId()
		_ = try await requireOwnedList(listId: listId, userId: userId, db: req.db)
		let email = try req.content.decode(CreateEditorRequest.self).email.lowercased()
		
		guard let editorUser = try await User.query(on: req.db)
			.filter(\.$email == email)
			.first() else {
			throw Abort(.notFound)
		}
		
		let editorUserId = try editorUser.requireID()
		guard editorUserId != userId else {
			throw Abort(.conflict)
		}
		
		guard try await ListEditor.query(on: req.db)
			.filter(\.$user.$id == editorUserId)
			.filter(\.$list.$id == listId)
			.first() == nil else {
			throw Abort(.conflict)
		}
		
		let editor = ListEditor(listId: listId, userId: editorUserId)
		try await editor.save(on: req.db)
		return EditorResponse(id: editorUserId, email: editorUser.email)
	}
	
	func removeEditor(req: Request) async throws -> HTTPStatus {
		guard let listId = req.parameters.get("listId", as: UUID.self), let editorId = req.parameters.get("editorId", as: UUID.self) else {
			throw Abort(.badRequest)
		}
		
		let userId = try req.userId()
		_ = try await requireOwnedList(listId: listId, userId: userId, db: req.db)
		
		guard let editor = try await ListEditor.query(on: req.db)
			.filter(\.$user.$id == editorId)
			.filter(\.$list.$id == listId)
			.first() else {
			throw Abort(.notFound)
		}
		
		try await editor.delete(on: req.db)
		return .noContent
	}
	
	// MARK: - Helpers
	private func requireEditableList(listId: UUID, userId: UUID, db: any Database) async throws -> List {
		guard let list = try await List.query(on: db)
			.filter(\.$id == listId)
			.first() else {
			throw Abort(.notFound)
		}
		
		let isOwner = list.$owner.id == userId
		
		let isEditor = try await ListEditor.query(on: db)
			.filter(\.$list.$id == listId)
			.filter(\.$user.$id == userId)
			.first() != nil
		
		if isOwner || isEditor {
			return list
		} else {
			throw Abort(.forbidden)
		}
	}
	
	private func requireOwnedList(listId: UUID, userId: UUID, db: any Database) async throws -> List {
		guard let list = try await List.query(on: db)
			.filter(\.$id == listId)
			.first() else {
			throw Abort(.notFound)
		}
		
		if list.$owner.id == userId {
			return list
		} else {
			throw Abort(.forbidden)
		}
	}
}
