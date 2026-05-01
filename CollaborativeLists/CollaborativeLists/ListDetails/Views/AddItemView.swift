//
//  AddItemView.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 23.04.2026.
//

import SwiftUI

struct AddItemView: View {
	let action: (String) -> Void
	
	@State private var text = ""
	
    var body: some View {
		HStack {
			TextField("Type title...", text: $text)
			
			Button("Add Item") {
				action(text)
				text = ""
			}
		}
    }
}

#Preview {
    AddItemView(action: { _ in })
}
