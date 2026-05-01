//
//  MainViewModel.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 15.04.2026.
//

import SwiftUI

@MainActor
@Observable
final class MainViewModel {
	private(set) var lists = [List]()
	
	private var listManager: ListManaging?
	private var sessionStore: SessionStoring?
	private var router: Routing?
	private var alertManager: AlertManaging?
	
	func configure(listManager: ListManaging, sessionStore: SessionStoring, router: Routing, alertManager: AlertManaging) {
		self.listManager = listManager
		self.sessionStore = sessionStore
		self.router = router
		self.alertManager = alertManager
	}
	
	func loadLists() async {
		guard let listManager, sessionStore?.token != nil else {
			return
		}
		
		do {
			lists = try await listManager.getLists()
		} catch {
			alertManager?.report(.server(error.localizedDescription))
		}
	}
	
	func logoutButtonTapped() {
		sessionStore?.logout()
		router?.navigate(to: .auth)
	}
	
	func createListButtonTapped() {
		router?.navigate(to: .listCreation)
	}
	
	func didSelectList(_ list: List) {
		router?.navigate(to: .listDetails(list: list))
	}
	
	func deleteList(_ list: List) async {
		guard let index = lists.firstIndex(where: { $0.id == list.id }) else {
			return
		}
		
		lists.remove(at: index)
		
		do {
			try await listManager?.deleteList(id: list.id)
		} catch {
			alertManager?.report(.server(error.localizedDescription))
			lists.insert(list, at: index)
		}

	}
}
