//
//  UpdateTitleRequest.swift
//  CollaborativeListsBackend
//
//  Created by Hello Kitty on 08.04.2026.
//

import Vapor

struct UpdateTitleRequest: Content {
	let title: String
}
