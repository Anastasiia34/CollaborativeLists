//
//  AlertManager.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 22.04.2026.
//

import SwiftUI

@Observable
final class AlertManager: AlertManaging {
	var currentAlert: AlertItem?
	
	func report(_ error: AppError) {
		guard let localizedAlertError = LocalizedAlertError(error: error), let description = localizedAlertError.errorDescription else {
			return
		}
		
		currentAlert = AlertItem(title: description, message: localizedAlertError.recoverySuggestion)
	}
	
	func clear() {
		currentAlert = nil
	}
}
