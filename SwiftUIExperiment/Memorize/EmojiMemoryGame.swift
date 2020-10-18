//
//  CardContent.swift
//  SwiftUIExperiment
//
//  Created by Zhihui Tang on 10/7/20.
//

import Foundation
import SwiftUI

let emojis = ["想", "🦄", "👞", "👟"]//, "🥾", "👛", "🦊", "🐯", "🦧", "⛑", "🦁", "🐽", "🐸"]

// https://www.youtube.com/watch?v=4GjXq2Sr55Q&feature=youtu.be&ab_channel=Stanford
class EmojiMemoryGame: ObservableObject {
    @Published private(set) var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfCards: emojis.count) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func resetGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
