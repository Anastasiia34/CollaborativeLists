//
//  SplashView.swift
//  CollaborativeLists
//
//  Created by Hello Kitty on 13.04.2026.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
		VStack {
			Spacer()
			
			ProgressView()
				.padding(.bottom)
			
			Text("Checking auth state...")
				.foregroundStyle(.gray)
			
			Spacer()
		}
		.frame(maxWidth: .infinity)
		.background(.white)
    }
}

#Preview {
    SplashView()
}
