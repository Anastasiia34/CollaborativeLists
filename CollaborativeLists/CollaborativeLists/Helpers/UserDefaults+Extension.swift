//
//  UserDefaults+Extension.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 15.04.2026.
//

import Foundation

extension UserDefaults {
	func get<T>(forKey key: UserDefaultsKey) -> T? {
		value(forKey: key.rawValue) as? T
	}
	
	func set<T>(_ value: T, forKey key: UserDefaultsKey) {
		set(value, forKey: key.rawValue)
	}
}
