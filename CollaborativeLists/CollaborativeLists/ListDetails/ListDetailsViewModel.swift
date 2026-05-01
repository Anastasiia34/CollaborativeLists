//
//  ListDetailsViewModel.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 22.04.2026.
//

import SwiftUI

@MainActor
@Observable
final class ListDetailsViewModel {
	var list: List
	var details: ListDetails?
	var showMenuOptions = false
	var showListRenameSheet = false
	var showItemRenameSheet: Item?
	var showDeleteListAlert = false
	var isDeletingList = false
	private(set) var tempItemIds = [UUID]()
	
	private var updateTasks: [UUID: Task<Void, Never>] = [:]
	private var listManager: ListManager?
	private var router: Router?
	private var alertManager: AlertManager?
	
	init(list: List) {
		self.list = list
	}
	
	func configure(listManager: ListManager, router: Router, alertManager: AlertManager) {
		self.listManager = listManager
		self.router = router
		self.alertManager = alertManager
	}
	
	func loadDetails() {
		Task {
			do {
				details = try await listManager?.getListDetails(id: list.id)
			} catch {
				alertManager?.report(.generic)
			}
		}
	}
	
	func menuButtonTapped() {
		showMenuOptions = true
	}
	
	func membersButtonTapped() {
		guard let details else {
			alertManager?.report(.generic)
			return
		}
		
		router?.navigate(to: .members(details: details, access: list.access))
	}
	
	func renameListButtonTapped() {
		showListRenameSheet = true
	}
	
	func renameList(with title: String) {
		let oldTitle = list.title
		showListRenameSheet = false
		list.title = title
		
		Task {
			do {
				try await listManager?.updateListTitle(title, forId: list.id)
			} catch {
				list.title = oldTitle
				alertManager?.report(.listRename)
			}
		}
	}
	
	func deleteListButtonTapped() {
		showDeleteListAlert = true
	}
	
	func deleteList() {
		isDeletingList = true
		Task {
			do {
				try await listManager?.deleteList(id: list.id)
				router?.navigateBack()
			} catch {
				isDeletingList = false
				alertManager?.report(.listDeletion)
			}
		}
	}
	
	func renameItemButtonTapped(for item: Item) {
		showItemRenameSheet = item
	}
	
	func updateItem(_ item: Item, completed: Bool?, title: String?) {
		guard let index = details?.items.firstIndex(where: { $0.id == item.id }) else {
			alertManager?.report(.generic)
			return
		}
		
		if let title {
			showItemRenameSheet = nil
			details?.items[index].title = title
		}
		
		if let completed {
			details?.items[index].completed = completed
		}
		
		updateTasks[item.id]?.cancel()
		updateTasks[item.id] = Task {
			do {
				try await listManager?.updateItem(withTitle: title, completed: completed, id: item.id, listId: list.id)
			} catch {
				if !Task.isCancelled, let index = details?.items.firstIndex(where: { $0.id == item.id }) {
					details?.items[index] = item
				}
			}
		}
	}
	
	func addItem(title: String) {
		guard let listManager else {
			return
		}
		
		guard !title.isEmpty else {
			alertManager?.report(.emptyField)
			return
		}
		
		let tempId = UUID()
		tempItemIds.append(tempId)
		
		details?.items.append(Item(id: tempId, title: title, completed: false))
		
		Task {
			defer {
				tempItemIds.removeAll(where: { $0 == tempId })
			}
			
			do {
				let item = try await listManager.addItem(withTitle: title, toListId: list.id)
				
				if let index = details?.items.firstIndex(where: { $0.id == tempId }) {
					details?.items[index].id = item.id
				}
			} catch {
				details?.items.removeAll(where: { $0.id == tempId })
				alertManager?.report(.server(error.localizedDescription))
			}
		}
	}
	
	func deleteItem(_ item: Item) {
		guard let index = details?.items.firstIndex(where: { $0.id == item.id }) else {
			return
		}
		
		details?.items.remove(at: index)
		
		Task {
			do {
				try await listManager?.deleteItem(id: item.id, listId: list.id)
			} catch {
				details?.items.append(item)
				alertManager?.report(.server(error.localizedDescription))
			}
		}
	}
}
