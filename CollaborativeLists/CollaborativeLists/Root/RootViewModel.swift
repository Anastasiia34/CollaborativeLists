//
//  RootViewModel.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 13.04.2026.
//

import Foundation

@MainActor
@Observable
final class RootViewModel {
	private(set) var showSplash = true
	var showUrlAlert = false
	var urlText = ""
	
	private var authManager: AuthManager?
	private var sessionStore: SessionStore?
	private var router: Router?
	
	func configure(sessionStore: SessionStore, authManager: AuthManager, router: Router) {
		self.sessionStore = sessionStore
		self.authManager = authManager
		self.router = router
	}
	
	func viewDidAppear() {
		let urlString: String? = UserDefaults.standard.get(forKey: .serverUrl)
		
		if urlString == nil || urlString?.isEmpty == true {
			showUrlAlert = true
		} else {
			restoreSessionOrGoToAuth()
		}
	}
	
	func urlAlertButtonTapped() {
		UserDefaults.standard.set(urlText, forKey: .serverUrl)
		restoreSessionOrGoToAuth()
	}
	
	private func restoreSessionOrGoToAuth() {
		sessionStore?.restoreSession()
		
		if let token = sessionStore?.token {
			Task {
				defer {
					showSplash = false
				}
				
				do {
					try await authManager?.validate(token: token)
				} catch {
					sessionStore?.logout()
					router?.navigate(to: .auth)
				}
			}
		} else {
			router?.navigate(to: .auth)
			showSplash = false
		}
	}
}
