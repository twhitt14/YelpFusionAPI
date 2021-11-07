//
//  YelpFusionAPITests.swift
//
//
//  Created by Trevor Whittingham on 9/13/21.
//  Copyright © 2021 Retro LLC. All rights reserved.
//

import XCTest
import YelpFusionAPI

@available(iOS 15.0.0, *)
@available(macOS 12.0.0, *)
@available(watchOS 8.0.0, *)
@available(tvOS 15.0.0, *)
final class YelpFusionAPITests: XCTestCase {
    
    let apiKey = "PUT_YOUR_API_KEY_HERE_TO_TEST__BUT__REMEMBER_NOT_TO_COMMIT_YOUR_KEY_TO_A_PUBLIC_REPOSITORY"
    let searchCoordinates = Coordinate(latitude: 37.33187177000945, longitude: -122.03014607905845)
    
    func testGetNearbyRestaurants() async throws {
        let yelpAPI = YelpFusionAPIModel(yelpAPIKey: apiKey)
        
        let restaurants = try await yelpAPI.getNearbyRestaurants(location: searchCoordinates, radiusInMeters: 5000, foodTypes: [], priceRange: PriceRange(minPrice: .one, maxPrice: .four), openNow: false)
        
        XCTAssertTrue(!restaurants.isEmpty)
    }
    
    func testSearchForRestaurants() async throws {
        let yelpAPI = YelpFusionAPIModel(yelpAPIKey: apiKey)
        
        let restaurants = try await yelpAPI.searchForRestaurantsWith(term: "pizza", near: searchCoordinates)
        
        XCTAssertTrue(!restaurants.isEmpty)
    }
}
