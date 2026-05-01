//
//  Screen.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 13.04.2026.
//

import Foundation

enum Screen: Hashable, Equatable {
	case auth, lists, listCreation, listDetails(list: List), members(details: ListDetails, access: ListAccess)
}
