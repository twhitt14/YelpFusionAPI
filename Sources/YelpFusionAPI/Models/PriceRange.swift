//
//  PriceRange.swift
//
//
//  Created by Trevor Whittingham on 9/13/21.
//  Copyright © 2021 Retro LLC. All rights reserved.
//

import Foundation

public class PriceRange {
    var minPrice: PricePoint
    var maxPrice: PricePoint
    
    init(minPrice: PricePoint = .one, maxPrice: PricePoint = .four) {
        self.minPrice = minPrice
        self.maxPrice = maxPrice
    }
    
    var yelpAPIPriceRange: String {
        guard minPrice != maxPrice else {
            return String(minPrice.rawValue)
        }
        
        var priceRangeString = ""
        (minPrice.rawValue...maxPrice.rawValue).forEach { rawValue in
            if priceRangeString == "" {
                priceRangeString = String(rawValue)
            } else {
                priceRangeString.append(",\(rawValue)")
            }
        }
        return priceRangeString
    }
}

// MARK: -
// MARK: CustomStringConvertible

extension PriceRange: CustomStringConvertible {
    public var description: String {
        return "PriceRange(minPrice: \(minPrice), maxPrice: \(maxPrice))"
    }
}

// MARK: -
// MARK: Equatable

extension PriceRange: Equatable {
    public static func == (lhs: PriceRange, rhs: PriceRange) -> Bool {
        return lhs.minPrice == rhs.minPrice && lhs.maxPrice == rhs.maxPrice
    }
}

// MARK: -
// MARK: Yelp API

extension PriceRange {
    
}
