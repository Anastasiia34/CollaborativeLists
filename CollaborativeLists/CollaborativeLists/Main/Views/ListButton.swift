//
//  ListButton.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 21.04.2026.
//

import SwiftUI

struct ListButton: View {
	let list: List
	let action: () -> Void
	
    var body: some View {
		Button(action: action) {
			HStack {
				VStack(alignment: .leading) {
					Text(list.title)
						.font(.title3)
						.foregroundStyle(.black)
						.lineLimit(1)
					
					Text(list.updatedAtString)
						.font(.caption)
						.foregroundStyle(.gray)
				}
				
				Spacer()
				
				if list.access == .owner {
					Text("owner")
						.font(.caption)
						.foregroundStyle(.black)
				}
			}
			.padding()
		}
    }
}

#Preview {
	ListButton(list: List.sample) {}
}
