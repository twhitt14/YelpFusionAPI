//
//  FoodType.swift
//
//
//  Created by Trevor Whittingham on 9/13/21.
//  Copyright © 2021 Retro LLC. All rights reserved.
//

import Foundation

public enum FoodType: String, CaseIterable {
    case asian = "asianfusion,panasian"
    case barbeque = "bbq"
    case burgers = "burgers"
    case cajun = "cajun"
    case chinese = "chinese"
    case crepes = "creperies"
    case dessert = "desserts"
    case hawaiian = "hawaiian"
    case indian = "indpak"
    case italian = "italian"
    case japanese = "japanese"
    case korean = "korean"
    case kosher = "kosher"
    case mexican = "mexican"
    case pizza = "pizza"
    case sushi = "sushi"
    case thai = "thai"
    case vegan = "vegan"
    case vegetarian = "vegetarian"
    case waffles = "waffles"
    
    public func titleCapitalized() -> String {
        var title = "no title"
        switch self {
        case .asian:
            title = "asian"
        case .barbeque:
            title = "barbeque"
        case .burgers:
            title = "burgers"
        case .cajun:
            title = "cajun"
        case .chinese:
            title = "chinese"
        case .crepes:
            title = "crepes"
        case .dessert:
            title = "dessert"
        case .hawaiian:
            title = "hawaiian"
        case .indian:
            title = "indian"
        case .italian:
            title = "italian"
        case .japanese:
            title = "japanese"
        case .korean:
            title = "korean"
        case .kosher:
            title = "kosher"
        case .mexican:
            title = "mexican"
        case .pizza:
            title = "pizza"
        case .sushi:
            title = "sushi"
        case .thai:
            title = "thai"
        case .vegan:
            title = "vegan"
        case .vegetarian:
            title = "vegetarian"
        case .waffles:
            title = "waffles"
        }
#if os(iOS)
        return title.localizedCapitalized
#elseif os(macOS)
        if #available(macOS 10.11, *) {
            return title.localizedCapitalized
        } else {
            return title.capitalized
        }
#endif
    }
}
