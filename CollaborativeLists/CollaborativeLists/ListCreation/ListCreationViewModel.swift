//
//  ListCreationViewModel.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 22.04.2026.
//

import Foundation

@MainActor
@Observable
final class ListCreationViewModel {
	var title = ""
	private(set) var isCreating = false
	
	private var listManager: ListManager?
	private var router: Router?
	private var alertManager: AlertManager?
	
	func configure(listManager: ListManager, router: Router, alertManager: AlertManager) {
		self.listManager = listManager
		self.router = router
		self.alertManager = alertManager
	}
	
	func createButtonTapped() {
		guard !title.isEmpty else {
			alertManager?.report(.emptyField)
			return
		}
		
		isCreating = true
		
		Task {
			defer {
				isCreating = false
			}
			
			do {
				_ = try await listManager?.createList(withTitle: title)
				router?.navigateBack()
			} catch {
				alertManager?.report(.server(error.localizedDescription))
			}
		}
	}
}
