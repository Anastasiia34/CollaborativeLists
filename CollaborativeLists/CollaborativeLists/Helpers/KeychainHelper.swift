//
//  KeychainHelper.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 13.04.2026.
//

import Foundation
import Security

final class KeychainHelper {
	static let shared = KeychainHelper()
	
	private let service = "com.CollaborativeLists.auth"
	private let account = "access_token"
	
	private init() {}
	
	func save(token: String) throws {
		let data = Data(token.utf8)
		
		try? deleteToken()
		
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrService as String: service,
			kSecAttrAccount as String: account,
			kSecValueData as String: data
		]
		
		let status = SecItemAdd(query as CFDictionary, nil)
		
		guard status == errSecSuccess else {
			throw KeychainError.unhandledError(status)
		}
	}
	
	func getToken() throws -> String? {
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrService as String: service,
			kSecAttrAccount as String: account,
			kSecReturnData as String: true,
			kSecMatchLimit as String: kSecMatchLimitOne
		]
		
		var result: AnyObject?
		let status = SecItemCopyMatching(query as CFDictionary, &result)
		
		if status == errSecItemNotFound {
			return nil
		}
		
		guard status == errSecSuccess else {
			throw KeychainError.unhandledError(status)
		}
		
		guard let data = result as? Data,
			  let token = String(data: data, encoding: .utf8) else {
			throw KeychainError.invalidData
		}
		
		return token
	}
	
	func deleteToken() throws {
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrService as String: service,
			kSecAttrAccount as String: account
		]
		
		let status = SecItemDelete(query as CFDictionary)
		
		guard status == errSecSuccess || status == errSecItemNotFound else {
			throw KeychainError.unhandledError(status)
		}
	}
}

enum KeychainError: Error {
	case unhandledError(OSStatus)
	case invalidData
}
