//
//  NoListsView.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 29.04.2026.
//

import SwiftUI

struct NoListsView: View {
    var body: some View {
		VStack {
			Spacer()
			
			Text("No lists yet. Tap + to add one.")
				.foregroundStyle(.gray)
			
			Spacer()
		}
    }
}

#Preview {
    NoListsView()
}
