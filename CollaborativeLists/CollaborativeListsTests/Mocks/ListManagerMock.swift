//
//  ListManagerMock.swift
//  CollaborativeListsTests
//
//  Created by Hello Kitty on 28.04.2026.
//

import Foundation
@testable import CollaborativeLists

final class ListManagerMock: ListManaging {
	var listsToReturn = [List]()
	var addedMembersEmails = [String]()
	var deletedMemberIds = [UUID]()
	
	var getListsError: Error?
	var deleteListError: Error?
	var addEditorError: Error?
	var deleteEditorError: Error?
	var deletedIds = [UUID]()
	
	func getLists() async throws -> [List] {
		if let getListsError {
			throw getListsError
		}
		
		return listsToReturn
	}
	
	func deleteList(id: UUID) async throws {
		if let deleteListError {
			throw deleteListError
		}
		
		deletedIds.append(id)
	}
	
	func addEditor(email: String, toList listId: UUID) async throws -> ListMember {
		if let addEditorError {
			throw addEditorError
		}
		
		let editor = ListMember(id: UUID(), email: email, role: .editor)
		addedMembersEmails.append(editor.email)
		return editor
	}
	
	func deleteEditor(id: UUID, listId: UUID) async throws {
		if let deleteEditorError {
			throw deleteEditorError
		}
		
		deletedMemberIds.append(id)
	}
}
