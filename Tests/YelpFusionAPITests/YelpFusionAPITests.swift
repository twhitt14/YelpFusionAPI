//
//  YelpFusionAPITests.swift
//
//
//  Created by Trevor Whittingham on 9/13/21.
//  Copyright © 2021 Retro LLC. All rights reserved.
//

import XCTest
import CoreLocation

import YelpFusionAPI

@available(iOS 15.0.0, *)
@available(macOS 12.0.0, *)
@available(watchOS 8.0.0, *)
@available(tvOS 15.0.0, *)
final class YelpFusionAPITests: XCTestCase {
    
    let apiKey = "PUT_YOUR_API_KEY_HERE_TO_TEST__BUT__REMEMBER_NOT_TO_COMMIT_YOUR_KEY_TO_A_PUBLIC_REPOSITORY"
    let searchCoordinates = Coordinate(latitude: 37.33187177000945, longitude: -122.03014607905845)
    
//    func testGetNearbyRestaurants() async throws {
//        let yelpAPI = YelpFusionAPIModel(yelpAPIKey: apiKey)
//        
//        let restaurants = try await yelpAPI.getNearbyRestaurants(location: searchCoordinates, radiusInMeters: 5000, foodTypes: [], priceRange: PriceRange(minPrice: .one, maxPrice: .four), openNow: false)
//        
//        XCTAssertTrue(!restaurants.isEmpty)
//    }
//    
//    func testSearchForRestaurants() async throws {
//        let yelpAPI = YelpFusionAPIModel(yelpAPIKey: apiKey)
//        
//        let restaurants = try await yelpAPI.searchForRestaurantsWith(term: "pizza", near: searchCoordinates)
//        
//        XCTAssertTrue(!restaurants.isEmpty)
//    }
    
    func testCreateURLForYelpAPI1() {
        let yelpAPI = YelpFusionAPIModel(yelpAPIKey: apiKey)
        let latitude = 1.0
        let longitude = 1.0
        let searchRadius = 500
        let foodTypes: [FoodType] = [.burgers, .hawaiian, .sushi]
        let priceRange = PriceRange(minPrice: .two, maxPrice: .three)
        let openNow = false
        let resultLimit = 25
        
        let url = yelpAPI.createYelpURL(location: .init(latitude: latitude, longitude: longitude), radiusInMeters: searchRadius, foodTypes: foodTypes, priceRange: priceRange, openNow: openNow, resultLimit: resultLimit)
        
        XCTAssertEqual(
            url!.absoluteString,
            "https://api.yelp.com/v3/businesses/search?limit=25&sort_by=rating&price=2,3&latitude=1.0&longitude=1.0&radius=500&open_now=false&categories=burgers,hawaiian,sushi"
        )
    }
    
    func testCreateURLForYelpAPI2() {
        let yelpAPI = YelpFusionAPIModel(yelpAPIKey: apiKey)
        let latitude = -111.3
        let longitude = 44.5
        let searchRadius = 123211
        let foodTypes: [FoodType] = []
        let priceRange = PriceRange(minPrice: .one, maxPrice: .one)
        let openNow = true
        let resultLimit = 25
        
        let url = yelpAPI.createYelpURL(location: .init(latitude: latitude, longitude: longitude), radiusInMeters: searchRadius, foodTypes: foodTypes, priceRange: priceRange, openNow: openNow, resultLimit: resultLimit)
        
        XCTAssertEqual(
            url!.absoluteString,
            "https://api.yelp.com/v3/businesses/search?limit=25&sort_by=rating&price=1&latitude=-111.3&longitude=44.5&radius=123211&open_now=true"
        )
    }
    
    func testCreateURLForYelpAPI3() {
        let yelpAPI = YelpFusionAPIModel(yelpAPIKey: apiKey)
        let latitude = 11.1
        let longitude = 10.1
        let searchRadius = 53234234
        let foodTypes: [FoodType] = [.burgers]
        let priceRange = PriceRange(minPrice: .one, maxPrice: .four)
        let openNow = true
        let resultLimit = 50
        
        let url = yelpAPI.createYelpURL(location: .init(latitude: latitude, longitude: longitude), radiusInMeters: searchRadius, foodTypes: foodTypes, priceRange: priceRange, openNow: openNow, resultLimit: resultLimit)
        
        XCTAssertEqual(
            url!.absoluteString,
            "https://api.yelp.com/v3/businesses/search?limit=50&sort_by=rating&price=1,2,3,4&latitude=11.1&longitude=10.1&radius=53234234&open_now=true&categories=burgers"
        )
    }
}
