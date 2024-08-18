//
//  Cardify.swift
//  Memorize
//
//  Created by Theo Steiner on 2024/08/18.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool

    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                Pie(
                    // subtract 90 from angles, since 0 degs is to the right in SwiftUI
                    startAngle: Angle(degrees: 0 - 90),
                    endAngle: Angle(degrees: 110 - 90)
                ).padding(5).opacity(0.5)
                content
            } else {
                shape.fill()
            }
        }
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 20
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify (isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
