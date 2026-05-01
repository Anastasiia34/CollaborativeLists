//
//  ListItem.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 03.04.2026.
//

import Fluent
import Vapor

final class ListItem: Model, @unchecked Sendable {
	static let schema = "list_items"
	
	@ID(key: .id)
	var id: UUID?
	
	@Parent(key: "list_id")
	var list: List
	
	@Field(key: "title")
	var title: String
	
	@Field(key: "is_completed")
	var isCompleted: Bool
	
	@Field(key: "position")
	var position: Int
	
	@Timestamp(key: "created_at", on: .create)
	var createdAt: Date?
	
	@Timestamp(key: "updated_at", on: .update)
	var updatedAt: Date?
	
	init() {}
	
	init(id: UUID? = nil, listId: List.IDValue, title: String, isCompleted: Bool = false, position: Int) {
		self.id = id
		self.$list.id = listId
		self.title = title
		self.isCompleted = isCompleted
		self.position = position
	}
}
