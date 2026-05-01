//
//  View+Extension.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 22.04.2026.
//

import SwiftUI

extension View {
	func alert(usingManager manager: AlertManager) -> some View {
		alert(manager.currentAlert?.title ?? "", isPresented: .constant(manager.currentAlert != nil)) {
			Button("OK") {
				manager.clear()
			}
		} message: {
			Text(manager.currentAlert?.message ?? "")
		}
	}
	
	func spinnerOverlay(isVisible: Bool) -> some View {
		overlay {
			if isVisible {
				ZStack {
					Color.white
						.opacity(0.3)
					
					ProgressView()
				}
				.ignoresSafeArea()
			}
		}
	}
	
}
