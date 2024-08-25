//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Theo Steiner on 2024/08/10.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @Bindable var game: EmojiMemoryGame
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        VStack {
            ZStack (alignment: .bottom) {
                gameBody
                deckBody
            }
            HStack {
                restart
                Spacer()
                shuffle
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal (_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt (_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation (_ card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: {card.id == $0.id}) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex (_ card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: {card.id == $0.id}) ?? 0)
    }

    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: CardConstants.aspectRatio) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card: card)
                    .zIndex(zIndex(card))
                    .matchedGeometryEffect(
                        id: card.id, in: dealingNamespace
                    )
                    .padding(CardConstants.padding)
                    .transition(
                        .asymmetric(
                            insertion: .identity,
                            removal: .scale
                        )
                    )
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }
        }
        .foregroundColor(CardConstants.color)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { undealtCard in
                CardView(card: undealtCard)
                    .transition(
                        .asymmetric(
                            insertion: .opacity,
                            removal: .identity
                        )
                    )
                    .zIndex(zIndex(undealtCard))
                    .matchedGeometryEffect(
                        id: undealtCard.id, in: dealingNamespace
                    )
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            // deal cards
            for card in game.cards {
                withAnimation (dealAnimation(card)) {
                    deal(card)
                }
            }
        }
    }
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation{
                game.shuffle()
            }
        }
    }
    
    var restart: some View {
        Button("Restart") {
            withAnimation{
                game.restart()
                dealt = []
            }
        }
    }

    private struct CardConstants {
        static let color = Color.red
        static let padding: CGFloat = 4
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
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
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.easeInOut(duration: 1), value: card.isMatched)
                    .font(calculateFontSize(in: geometry.size))
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

    EmojiMemoryGameView(game: game)
}
