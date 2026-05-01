//
//  User.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 03.04.2026.
//

import Fluent
import Vapor

final class User: Model, @unchecked Sendable {
	static let schema = "users"
	
	@ID(key: .id)
	var id: UUID?
	
	@Field(key: "email")
	var email: String
	
	@Field(key: "password_hash")
	var passwordHash: String
	
	@Timestamp(key: "created_at", on: .create)
	var createdAt: Date?
	
	init() {}
	
	init(id: UUID? = nil, email: String, passwordHash: String) {
		self.id = id
		self.email = email
		self.passwordHash = passwordHash
	}
}

extension User {
	struct Public: Content, @unchecked Sendable {
		var id: UUID?
		var email: String
		
		init(id: UUID? = nil, email: String) {
			self.id = id
			self.email = email
		}
	}
	
	func convertToPublic() -> Public {
		return Public(id: id, email: email)
	}
}

extension User: Authenticatable {}
