//
//  ReorderItemsRequest.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 10.04.2026.
//

import Vapor

struct ReorderItemsRequest: Content {
	let itemIds: [UUID]
}
