//
//  EnvironmentValues+Extension.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 13.04.2026.
//

import SwiftUI

extension EnvironmentValues {
// the new @Entry macro ruins bindings
	var alertManager: AlertManager {
		get { self[AlertManagerKey.self] }
		set { self[AlertManagerKey.self] = newValue }
	}
	
	var apiClient: APIClient {
		get { self[APIClientKey.self] }
		set { self[APIClientKey.self] = newValue }
	}
	
	var authManager: AuthManager {
		get { self[AuthManagerKey.self] }
		set { self[AuthManagerKey.self] = newValue }
	}
	
	var listManager: ListManager {
		get { self[ListManagerKey.self] }
		set { self[ListManagerKey.self] = newValue }
	}
	
	var router: Router {
		get { self[RouterKey.self] }
		set { self[RouterKey.self] = newValue }
	}
	
	var sessionStore: SessionStore {
		get { self[SessionStoreKey.self] }
		set { self[SessionStoreKey.self] = newValue }
	}
}

private struct AlertManagerKey: EnvironmentKey {
	static let defaultValue = AlertManager()
}

private struct APIClientKey: EnvironmentKey {
	static let defaultValue = APIClient()
}

private struct AuthManagerKey: EnvironmentKey {
	static let defaultValue = AuthManager(apiClient: APIClient())
}

private struct ListManagerKey: EnvironmentKey {
	static let defaultValue = ListManager(apiClient: APIClient())
}

private struct RouterKey: EnvironmentKey {
	static let defaultValue = Router()
}

private struct SessionStoreKey: EnvironmentKey {
	static let defaultValue = SessionStore()
}
