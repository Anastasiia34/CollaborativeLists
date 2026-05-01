//
//  ListResponse.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 08.04.2026.
//

import Vapor

struct ListResponse: Content {
	let id: UUID?
	let title: String
	let access: ListAccess
	let createdAt: Date?
	let updatedAt: Date?
}

enum ListAccess: String, Content {
	case owner
	case editor
}
