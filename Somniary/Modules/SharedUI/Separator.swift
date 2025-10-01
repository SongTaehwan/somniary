//
//  Separator.swift
//  Somniary
//
//  Created by 송태환 on 9/29/25.
//

import SwiftUI

struct Separator: View {

    enum Orientation {
        case horizontal, vertical
    }

    private let orientation: Orientation
    private let thickness: CGFloat
    private let color: Color

    init(
        orientation: Orientation = .horizontal,
        thickness: CGFloat = 1,
        color: Color = .gray.opacity(0.25)
    ) {
        self.orientation = orientation
        self.thickness = thickness
        self.color = color
    }

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(
                maxWidth: orientation == .vertical ? thickness : nil,
                maxHeight: orientation == .horizontal ? thickness : nil
            )
    }
}

#Preview {
    VStack {
        Separator(orientation: .horizontal, thickness: 4)
        Separator(orientation: .vertical, thickness: 4)
    }
}
