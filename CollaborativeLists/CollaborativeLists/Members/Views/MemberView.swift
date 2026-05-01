//
//  MemberView.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 24.04.2026.
//

import SwiftUI

struct MemberView: View {
	let member: ListMember
	
    var body: some View {
		HStack(spacing: 10) {
			Text(member.email)
			
			Spacer()
			
			if member.role == .owner {
				Text(member.role.rawValue)
					.foregroundStyle(.gray)
			}
		}
    }
}

#Preview {
	MemberView(member: ListMember(id: UUID(), email: "kjwkjwlkjelrkr;vke;lsl;wmcl;mcwl;mcregj@dlvknv", role: .owner))
}
