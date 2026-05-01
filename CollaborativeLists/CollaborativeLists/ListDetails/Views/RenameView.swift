//
//  RenameView.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 24.04.2026.
//

import SwiftUI

struct RenameView: View {
	let action: (String) -> Void
	@State private var text: String
	
	init(currentTitle: String, action: @escaping (String) -> Void) {
		self.action = action
		_text = State(initialValue: currentTitle)
	}
	
    var body: some View {
		VStack {
			TextField("Title", text: $text)
				.textFieldStyle(.roundedBorder)
				.padding(.bottom)
			
			Button("Rename") {
				action(text)
			}
			.buttonStyle(.borderedProminent)
		}
		.padding()
		.presentationDetents([.medium])
    }
}

#Preview {
	RenameView(currentTitle: "Title", action: { _ in })
}
