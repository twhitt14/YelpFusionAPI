//
//  Business.swift
//
//
//  Created by Trevor Whittingham on 9/13/21.
//  Copyright © 2021 Retro LLC. All rights reserved.
//

import Foundation

public struct Business: Codable {
    public var openNow: Bool?
    
    public let categories: [Category]?
    public let coordinates: Coordinate?
    public let display_phone: String?
    public let distance: Double?
    public let id: String?
    public let alias: String?
    public let image_url: String?
    public let is_closed: Bool?
    public let location: Location?
    public let name: String?
    public let phone: String?
    public let price: String?
    public let rating: Double?
    public let review_count: Int?
    public let url: String?
    public let transactions: [String]?
}
