//
//  Item.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 17.04.2026.
//

import Foundation

struct Item: Decodable, Identifiable, Equatable, Hashable {
	var id: UUID
	var title: String
	var completed: Bool
	
	static let sample = Item(id: UUID(), title: "Some item", completed: false)
}
