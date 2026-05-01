//
//  ListMember.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 22.04.2026.
//

import Foundation

struct ListMember: Decodable, Identifiable, Equatable, Hashable {
	let id: UUID
	let email: String
	let role: ListAccess
	
	static let ownerSample = ListMember(id: UUID(), email: "user1@email.com", role: .owner)
	static let editorSample = ListMember(id: UUID(), email: "user2@email.com", role: .editor)
}
