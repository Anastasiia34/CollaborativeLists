//
//  CreateList.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 06.04.2026.
//

import Fluent

struct CreateList: AsyncMigration {
	func prepare(on database: any Database) async throws {
		try await database.schema(List.schema)
			.id()
			.field("title", .string, .required)
			.field("owner_id", .uuid, .required, .references(User.schema, "id", onDelete: .cascade))
			.field("created_at", .datetime)
			.field("updated_at", .datetime)
			.create()
	}
	
	func revert(on database: any Database) async throws {
		try await database.schema(List.schema).delete()
	}
}
