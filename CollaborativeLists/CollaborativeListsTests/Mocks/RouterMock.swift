//
//  RouterMock.swift
//  CollaborativeListsTests
//
//  Created by Hello Kitty on 29.04.2026.
//

import Foundation
@testable import CollaborativeLists

final class RouterMock: Routing {
	var path = [Screen]()
	
	func navigate(to screen: Screen) {
		path.append(screen)
	}
}
