//
//  CreateToken.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 06.04.2026.
//

import Fluent

struct CreateToken: AsyncMigration {
	func prepare(on database: any Database) async throws {
		try await database.schema(Token.schema)
			.id()
			.field("value", .string, .required)
			.field("user_id", .uuid, .required, .references(User.schema, "id", onDelete: .cascade))
			.field("created_at", .datetime)
			.field("expires_at", .datetime, .required)
			.unique(on: "value")
			.create()
	}
	
	func revert(on database: any Database) async throws {
		try await database.schema(Token.schema).delete()
	}
}
