//
//  ListEditor.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 06.04.2026.
//

import Fluent
import Vapor

final class ListEditor: Model, @unchecked Sendable {
	static let schema = "list_editors"
	
	@ID(key: .id)
	var id: UUID?
	
	@Parent(key: "list_id")
	var list: List
	
	@Parent(key: "user_id")
	var user: User

	init() {}
	
	init(id: UUID? = nil, listId: List.IDValue, userId: User.IDValue) {
		self.id = id
		self.$list.id = listId
		self.$user.id = userId
	}
}
