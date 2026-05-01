//
//  ListCreationView.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 22.04.2026.
//

import SwiftUI

struct ListCreationView: View {
	@State private var viewModel = ListCreationViewModel()
	@FocusState private var isFocused
	
	@Environment(\.listManager) private var listManager
	@Environment(\.router) private var router
	@Environment(\.alertManager) private var alertManager
	
    var body: some View {
		VStack {
			Spacer()
			
			Text("Title")
				.font(.title2)
			
			TextField("Enter title", text: $viewModel.title)
				.focused($isFocused)
				.textFieldStyle(.roundedBorder)
						
			Spacer()
			
			Button("Create") {
				viewModel.createButtonTapped()
			}
			.buttonStyle(.borderedProminent)
			.controlSize(.large)
			.padding(.bottom)
			.disabled(viewModel.isCreating)
		}
		.padding()
		.navigationTitle("Create List")
		.onAppear {
			isFocused = true
			viewModel.configure(listManager: listManager, router: router, alertManager: alertManager)
		}
    }
}

#Preview {
    ListCreationView()
}
