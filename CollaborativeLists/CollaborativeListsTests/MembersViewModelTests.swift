//
//  MembersViewModelTests.swift
//  CollaborativeListsTests
//
//  Created by Hello Kitty on 29.04.2026.
//

import Foundation
import Testing
@testable import CollaborativeLists

@MainActor
struct MembersViewModelTests {
	@Test("addMember success updates members")
	func addMemberSuccess() async {
		let listManager = ListManagerMock()
		let alertManager = AlertManagerMock()
		let viewModel = getConfiguredViewModel(listManager: listManager, alertManager: alertManager)
		
		let email = "example@email.com"
		await viewModel.addMember(email: email)
		
		#expect(viewModel.details.members.contains(where: { $0.email == email }))
		#expect(listManager.addedMembersEmails == [email])
		#expect(alertManager.reportedErrors.isEmpty)
	}
	
	@Test("addMember failure reports alert")
	func addMemberFailure() async {
		let listManager = ListManagerMock()
		listManager.addEditorError = AppError.generic
		let alertManager = AlertManagerMock()
		let viewModel = getConfiguredViewModel(listManager: listManager, alertManager: alertManager)
		
		let email = "example@email.com"
		await viewModel.addMember(email: email)
		
		#expect(!viewModel.details.members.contains(where: { $0.email == email }))
		#expect(alertManager.reportedErrors.count == 1)
	}
	
	@Test("addMember with empty email reports alert")
	func addMemberWithEmptyEmail() async {
		let listManager = ListManagerMock()
		let alertManager = AlertManagerMock()
		let viewModel = getConfiguredViewModel(listManager: listManager, alertManager: alertManager)
		
		await viewModel.addMember(email: "")
		
		#expect(!viewModel.details.members.contains(where: { $0.email == "" }))
		#expect(listManager.addedMembersEmails.isEmpty)
		#expect(alertManager.reportedErrors.contains(.emptyField))
	}
	
	@Test("deleteMember success removes member")
	func deleteMemberSuccess() async {
		let listManager = ListManagerMock()
		let alertManager = AlertManagerMock()
		let editor = ListMember(id: UUID(), email: "example@email.com", role: .editor)
		let viewModel = getConfiguredViewModel(editor: editor, listManager: listManager, alertManager: alertManager)
		
		await viewModel.deleteMember(editor)
		
		#expect(!viewModel.details.members.contains(editor))
		#expect(listManager.deletedMemberIds == [editor.id])
		#expect(alertManager.reportedErrors.isEmpty)
	}
	
	@Test("deleteMember failure restores member and reports alert")
	func deleteMemberFailure() async {
		let listManager = ListManagerMock()
		listManager.deleteEditorError = AppError.generic
		let alertManager = AlertManagerMock()
		let editor = ListMember(id: UUID(), email: "example@email.com", role: .editor)
		let viewModel = getConfiguredViewModel(editor: editor, listManager: listManager, alertManager: alertManager)
		
		await viewModel.deleteMember(editor)
		
		#expect(viewModel.details.members.contains(editor))
		#expect(listManager.deletedMemberIds.isEmpty)
		#expect(alertManager.reportedErrors.count == 1)
	}
	
	private func getConfiguredViewModel(editor: ListMember? = nil, listManager: ListManaging, alertManager: AlertManaging) -> MembersViewModel {
		let details = ListDetails(id: UUID(), title: "Title", items: [], members: [editor ?? ListMember.editorSample])
		let viewModel = MembersViewModel(details: details, access: .owner)
		viewModel.configure(listManager: listManager, alertManager: alertManager)
		return viewModel
	}
}
