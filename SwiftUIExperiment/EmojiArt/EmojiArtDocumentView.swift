//
//  EmojiArtDocumentView.swift
//  SwiftUIExperiment
//
//  Created by Zhihui Tang on 10/11/20.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    @State private var steadyStateZoomScale: CGFloat = 1
    @GestureState private var gestureZoomScale: CGFloat = 1
    
    @State private var steadyStatePanOffset: CGSize = .zero
    @GestureState private var gesturePanOffset: CGSize = .zero
    
    private var zoomScale : CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }
    
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(EmojiArtDocument.palette.map { String($0) }) { emoji in
                        Text(emoji).font(.system(size: defaultEmojiSize))
                            .onDrag { NSItemProvider(object: emoji as NSString) }
                    }
                }
            }
            .padding(.horizontal)
            
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .overlay(
                            OptionalImage(uiImage: self.document.backgroundImage)
                                .scaleEffect(self.zoomScale)
                                .offset(self.panOffset)
                        )
                        .gesture(self.doubleTapToZoom(in: geometry.size))
                    
                    ForEach(self.document.emojis) { emoji in
                        Text(emoji.text)
                            //.font((self.font(for: emoji)))
                            .font(animatableWithSize: emoji.fontSize * self.zoomScale)
                            .position(position(for: emoji, in: geometry.size))
                    }
                    
                }
                .clipped()
                .gesture(self.panGesture())
                .gesture(self.zoomGesture())
                .navigationTitle("Emoji Art")
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                    var location = geometry.convert(location, from: .global)
                    location = CGPoint(x: location.x - geometry.size.width / 2, y: location.y - geometry.size.height / 2)
                    location = CGPoint(x: location.x - self.panOffset.width, y: location.y - self.panOffset.height)
                    location = CGPoint(x: location.x / self.zoomScale, y: location.y / self.zoomScale)
                    return self.drop(providers: providers, at: location)
                }
            }
        }
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale,ourGestureStateInOut, transaction in
                ourGestureStateInOut = latestGestureScale
            }
            .onEnded { finalGestureScale in
                self.steadyStateZoomScale *= finalGestureScale
            }
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { (latestDragGestureValue, gesturePanOffset, transaction) in
                gesturePanOffset = latestDragGestureValue.translation / self.zoomScale
            }
            .onEnded { finalDragGestureValue in
                self.steadyStatePanOffset = self.steadyStatePanOffset + (finalDragGestureValue.translation / self.zoomScale)
            }
    }
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    self.zoomToFit(self.document.backgroundImage, in: size)
                }
            }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0 , image.size.height > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            steadyStatePanOffset = .zero
            self.steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
    
    private func font(for emoji: EmojiArt.Emoji) -> Font {
        Font.system(size: emoji.fontSize * self.zoomScale)
    }
    
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location =  CGPoint(x: location.x + size.width / 2, y: location.y + size.height / 2)
        location = CGPoint(x: location.x + panOffset.width, y: location.y + panOffset.height)
        return location
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadObjects(ofType: URL.self) { url in
            print("dropped: \(url.absoluteString)")
            self.document.setBackgroundURL(url)
        }
        
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                self.document.addEmoji(string, at: location, size: defaultEmojiSize)
            }
        }
        
        return found
    }
    
    private let defaultEmojiSize: CGFloat = 40
}

struct EmojiArtDocumentView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
