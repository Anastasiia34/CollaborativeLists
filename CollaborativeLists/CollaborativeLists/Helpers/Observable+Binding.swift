//
//  Observable+Binding.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 15.04.2026.
//

import SwiftUI

extension Observable {
	func binding<Value>(for keyPath: ReferenceWritableKeyPath<Self, Value>) -> Binding<Value> {
		Binding(
			get: { self[keyPath: keyPath] },
			set: { self[keyPath: keyPath] = $0 }
		)
	}
}
