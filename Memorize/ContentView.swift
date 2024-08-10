//
//  ContentView.swift
//  Memorize
//
//  Created by Theo Steiner on 2024/08/10.
//

import SwiftUI

struct ContentView: View {
    let emojis = [    "🚗",    "🚕",    "✈️",    "🚢",    "🚂",    "🚁",    "🛵",    "🚀",    "🚲",    "🛴", "🚟",    "🚠",    "🚡",    "🛸",   "🚙",    "🚎",    "🚐",    "🚒",    "🚑",    "🚓",    "🏎️",   "🚌",     "🚚",    "🚛",    "🚜"]
    @State var visibleEmojiCount = 3
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid (columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(emojis[0..<visibleEmojiCount], id: \.self ) { emoji in
                        CardView(content: emoji)
                            .aspectRatio(2/3,contentMode: .fit)
                    }
                }
            }
            .foregroundColor(.red)
            Spacer()
            HStack {
                remove
                Spacer()
                add
            }
            .font(.largeTitle)
            .padding(.horizontal)
        }
        .padding(.horizontal)
        }
    var remove: some View {
        Button {
            if (visibleEmojiCount > 1) {
                visibleEmojiCount -= 1
            }
        } label: {
            Image(systemName: "minus.circle")
        }
    }
    var add: some View {
        Button {
            if (visibleEmojiCount < emojis.count) {
                visibleEmojiCount += 1
            }
        } label: {
            Image(systemName: "plus.circle")
        }
    }
}

struct CardView: View {
    var content: String
    @State var isFaceUp = true
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}

#Preview {
    ContentView()
}
