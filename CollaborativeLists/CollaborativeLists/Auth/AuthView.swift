//
//  AuthView.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 15.04.2026.
//

import SwiftUI

struct AuthView: View {
	@State private var viewModel = AuthViewModel()
	@Environment(\.sessionStore) private var sessionStore
	@Environment(\.authManager) private var authManager
	@Environment(\.router) private var router
	@Environment(\.alertManager) private var alertManager
	
	var body: some View {
		VStack {
			Picker("", selection: $viewModel.state) {
				Text("Log in")
					.tag(AuthMode.login)
				
				Text("Register")
					.tag(AuthMode.register)
			}
			.pickerStyle(.segmented)
			.padding(.top)
			
			Spacer()
			
			TextField("Enter email", text: $viewModel.emailText)
				.textFieldStyle(.roundedBorder)
			
			SecureField("Enter password", text: $viewModel.passwordText)
				.textFieldStyle(.roundedBorder)
			
			Text(viewModel.errorText)
				.frame(maxWidth: .infinity, alignment: .leading)
				.multilineTextAlignment(.leading)
				.font(.system(.footnote))
				.foregroundStyle(.red)
			
			Spacer()
			
			Button("Confirm") {
				viewModel.confirmButtonTapped()
			}
			.buttonStyle(.borderedProminent)
			.controlSize(.large)
			.padding(.bottom)
		}
		.padding()
		.toolbar(.hidden)
		.onAppear {
			viewModel.configure(sessionStore: sessionStore, authManager: authManager, router: router, alertManager: alertManager)
		}
	}
}

#Preview {
	AuthView()
}
