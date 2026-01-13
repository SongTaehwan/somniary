//
//  DialogOverlay.swift
//  Somniary
//
//  Created by 송태환 on 1/13/26.
//

import SwiftUI

struct DialogOverlay<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.4)
                .ignoresSafeArea()

            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    DialogOverlay {
        Text("Hello, World!")
    }
}
