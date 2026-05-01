//
//  CollaborativeListsApp.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 13.04.2026.
//

import SwiftUI

@main
struct CollaborativeListsApp: App {
	@State private var apiClient: APIClient
	@State private var authManager: AuthManager
	@State private var listManager: ListManager
	
	init() {
		let client = APIClient()
		_apiClient = State(initialValue: client)
		_authManager = State(initialValue: AuthManager(apiClient: client))
		_listManager = State(initialValue: ListManager(apiClient: client))
	}
	
    var body: some Scene {
        WindowGroup {
            RootView()
				.environment(\.apiClient, apiClient)
				.environment(\.authManager, authManager)
				.environment(\.listManager, listManager)
        }
    }
}
