//
//  UsersController.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 06.04.2026.
//

import Fluent
import Vapor

struct UsersController: RouteCollection {
	func boot(routes: any RoutesBuilder) throws {
		let users = routes.grouped("api", "v1", "auth")
		
		users.post("register", use: register)
		users.post("login", use: login)
		
		let authGroup = users.grouped(Token.authenticator(), User.guardMiddleware())
		authGroup.get("validate", use: validate)
	}
	
	func register(req: Request) async throws -> AuthResponse {
		try RegisterRequest.validate(content: req)
		let data = try req.content.decode(RegisterRequest.self)
		let normalizedEmail = data.email.lowercased()
		
		guard try await User.query(on: req.db)
			.filter(\.$email == normalizedEmail)
			.first() == nil else {
			throw Abort(.conflict, reason: "A user with this email already exists")
		}
		
		let passwordHash = try Bcrypt.hash(data.password)
		let user = User(email: normalizedEmail, passwordHash: passwordHash)
		try await user.save(on: req.db)
		
		let token = try Token.generate(for: user)
		try await token.save(on: req.db)
		return AuthResponse(token: token.value)
	}
	
	func login(req: Request) async throws -> AuthResponse {
		try LoginRequest.validate(content: req)
		let data = try req.content.decode(LoginRequest.self)
		let normalizedEmail = data.email.lowercased()
		
		guard let user = try await User.query(on: req.db)
			.filter(\.$email == normalizedEmail)
			.first() else {
			throw Abort(.unauthorized, reason: "Invalid email or password")
		}
		
		let isPasswordValid = try Bcrypt.verify(data.password, created: user.passwordHash)
		
		guard isPasswordValid else {
			throw Abort(.unauthorized, reason: "Invalid email or password")
		}
		
		let userId = try user.requireID()
		try await Token.query(on: req.db)
			.filter(\.$user.$id == userId)
			.delete()
		
		let token = try Token.generate(for: user)
		try await token.save(on: req.db)
		return AuthResponse(token: token.value)
	}
	
	func validate(req: Request) async throws -> HTTPStatus {
		.ok
	}
}
