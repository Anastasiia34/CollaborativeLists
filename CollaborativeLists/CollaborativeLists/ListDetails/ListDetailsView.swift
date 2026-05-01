//
//  ListDetailsView.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 22.04.2026.
//

import SwiftUI

struct ListDetailsView: View {
	@State private var viewModel: ListDetailsViewModel
	
	@Environment(\.listManager) private var listManager
	@Environment(\.router) private var router
	@Environment(\.alertManager) private var alertManager
	
	init(list: List) {
		_viewModel = State(initialValue: ListDetailsViewModel(list: list))
	}
	
	var body: some View {
		VStack {
			SwiftUI.List {
				ForEach(viewModel.details?.items ?? []) { item in
					ItemView(
						item: item,
						onCheck: {
							viewModel.updateItem(item, completed: !item.completed, title: nil)
						}
					)
					.disabled(viewModel.tempItemIds.contains(item.id))
					.swipeActions {
						Button(role: .destructive) {
							viewModel.deleteItem(item)
						} label: {
							Image(systemName: "trash")
						}
						
						Button {
							viewModel.renameItemButtonTapped(for: item)
						} label: {
							Image(systemName: "pencil")
						}
						.tint(.blue)
					}
				}
				
				AddItemView { title in
					viewModel.addItem(title: title)
				}
			}
		}
		.navigationTitle(viewModel.list.title)
		.spinnerOverlay(isVisible: viewModel.isDeletingList || viewModel.details == nil)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button(action: viewModel.menuButtonTapped) {
					Image(systemName: "ellipsis")
				}
				.confirmationDialog("", isPresented: $viewModel.showMenuOptions, titleVisibility: .hidden){
					Button("Members") {
						viewModel.membersButtonTapped()
					}
					
					if viewModel.list.access == .owner {
						Button("Rename") {
							viewModel.renameListButtonTapped()
						}
						
						Button("Delete", role: .destructive) {
							viewModel.deleteListButtonTapped()
						}
					}
				}
			}
		}
		.navigationBarTitleDisplayMode(.large)
		.onAppear {
			viewModel.configure(listManager: listManager, router: router, alertManager: alertManager)
			viewModel.loadDetails()
		}
		.sheet(isPresented: $viewModel.showListRenameSheet){
			RenameView(currentTitle: viewModel.list.title) { title in
				viewModel.renameList(with: title)
			}
		}
		.sheet(item: $viewModel.showItemRenameSheet){ item in
			RenameView(currentTitle: item.title) { title in
				viewModel.updateItem(item, completed: nil, title: title)
			}
		}
		.alert("Are you sure you want to delete the list?", isPresented: $viewModel.showDeleteListAlert) {
			Button("Delete", role: .destructive) {
				viewModel.deleteList()
			}
			
			Button("Cancel", role: .cancel) {}
		}
	}
}

#Preview {
	ListDetailsView(list: List.sample)
}
