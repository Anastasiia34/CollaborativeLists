//
//  Request+Extension.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 08.04.2026.
//

import Vapor

extension Request {
	func user() throws -> User {
		try self.auth.require(User.self)
	}
	
	func userId() throws -> UUID {
		try self.auth.require(User.self).requireID()
	}
}
