//
//  ListDetails.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 17.04.2026.
//

import Foundation

struct ListDetails: Decodable, Equatable, Hashable {
	let id: UUID
	let title: String
	var items: [Item]
	var members: [ListMember]
	
	static let sample = ListDetails(id: UUID(), title: "List 1", items: [Item.sample], members: [ListMember.ownerSample, ListMember.editorSample])
}
