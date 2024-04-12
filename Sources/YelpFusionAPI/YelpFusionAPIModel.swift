//
//  YelpFusionAPIModel.swift
//
//
//  Created by Trevor Whittingham on 9/13/21.
//  Copyright © 2021 Retro LLC. All rights reserved.
//

import Foundation
import RetroNetworking

@available(iOS 15.0.0, *)
@available(macOS 12.0.0, *)
@available(watchOS 8.0.0, *)
@available(tvOS 15.0.0, *)
public final class YelpFusionAPIModel {
    
    struct Keys {
        static let authorization = "Authorization"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let limit = "limit"
        static let term = "term"
        static let categories = "categories"
    }
    
    // MARK: -
    // MARK: Properties
    
    private let yelpAPIKey: String
    private lazy var yelpAPIAuthString = "Bearer \(yelpAPIKey)"
    private let yelpAPIBaseURL = "https://api.yelp.com/v3/"
    private let yelpAPISearchPath = "businesses/search"
    private lazy var yelpAPIAuthHeader = NetworkHeader(key: Keys.authorization, value: yelpAPIAuthString)
    private let yelpAPIDefaultResultLimit: Int // max is 50
    private let yelpAPIRestaurantCategories = "restaurants,food"
    
    // MARK: -
    // MARK: Init
    
    public init(yelpAPIKey: String, yelpAPIResultLimit: Int = 50) {
        self.yelpAPIKey = yelpAPIKey
        self.yelpAPIDefaultResultLimit = min(max(yelpAPIResultLimit, 0), 50)
    }
    
    // MARK: -
    // MARK: Private methods
    
    private func createRestaurantsFrom(data: Data) throws -> [Business] {
        let response = try JSONDecoder().decode(BusinessSearchResponse.self, from: data)

        return response.businesses
    }
    
    // MARK: -
    // MARK: Public methods
    
    public func createYelpURL(location: Coordinate, radiusInMeters: Int, foodTypes: [FoodType], priceRange: PriceRange, openNow: Bool, resultLimit: Int) -> URL? {
        
        let latitude = location.latitude
        let longitude = location.longitude
        
        let price = priceRange.yelpAPIPriceRange
        
        let parameterStrings = [
            "limit=\(resultLimit)",
            "sort_by=rating",
            "price=\(price)",
            "latitude=\(latitude)",
            "longitude=\(longitude)",
            "radius=\(radiusInMeters)",
            "open_now=\(openNow)"
        ]
        
        let parametersJoined = parameterStrings.joined(separator: "&")
        
        let categories = foodTypes.reduce("") { (result, foodType) -> String in
            let separator = result == "" ? "" : ","
            return result + separator + foodType.rawValue
        }
        let categoriesString = categories == "" ? "" : "&categories=\(categories)"
        
        let urlString = "https://api.yelp.com/v3/businesses/search?\(parametersJoined)\(categoriesString)"
        
        print("===== URL\n\(urlString)")
        
        return URL(string: urlString)
    }
    
    public func getNearbyRestaurants(location: Coordinate, radiusInMeters: Int, foodTypes: [FoodType], priceRange: PriceRange, openNow: Bool, resultLimit: Int? = nil) async throws -> [Business] {

        guard let url = createYelpURL(location: location,
                                      radiusInMeters: radiusInMeters,
                                      foodTypes: foodTypes,
                                      priceRange: priceRange,
                                      openNow: openNow,
                                      resultLimit: resultLimit ?? yelpAPIDefaultResultLimit)
            else
        {
            print("error, invalid url for yelp api")
            throw NSError.with(description: "Could not create URL for Yelp API")
        }
        
        let data = try await NetworkRequestService.makeRequestWith(url: url, headers: [yelpAPIAuthHeader])
        
        return try createRestaurantsFrom(data: data)
    }
    
    public func searchForRestaurantsWith(term: String, near location: Coordinate, resultLimit: Int? = nil) async throws -> [Business] {
        let urlString = yelpAPIBaseURL + yelpAPISearchPath
        let parameters = [
            URLQueryItem(name: Keys.latitude, value: location.latitude.description),
            URLQueryItem(name: Keys.longitude, value: location.longitude.description),
            URLQueryItem(name: Keys.limit, value: resultLimit?.description ?? yelpAPIDefaultResultLimit.description),
            URLQueryItem(name: Keys.categories, value: yelpAPIRestaurantCategories),
            URLQueryItem(name: Keys.term, value: term),
        ]
        
        let data = try await NetworkRequestService.makeRequestWith(baseURLString: urlString, headers: [yelpAPIAuthHeader], parameters: parameters)
        
        return try createRestaurantsFrom(data: data)
    }
}
