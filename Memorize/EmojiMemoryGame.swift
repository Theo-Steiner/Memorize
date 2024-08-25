//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Theo Steiner on 2024/08/10.
//

import SwiftUI

@Observable class EmojiMemoryGame {
    typealias Card = MemoryGame<String>.Card
    private static let emojis = ["🚗","🚕","✈️","🚢","🚂","🚁","🛵","🚀","🚲","🛴","🚟","🚠","🚡","🛸","🚙","🚎","🚐","🚒","🚑","🚓","🏎️","🚌","🚚","🚛","🚜"]
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 5) { index in
            emojis[index]
        }
    }
    
    private var model = createMemoryGame()
    
    var cards: Array<Card> {
        return model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
