//
//  ListMemberResponse.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 22.04.2026.
//

import Vapor

struct ListMemberResponse: Content {
	let id: UUID
	let email: String
	let role: ListAccess
}
