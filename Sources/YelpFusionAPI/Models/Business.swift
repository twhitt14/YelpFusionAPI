//
//  Business.swift
//
//
//  Created by Trevor Whittingham on 9/13/21.
//  Copyright © 2021 Retro LLC. All rights reserved.
//

import Foundation

public struct Business: Codable {
    var openNow: Bool?
    
    let categories: [Category]?
    let coordinates: Coordinate?
    let display_phone: String?
    let distance: Double?
    let id: String?
    let alias: String?
    let image_url: String?
    let is_closed: Bool?
    let location: Location?
    let name: String?
    let phone: String?
    let price: String?
    let rating: Double?
    let review_count: Int?
    let url: String?
    let transactions: [String]?
}
