//
//  CreateUser.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 06.04.2026.
//

import Fluent

struct CreateUser: AsyncMigration {
	func prepare(on database: any Database) async throws {
		try await database.schema(User.schema)
			.id()
			.field("email", .string, .required)
			.field("password_hash", .string, .required)
			.field("created_at", .datetime)
			.unique(on: "email")
			.create()
	}
	
	func revert(on database: any Database) async throws {
		try await database.schema(User.schema).delete()
	}
}
