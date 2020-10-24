//
//  EmojiArtDocument.swift
//  SwiftUIExperiment
//
//  Created by Zhihui Tang on 10/11/20.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    static let palette = "🐝🐼🐯🐸🐓🍎🍏🦧"
    
    @Published private var emojiArt: EmojiArt {
        didSet {
            print("Emoji: \(emojiArt.json?.utf8 ?? "nil")")
            UserDefaults.standard.setValue(emojiArt.json, forKey: EmojiArtDocument.untitled)
        }
    }

    private static let untitled = "EmojiArtDocument.Untitled1"
    
    init() {
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt()
        fetchBackgroundImageData()
    }

    @Published private(set) var backgroundImage: UIImage?
    var emojis: [EmojiArt.Emoji] {
        return emojiArt.emojis
    }
    
    // MARK: - Intents(s)
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        guard let index = emojiArt.emojis.firstIndex(matching: emoji) else {
            return
        }
        
        emojiArt.emojis[index].x += Int(offset.width)
        emojiArt.emojis[index].y += Int(offset.height)
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        guard let index = emojiArt.emojis.firstIndex(matching: emoji) else {
            return
        }
        
        emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
    }
    
    func setBackgroundURL(_ url: URL?) {
        emojiArt.backgroundURL = url?.imageURL
        fetchBackgroundImageData()
    }
    
    private func fetchBackgroundImageData() {
        backgroundImage = nil
        guard let url = self.emojiArt.backgroundURL else {
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageData = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    if url == self.emojiArt.backgroundURL {
                        self.backgroundImage = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}


extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y))}
}
