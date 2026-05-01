//
//  Routing.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 29.04.2026.
//

import Foundation

protocol Routing {
	var path: [Screen] { get set }
	func navigate(to screen: Screen)
}
