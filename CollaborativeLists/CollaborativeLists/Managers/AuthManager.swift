//
//  AuthManager.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 13.04.2026.
//

import Alamofire
import Foundation

final class AuthManager {
	private let apiClient: APIClient
	
	init(apiClient: APIClient) {
		self.apiClient = apiClient
	}
	
	func validate(token: String) async throws {
		apiClient.token = token
		let _: EmptyResponse = try await apiClient.send(endpoint: "auth/validate", method: .get)
	}
	
	func login(email: String, password: String) async throws -> String {
		let response: AuthResponse = try await apiClient.send(endpoint: "auth/login", method: .post, parameters: ["email": email, "password": password])
		return response.token
	}
	
	func register(email: String, password: String) async throws -> String {
		let response: AuthResponse = try await apiClient.send(endpoint: "auth/register", method: .post, parameters: ["email": email, "password": password])
		return response.token
	}
}
