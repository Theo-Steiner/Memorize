//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Theo Steiner on 2024/08/10.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
