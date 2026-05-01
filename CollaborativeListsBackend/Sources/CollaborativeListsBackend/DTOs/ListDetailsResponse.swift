//
//  ListDetailsResponse.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 10.04.2026.
//

import Vapor

struct ListDetailsResponse: Content {
	let id: UUID
	let title: String
	let items: [ItemResponse]
	let members: [ListMemberResponse]
	let createdAt: Date?
	let updatedAt: Date?
}
