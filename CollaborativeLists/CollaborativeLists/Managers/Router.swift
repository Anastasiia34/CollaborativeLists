//
//  Router.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 13.04.2026.
//

import SwiftUI

@Observable
final class Router: Routing {
    var path: [Screen] = []
    
    func navigate(to screen: Screen) {
        path.append(screen)
    }
    
    func navigateBack() {
        _ = path.popLast()
    }
    
    func navigateToRoot() {
        path.removeAll()
    }
}
