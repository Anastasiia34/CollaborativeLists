//
//  ItemView.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 23.04.2026.
//

import SwiftUI

struct ItemView: View {
	let item: Item
	let onCheck: () -> Void
	
    var body: some View {
		HStack {
			Button(action: onCheck){
				Image(systemName: item.completed ? "checkmark.square" : "square")
					.font(.title2)
			}
			
			Text(item.title)
		}
    }
}

#Preview {
	ItemView(item: Item.sample, onCheck: {})
}
