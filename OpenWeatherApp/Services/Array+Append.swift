//
//  Array+Append.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 30/09/2020.
//

import Foundation

extension Array {
    mutating func appendIfNotNull(_ newElement: Element?) {
        guard let element = newElement else {
            return
        }
        append(element)
    }

    mutating func appendIfNotNull(_ contentsOf: [Element?]) {
        for newElement in contentsOf {
            appendIfNotNull(newElement)
        }
    }
}
