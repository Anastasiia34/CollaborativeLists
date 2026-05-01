//
//  AuthResponse.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 13.04.2026.
//

import Foundation

nonisolated struct AuthResponse: Decodable, Sendable {
	let token: String
}
