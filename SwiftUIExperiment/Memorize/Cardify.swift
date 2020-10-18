//
//  Cardify.swift
//  SwiftUIExperiment
//
//  Created by Zhihui Tang on 10/9/20.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var rotation: Double
    var isFaceUp: Bool {
        rotation < 90
    }
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    func body(content: Content) -> some View {
        print("animatableData: \(animatableData)")
        return ZStack {
            Group {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
            }
            .opacity(isFaceUp ? 1 : 0)
            RoundedRectangle(cornerRadius: cornerRadius)
            .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(
            Angle(degrees: rotation),
            axis: (0,1,0)
            )
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    let cornerRadius: CGFloat = 10
    let edgeLineWidth: CGFloat = 3
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp))
    }
}
