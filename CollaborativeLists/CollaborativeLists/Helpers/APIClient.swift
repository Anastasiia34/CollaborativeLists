//
//  APIClient.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 17.04.2026.
//

import Alamofire
import Foundation

final class APIClient {
	var token: String?
	
	private var decoder: JSONDecoder {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		return decoder
	}
	
	private var baseUrl: String {
		(UserDefaults.standard.get(forKey: .serverUrl) ?? "http://localhost:8080") + "/api/v1/"
	}
	
	private var headers: HTTPHeaders? {
		guard let token else {
			return nil
		}
		
		return ["Authorization": "Bearer \(token)"]
	}
	
	func send<T: Decodable>(endpoint: String, method: HTTPMethod, parameters: Parameters? = nil) async throws -> T {
		let response = await AF.request(
			baseUrl + endpoint,
			method: method,
			parameters: parameters,
			encoding: JSONEncoding.default,
			headers: headers
		)
			.serializingData()
			.response
		
		guard let statusCode = response.response?.statusCode else {
			throw AppError.generic
		}
		
		let data = response.data ?? Data()
		
		if 200..<300 ~= statusCode {
			if T.self == EmptyResponse.self, let empty = EmptyResponse() as? T {
				return empty
			}
			
			return try decoder.decode(T.self, from: data)
		}
		
		if let apiError = try? decoder.decode(APIErrorResponse.self, from: data) {
			throw AppError.server(apiError.reason)
		}
		
		throw AppError.generic
	}
}
