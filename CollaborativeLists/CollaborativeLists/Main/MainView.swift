//
//  MainView.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 15.04.2026.
//

import SwiftUI

struct MainView: View {
	@State private var viewModel = MainViewModel()
	@Environment(\.listManager) private var listManager
	@Environment(\.sessionStore) private var sessionStore
	@Environment(\.router) private var router
	@Environment(\.alertManager) private var alertManager
	
	var body: some View {
		VStack {
			if !viewModel.lists.isEmpty {
				SwiftUI.List {
					ForEach(viewModel.lists) { list in
						ListButton(list: list){ viewModel.didSelectList(list)
						}
						.swipeActions {
							Button(role: .destructive) {
								Task {
									await viewModel.deleteList(list)
								}
							} label: {
								Image(systemName: "trash")
							}
						}
					}
				}
			} else {
				NoListsView()
			}
		}
		.toolbar {
			ToolbarItem(placement: .topBarLeading) {
				Button {
					viewModel.logoutButtonTapped()
				} label: {
					Image(systemName: "rectangle.portrait.and.arrow.right")
				}
			}
			
			ToolbarItem(placement: .topBarTrailing) {
				Button {
					viewModel.createListButtonTapped()
				} label: {
					Image(systemName: "plus")
				}
			}
		}
		.onAppear {
			viewModel.configure(listManager: listManager, sessionStore: sessionStore, router: router, alertManager: alertManager)
			
			Task {
				await viewModel.loadLists()
			}
		}
	}
}

#Preview {
	MainView()
}
