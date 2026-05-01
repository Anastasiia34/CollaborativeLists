//
//  ListManager.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 17.04.2026.
//

import Alamofire
import Foundation

final class ListManager: ListManaging {
	private let apiClient: APIClient
	
	init(apiClient: APIClient) {
		self.apiClient = apiClient
	}
	
	// MARK: List
	func getLists() async throws -> [List] {
		let response: [List] = try await apiClient.send(endpoint: "lists", method: .get)
		return response
	}
	
	func createList(withTitle title: String) async throws -> UUID {
		let response: CreateListResponse = try await apiClient.send(endpoint: "lists", method: .post, parameters: ["title": title])
		return response.id
	}
	
	func getListDetails(id: UUID) async throws -> ListDetails {
		let response: ListDetails = try await apiClient.send(endpoint: "lists/\(id.uuidString)", method: .get)
		return response
	}
	
	func updateListTitle(_ title: String, forId id: UUID) async throws {
		let _: EmptyResponse = try await apiClient.send(endpoint: "lists/\(id.uuidString)", method: .patch, parameters: ["title": title])
	}
	
	func deleteList(id: UUID) async throws {
		let _: EmptyResponse = try await apiClient.send(endpoint: "lists/\(id.uuidString)", method: .delete)
	}
	
	// MARK: Items
	func addItem(withTitle title: String, toListId listId: UUID) async throws -> Item {
		let response: Item = try await apiClient.send(endpoint: "lists/\(listId.uuidString)/items", method: .post, parameters: ["title": title])
		return response
	}
	
	func deleteItem(id: UUID, listId: UUID) async throws {
		let _: EmptyResponse = try await apiClient.send(endpoint: "lists/\(listId.uuidString)/items/\(id.uuidString)", method: .delete)
	}
	
	func updateItem(withTitle title: String?, completed: Bool?, id: UUID, listId: UUID) async throws {
		let rawParameters: [String: Any?] = ["title": title, "completed": completed]
		let parameters = rawParameters.compactMapValues({ $0 })
		let _: EmptyResponse = try await apiClient.send(endpoint: "lists/\(listId.uuidString)/items/\(id.uuidString)", method: .patch, parameters: parameters)
	}
	
	// MARK: Editors
	func addEditor(email: String, toList listId: UUID) async throws -> ListMember {
		let response: EditorResponse = try await apiClient.send(endpoint: "lists/\(listId.uuidString)/editors", method: .post, parameters: ["email": email])
		return ListMember(id: response.id, email: response.email, role: .editor)
	}
	
	func deleteEditor(id: UUID, listId: UUID) async throws {
		let _: EmptyResponse = try await apiClient.send(endpoint: "lists/\(listId.uuidString)/editors/\(id.uuidString)", method: .delete)
	}
}
