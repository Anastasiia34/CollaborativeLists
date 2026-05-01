//
//  MembersViewModel.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 24.04.2026.
//

import Foundation

@MainActor
@Observable
final class MembersViewModel {
	var details: ListDetails
	let access: ListAccess
	var isAddingEditor = false
	
	private var listManager: ListManaging?
	private var alertManager: AlertManaging?
	
	init(details: ListDetails, access: ListAccess) {
		self.details = details
		self.access = access
	}
	
	func configure(listManager: ListManaging, alertManager: AlertManaging) {
		self.listManager = listManager
		self.alertManager = alertManager
	}
	
	func addMember(email: String) async {
		guard let listManager else {
			return
		}
		
		guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
			alertManager?.report(.emptyField)
			return
		}
		
		isAddingEditor = true
		defer {
			isAddingEditor = false
		}
		
		do {
			let member = try await listManager.addEditor(email: email, toList: details.id)
			details.members.append(member)
		} catch {
			alertManager?.report(.server(error.localizedDescription))
		}
	}
	
	func deleteMember(_ member: ListMember) async {
		guard let index = details.members.firstIndex(where: { member.id == $0.id }) else {
			return
		}
		
		details.members.remove(at: index)
		
		do {
			try await listManager?.deleteEditor(id: member.id, listId: details.id)
		} catch {
			details.members.insert(member, at: index)
			alertManager?.report(.server(error.localizedDescription))
		}
	}
}
