//
//  Location.swift
//
//
//  Created by Trevor Whittingham on 9/13/21.
//  Copyright © 2021 Retro LLC. All rights reserved.
//

import Foundation

public struct Location: Codable {
    public let address1: String?
    public let address2: String?
    public let address3: String?
    public let city: String?
    public let country: String?
    public let display_address: [String]?
    public let state: String?
    public let zip_code: String?
}
