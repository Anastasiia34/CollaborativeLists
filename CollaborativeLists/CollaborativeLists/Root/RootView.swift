//
//  RootView.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 13.04.2026.
//

import SwiftUI

struct RootView: View {
	@State private var viewModel = RootViewModel()
	
	@Environment(\.alertManager) private var alertManager
	@Environment(\.apiClient) private var apiClient
	@Environment(\.authManager) private var authManager
	@Environment(\.sessionStore) private var sessionStore
	@Environment(\.router) private var router
	
	var body: some View {
		
		NavigationStack(path: router.binding(for: \.path)) {
			MainView()
				.navigationDestination(for: Screen.self) { screen in
					switch screen {
					case .auth:
						AuthView()
					case .lists:
						MainView()
					case .listCreation:
						ListCreationView()
					case .listDetails(let list):
						ListDetailsView(list: list)
					case .members(let details, let access):
						MembersView(details: details, access: access)
					}
				}
		}
		.overlay {
			if viewModel.showSplash {
				SplashView()
			}
		}
		.onAppear {
			viewModel.configure(sessionStore: sessionStore, authManager: authManager, router: router)
			viewModel.viewDidAppear()
		}
		.alert("Enter server URL", isPresented: $viewModel.showUrlAlert){
			TextField("", text: $viewModel.urlText)
			
			Button("OK") {
				viewModel.urlAlertButtonTapped()
			}
		} message: {
			Text("e.g. http://192.168.1.10:8080")
		}
		.alert(usingManager: alertManager)
		.task(id: sessionStore.token) {
			apiClient.token = sessionStore.token
		}
	}
}

#Preview {
	RootView()
}
