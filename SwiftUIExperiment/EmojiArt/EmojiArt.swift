//
//  EmojiArt.swift
//  SwiftUIExperiment
//
//  Created by Zhihui Tang on 10/18/20.
//

import Foundation

struct EmojiArt: Codable {
    var backgroundURL: URL?
    var emojis = [Emoji]()
    
    struct Emoji: Identifiable, Codable {
        let text: String
        var x: Int
        var y: Int
        var size: Int
        var id: Int
        
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
            
    init() {}
    
    init?(json: Data?) {
        guard let json = json, let newEmojiArt = try? JSONDecoder().decode(EmojiArt.self, from: json) else {
            return nil
        }
        self = newEmojiArt
    }
    
    var json: Data? {
        try? JSONEncoder().encode(self)
    }
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: x, y: y, size: size, id: uniqueEmojiId))
    }
}
