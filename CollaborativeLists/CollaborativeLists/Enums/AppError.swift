//
//  AppError.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 13.04.2026.
//

import Foundation

enum AppError: LocalizedError, Equatable {
	case emptyField
	case generic
	case listDeletion
	case listRename
	case server(String)
	
	var errorDescription: String? {
		switch self {
		case .emptyField:
			"The field is empty. Please fill it in and try again."
		case .generic:
			"Something went wrong. Please try again."
		case .listDeletion:
			"Failed to delete the list"
		case .listRename:
			"Failed to rename list"
		case .server(let message):
			message
		}
	}
}
