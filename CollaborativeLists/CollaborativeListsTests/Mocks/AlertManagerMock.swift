//
//  AlertManagerMock.swift
//  CollaborativeListsTests
//
//  Created by Hello Kitty on 29.04.2026.
//

import Foundation
@testable import CollaborativeLists

final class AlertManagerMock: AlertManaging {
	private(set) var reportedErrors = [AppError]()
	
	func report(_ error: AppError) {
		reportedErrors.append(error)
	}
}
