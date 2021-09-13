//
//  BusinessSearchResponse.swift
//
//
//  Created by Trevor Whittingham on 9/13/21.
//  Copyright © 2021 Retro LLC. All rights reserved.
//

import Foundation

public struct BusinessSearchResponse: Codable {
    let total: Int?
    let businesses: [Business]
    let region: Region?
}
