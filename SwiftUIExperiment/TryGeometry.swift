//
//  TryGeometry.swift
//  SwiftUIExperiment
//
//  Created by Zhihui Tang on 10/6/20.
//

import SwiftUI

struct OuterView: View {
    var body: some View {
        VStack {
            Text("Top")
            InnerView()
                .background(Color.green)
            Text("Bottom")
        }
    }
}


struct InnerView: View {
    var body: some View {
        HStack {
            Text("Left")
            GeometryReader { geo in
              
                Text("Center")
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    .background(Color.blue)
                    .onTapGesture {
                        print("Global center: \(geo.frame(in: .global).midX) x \(geo.frame(in: .global).midY)")
                        print("Custom center: \(geo.frame(in: .named("Custom")).midX) x \(geo.frame(in: .named("Custom")).midY)")
                        print("Local center: \(geo.frame(in: .local).midX) x \(geo.frame(in: .local).midY)")
                    }
                   
            }
            .background(Color.orange)
            Text("Right")
        }
    }
}

// https://www.hackingwithswift.com/books/ios-swiftui/understanding-frames-and-coordinates-inside-geometryreader
struct TryGeometry: View {
    var body: some View {
        OuterView()
            .background(Color.red)
            .coordinateSpace(name: "Custom")
    }
}

struct TryGeometry_Previews: PreviewProvider {
    static var previews: some View {
        TryGeometry()
    }
}
