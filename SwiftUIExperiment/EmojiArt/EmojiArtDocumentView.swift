//
//  EmojiArtDocumentView.swift
//  SwiftUIExperiment
//
//  Created by Zhihui Tang on 10/11/20.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(EmojiArtDocument.palette.map { String($0) }) { emoji in
                    Text(emoji).font(.system(size: 40))
                }
            }
        }.padding(.horizontal)
    }
}
