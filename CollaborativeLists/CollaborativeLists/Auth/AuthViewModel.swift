//
//  AuthViewModel.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 15.04.2026.
//

import Foundation

@MainActor
@Observable
final class AuthViewModel {
	var state = AuthMode.login
	var emailText = ""
	var passwordText = ""
	private(set) var errorText = ""
	
	private var sessionStore: SessionStore?
	private var authManager: AuthManager?
	private var router: Router?
	private var alertManager: AlertManager?
	
	func configure(sessionStore: SessionStore, authManager: AuthManager, router: Router, alertManager: AlertManager) {
		self.sessionStore = sessionStore
		self.authManager = authManager
		self.router = router
		self.alertManager = alertManager
	}
	
	func confirmButtonTapped() {
		guard let authManager else {
			return
		}
		
		guard !emailText.isEmpty, !passwordText.isEmpty else {
			alertManager?.report(.emptyField)
			return
		}
		
		errorText = ""
		
		Task {
			do {
				let token: String
				if state == .login {
					token = try await authManager.login(email: emailText, password: passwordText)
				} else {
					token = try await authManager.register(email: emailText, password: passwordText)
				}
					
				sessionStore?.setToken(token)
				router?.navigateBack()
			} catch {
				errorText = error.localizedDescription
			}
		}
	}
}
