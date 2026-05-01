//
//  SessionStoreMock.swift
//  CollaborativeListsTests
//
//  Created by Hello Kitty on 30.04.2026.
//

import Foundation
@testable import CollaborativeLists

final class SessionStoreMock: SessionStoring {
	private(set) var token: String?
	
	func setToken(_ token: String) {
		self.token = token
	}
	
	func logout() {
		token = nil
	}
}
