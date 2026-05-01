//
//  UpdateItemRequest.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 08.04.2026.
//

import Vapor

struct UpdateItemRequest: Content {
	let title: String?
	let completed: Bool?
}
