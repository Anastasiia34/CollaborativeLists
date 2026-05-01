//
//  AddEditorView.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 27.04.2026.
//

import SwiftUI

struct AddEditorView: View {
	let isProcessing: Bool
	let inviteAction: (String) -> Void
	
	@State private var isTextFieldVisible = false
	@State private var text = ""
	@FocusState private var isFocused
	
    var body: some View {
		VStack {
			if !isTextFieldVisible {
				plusButton
			} else {
				inputForm
			}
		}
		.buttonStyle(.borderless)
		.spinnerOverlay(isVisible: isProcessing)
		.onChange(of: isProcessing) { _, newValue in
			if !newValue, !text.isEmpty {
				resetView()
			}
		}
    }
	
	private var plusButton: some View {
		Button {
			isTextFieldVisible = true
			isFocused = true
		} label: {
			Image(systemName: "plus")
		}
		.frame(maxWidth: .infinity, alignment: .center)
	}
	
	private var inputForm: some View {
		VStack {
			TextField("Enter email...", text: $text)
				.focused($isFocused)
			
			HStack {
				Button("Invite") {
					inviteAction(text)
				}
				
				Button("Cancel") {
					resetView()
				}
			}
		}
	}
	
	private func resetView() {
		isTextFieldVisible = false
		isFocused = false
		text = ""
	}
}

#Preview {
	SwiftUI.List {
		AddEditorView(isProcessing: false, inviteAction: { _ in })
	}
}
