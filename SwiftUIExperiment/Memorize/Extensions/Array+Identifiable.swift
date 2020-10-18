//
//  Array+Identifiable.swift
//  SwiftUIExperiment
//
//  Created by Zhihui Tang on 10/8/20.
//
import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
}



extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
