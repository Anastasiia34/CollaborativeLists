//
//  MainViewModelTests.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 28.04.2026.
//

import Foundation
import Testing
@testable import CollaborativeLists

@MainActor
struct MainViewModelTests {
	@Test("loadLists success updates lists")
	func loadListsSuccess() async {
		let listManager = ListManagerMock()
		let list = List.sample
		listManager.listsToReturn = [list]
		let alertManager = AlertManagerMock()
		let viewModel = getConfiguredViewModel(listManager: listManager, alertManager: alertManager)
		
		await viewModel.loadLists()
		
		#expect(viewModel.lists.count == 1)
		#expect(viewModel.lists.first?.id == list.id)
		#expect(alertManager.reportedErrors.isEmpty)
	}
	
	@Test("loadLists failure reports alert")
	func loadListsFailure() async {
		let listManager = ListManagerMock()
		listManager.getListsError = AppError.generic
		let alertManager = AlertManagerMock()
		let viewModel = getConfiguredViewModel(listManager: listManager, alertManager: alertManager)
		
		await viewModel.loadLists()
		
		#expect(alertManager.reportedErrors.count == 1)
		#expect(viewModel.lists.isEmpty)
	}
	
	@Test("logout navigates to auth")
	func logoutNavigatesToAuth() {
		let router = RouterMock()
		let viewModel = getConfiguredViewModel(router: router)
		viewModel.logoutButtonTapped()
		#expect(router.path.last == .auth)
	}
	
	@Test("deleteList success removes list")
	func deleteListSuccess() async {
		let listManager = ListManagerMock()
		let list = List.sample
		listManager.listsToReturn = [list]
		let alertManager = AlertManagerMock()
		let viewModel = getConfiguredViewModel(listManager: listManager, alertManager: alertManager)
		
		await viewModel.loadLists()
		await viewModel.deleteList(list)
		
		#expect(listManager.deletedIds == [list.id])
		#expect(alertManager.reportedErrors.isEmpty)
	}
	
	@Test("deleteList failure restores lists and reports alert")
	func deleteListFailure() async {
		let listManager = ListManagerMock()
		let list = List.sample
		listManager.listsToReturn = [list]
		listManager.deleteListError = AppError.generic
		let alertManager = AlertManagerMock()
		let viewModel = getConfiguredViewModel(listManager: listManager, alertManager: alertManager)
		
		await viewModel.loadLists()
		await viewModel.deleteList(list)
		
		#expect(listManager.deletedIds.isEmpty)
		#expect(alertManager.reportedErrors.count == 1)
		#expect(viewModel.lists.count == 1)
	}
	
	private func getConfiguredViewModel(listManager: ListManaging = ListManagerMock(), router: Routing = RouterMock(), alertManager: AlertManaging = AlertManagerMock()) -> MainViewModel {
		let viewModel = MainViewModel()
		let sessionStore = SessionStoreMock()
		sessionStore.setToken("token")
		viewModel.configure(listManager: listManager, sessionStore: sessionStore, router: router, alertManager: alertManager)
		return viewModel
	}
}
