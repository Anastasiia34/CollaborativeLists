//
//  AuthResponse.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 06.04.2026.
//

import Vapor

struct AuthResponse: Content {
	let token: String
}
