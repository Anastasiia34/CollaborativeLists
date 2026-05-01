//
//  ListManaging.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 28.04.2026.
//

import Foundation

protocol ListManaging {
	func getLists() async throws -> [List]
	func deleteList(id: UUID) async throws
	func addEditor(email: String, toList listId: UUID) async throws -> ListMember
	func deleteEditor(id: UUID, listId: UUID) async throws
}
