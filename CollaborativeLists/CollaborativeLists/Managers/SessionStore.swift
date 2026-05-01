//
//  SessionStore.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 13.04.2026.
//

import SwiftUI

@Observable
final class SessionStore: SessionStoring {
	private let keychain = KeychainHelper.shared
	private(set) var token: String?
	
	func restoreSession() {
		do {
			token = try keychain.getToken()
		} catch {
			token = nil
		}
	}
	
	func setToken(_ token: String) {
		self.token = token
		try? keychain.save(token: token)
	}
	
	func logout() {
		token = nil
		try? keychain.deleteToken()
	}
}
