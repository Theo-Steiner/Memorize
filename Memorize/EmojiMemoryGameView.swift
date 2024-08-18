//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Theo Steiner on 2024/08/10.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @Bindable var game: EmojiMemoryGame
    
    var body: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if card.isMatched && !card.isFaceUp {
                Rectangle().opacity(0)
            } else {
                CardView(card: card)
                    .padding(4)
                    .onTapGesture {
                        game.choose(card)
                    }
            }
        }
        .foregroundColor(.red)
        .padding(.horizontal)
    }
}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Pie(
                    // subtract 90 from angles, since 0 degs is to the right in SwiftUI
                    startAngle: Angle(degrees: 0 - 90),
                    endAngle: Angle(degrees: 110 - 90)
                ).padding(5).opacity(0.5)
                Text(card.content).font(calculateFontSize(in: geometry.size))
            }.cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func calculateFontSize (in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.7
    }
}

#Preview {
    let game = EmojiMemoryGame()
    let _ = game.choose(game.cards.first!)

    EmojiMemoryGameView(game: game)
}
