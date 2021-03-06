//
//  Array+Identifiable.swift
//  SwiftUIExperiment
//
//  Created by Zhihui Tang on 10/8/20.
//
import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
