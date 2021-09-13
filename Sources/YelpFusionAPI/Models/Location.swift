//
//  Location.swift
//
//
//  Created by Trevor Whittingham on 9/13/21.
//  Copyright © 2021 Retro LLC. All rights reserved.
//

import Foundation

public struct Location: Codable {
    let address1: String?
    let address2: String?
    let address3: String?
    let city: String?
    let country: String?
    let display_address: [String]?
    let state: String?
    let zip_code: String?
}
