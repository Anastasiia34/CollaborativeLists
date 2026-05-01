//
//  Token.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 06.04.2026.
//

import Fluent
import Vapor

final class Token: Model, @unchecked Sendable {
	static let schema = "tokens"
	
	@ID(key: .id)
	var id: UUID?
	
	@Field(key: "value")
	var value: String
	
	@Parent(key: "user_id")
	var user: User
	
	@Timestamp(key: "created_at", on: .create)
	var createdAt: Date?
	
	@Field(key: "expires_at")
	var expiresAt: Date
	
	init() {}
	
	init(id: UUID? = nil, value: String, userId: User.IDValue, expiresAt: Date) {
		self.id = id
		self.value = value
		self.$user.id = userId
		self.expiresAt = expiresAt
	}
}

extension Token {
	static func generate(for user: User, validFor duration: TimeInterval = 60 * 60 * 24 * 30) throws -> Token {
		let value = [UInt8].random(count: 32).base64
		let expiresAt = Date().addingTimeInterval(duration)
		return try Token(value: value, userId: user.requireID(), expiresAt: expiresAt)
	}
}

extension Token: ModelTokenAuthenticatable {
	static let valueKey: KeyPath<Token, Field<String>> = \.$value
	static let userKey: KeyPath<Token, ParentProperty<Token, User>> = \.$user
	
	var isValid: Bool {
		expiresAt > Date()
	}
}
