//
//  ItemResponse.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 10.04.2026.
//

import Vapor

struct ItemResponse: Content {
	let id: UUID
	let title: String
	let completed: Bool
	let position: Int
}
