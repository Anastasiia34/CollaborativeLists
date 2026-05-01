//
//  MembersView.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 24.04.2026.
//

import SwiftUI

struct MembersView: View {
	@State private var viewModel: MembersViewModel
	
	@Environment(\.listManager) private var listManager
	@Environment(\.router) private var router
	@Environment(\.alertManager) private var alertManager
	
	init(details: ListDetails, access: ListAccess) {
		_viewModel = State(initialValue: MembersViewModel(details: details, access: access))
	}
	
    var body: some View {
		VStack {
			SwiftUI.List {
				ForEach(viewModel.details.members) { member in
					MemberView(member: member)
						.swipeActions {
							if viewModel.access == .owner, member.role != .owner {
								Button(role: .destructive) {
									Task {
										await viewModel.deleteMember(member)
									}
								} label: {
									Image(systemName: "trash")
								}
							}
						}
				}
				
				if viewModel.access == .owner {
					AddEditorView(isProcessing: viewModel.isAddingEditor) { email in
						Task {
							await viewModel.addMember(email: email)
						}
					}
				}
			}
		}
		.navigationTitle("Members")
		.onAppear {
			viewModel.configure(listManager: listManager, alertManager: alertManager)
		}
    }
}

#Preview {
	MembersView(details: ListDetails.sample, access: .owner)
}
