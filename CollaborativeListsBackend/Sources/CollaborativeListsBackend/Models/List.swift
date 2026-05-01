//
//  List.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 03.04.2026.
//

import Fluent
import Vapor

final class List: Model, Content, @unchecked Sendable {
	static let schema = "lists"
	
	@ID(key: .id)
	var id: UUID?
	
	@Field(key: "title")
	var title: String
	
	@Parent(key: "owner_id")
	var owner: User
	
	@Siblings(through: ListEditor.self, from: \.$list, to: \.$user)
	var editors: [User]
	
	@Children(for: \.$list)
	var items: [ListItem]
	
	@Timestamp(key: "created_at", on: .create)
	var createdAt: Date?
	
	@Timestamp(key: "updated_at", on: .update)
	var updatedAt: Date?
	
	init() {}
	
	init(id: UUID? = nil, title: String, ownerId: User.IDValue) {
		self.id = id
		self.title = title
		self.$owner.id = ownerId
	}
}
