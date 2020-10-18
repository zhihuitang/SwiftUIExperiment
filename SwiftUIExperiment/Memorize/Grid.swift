//
//  Grid.swift
//  SwiftUIExperiment
//
//  Created by Zhihui Tang on 10/8/20.
//

import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    var items: [Item]
    var viewForItem: (Item) -> ItemView
    var body: some View {
        GeometryReader { geometry in
            let gridLayout = GridLayout(itemCount: items.count, in: geometry.size)
            ForEach(items) { item in
                viewForItem(item)
                    .frame(width: gridLayout.itemSize.width, height: gridLayout.itemSize.height)
                    .position(gridLayout.location(ofItemAt: items.firstIndex(matching: item) ?? 0))
            }
        }
    }
}

struct Grid_Previews: PreviewProvider {
    static var previews: some View {
        //Grid()
        Text("Hello grid")
    }
}
