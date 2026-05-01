//
//  List.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 17.04.2026.
//

import Foundation

struct List: Identifiable, Decodable, Equatable, Hashable {
	let id: UUID
	var title: String
	let access: ListAccess
	let createdAt: Date
	let updatedAt: Date
	
	var updatedAtString: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm E, d MMM y"
		let dateString = formatter.string(from: updatedAt)
		return "Updated at \(dateString)"
	}
	
	static let sample = List(id: UUID(), title: "Some list", access: .owner, createdAt: Date(), updatedAt: Date())
}
