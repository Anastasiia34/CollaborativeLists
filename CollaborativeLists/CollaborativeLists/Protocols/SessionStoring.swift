//
//  SessionStoring.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 30.04.2026.
//

import Foundation

protocol SessionStoring {
	var token: String? { get }
	func setToken(_ token: String)
	func logout()
}
