//
//  YelpFusionAPI.swift
//
//
//  Created by Trevor Whittingham on 9/13/21.
//  Copyright © 2021 Retro LLC. All rights reserved.
//

import Foundation
import RetroNetworking

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
    private let yelpAPIResultLimit: Int // 50
    private let yelpAPIRestaurantCategories = "restaurants,food"
    
    // MARK: -
    // MARK: Init
    
    public init(yelpAPIKey: String, yelpAPIResultLimit: Int = 50) {
        self.yelpAPIKey = yelpAPIKey
        self.yelpAPIResultLimit = min(max(yelpAPIResultLimit, 0), 50)
    }
    
    // MARK: -
    // MARK: Private methods
    
    private func createYelpURL(location: Coordinate, radiusInMeters: Int, foodTypes: [FoodType], priceRange: PriceRange, openNow: Bool, resultLimit: Int) -> URL? {
        
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
    
    private func createRestaurantsFrom(data: Data) throws -> [Business] {
        let response = try JSONDecoder().decode(BusinessSearchResponse.self, from: data)

        return response.businesses
        
//        restaurantsData.compactMap({ restaurantObject in
//            return Restaurant_Roulette.Restaurant.create(withYelpObject: restaurantObject, shouldSave: false)
//        })
    }
    
    // MARK: -
    // MARK: Public methods
    
    public func getNearbyRestaurants(location: Coordinate, radiusInMeters: Int, foodTypes: [FoodType], priceRange: PriceRange, openNow: Bool, resultLimit: Int = 50, callback: @escaping ([Business]) -> Void) throws {

        guard let url = createYelpURL(location: location,
                                      radiusInMeters: radiusInMeters,
                                      foodTypes: foodTypes,
                                      priceRange: priceRange,
                                      openNow: openNow,
                                      resultLimit: resultLimit)
            else
        {
            print("error, invalid url for yelp api")
            throw NSError.with(description: "Could not create URL for Yelp API")
        }
        
        NetworkRequestService.makeRequestWith(url: url, headers: [yelpAPIAuthHeader]) { [self] result in
            switch result {
            case .success(let data):
                do {
                    let businesses: [Business] = try createRestaurantsFrom(data: data)
                    callback(businesses)
                } catch {
                    let error = error // for debug purposes
                    print(error)
                }
            case .failure(let error):
                print("error getting restaurants: \(error.localizedDescription)")
                callback([])
            }
        }
    }
    
    public func searchForRestaurantsWith(term: String, near location: Coordinate, completion: @escaping ([Business]) -> Void) {
        let urlString = yelpAPIBaseURL + yelpAPISearchPath
        let parameters = [
            NetworkParameter(key: Keys.latitude, value: location.latitude.description),
            NetworkParameter(key: Keys.longitude, value: location.longitude.description),
            NetworkParameter(key: Keys.limit, value: yelpAPIResultLimit.description),
            NetworkParameter(key: Keys.categories, value: yelpAPIRestaurantCategories),
            NetworkParameter(key: Keys.term, value: term.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""),
        ]
        NetworkRequestService.makeRequestWith(baseURLString: urlString, headers: [yelpAPIAuthHeader], parameters: parameters) { [self] result in
            switch result {
            case .success(let data):
                do {
                    let businesses = try createRestaurantsFrom(data: data)
                    completion(businesses)
                } catch {
                    let error = error
                    print(error)
                    completion([])
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
}
