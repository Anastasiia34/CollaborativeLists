//
//  EditorResponse.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 10.04.2026.
//

import Vapor

struct EditorResponse: Content {
	let id: UUID
	let email: String
}
