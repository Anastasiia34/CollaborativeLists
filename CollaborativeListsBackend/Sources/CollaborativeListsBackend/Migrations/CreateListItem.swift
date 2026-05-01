//
//  CreateListItem.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 06.04.2026.
//

import Fluent

struct CreateListItem: AsyncMigration {
	func prepare(on database: any Database) async throws {
		try await database.schema(ListItem.schema)
			.id()
			.field("list_id", .uuid, .required, .references(List.schema, "id", onDelete: .cascade))
			.field("title", .string, .required)
			.field("is_completed", .bool, .required)
			.field("position", .int, .required)
			.field("created_at", .datetime)
			.field("updated_at", .datetime)
			.create()
	}
	
	func revert(on database: any Database) async throws {
		try await database.schema(ListItem.schema).delete()
	}
}
