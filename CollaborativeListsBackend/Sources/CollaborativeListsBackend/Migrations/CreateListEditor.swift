//
//  CreateListEditor.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 06.04.2026.
//

import Fluent

struct CreateListEditor: AsyncMigration {
	func prepare(on database: any Database) async throws {
		try await database.schema(ListEditor.schema)
			.id()
			.field("list_id", .uuid, .required, .references(List.schema, "id", onDelete: .cascade))
			.field("user_id", .uuid, .required, .references(User.schema, "id", onDelete: .cascade))
			.unique(on: "list_id", "user_id")
			.create()
	}
	
	func revert(on database: any Database) async throws {
		try await database.schema(ListEditor.schema).delete()
	}
}
