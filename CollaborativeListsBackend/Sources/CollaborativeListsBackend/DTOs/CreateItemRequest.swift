//
//  CreateItemRequest.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 08.04.2026.
//

import Vapor

struct CreateItemRequest: Content {
	let title: String
}
