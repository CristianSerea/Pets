//
//  Enumerations.swift
//  Pets
//
//  Created by Cristian Serea on 20.02.2024.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
}

enum SectionType: String {
    case Sort
    case Filter
}

enum SortType: String, CaseIterable {
    case DateShuffled
    case DateAscending = "recent"
    case DateDescending = "-recent"
    case DistanceAscending = "distance"
    case DistanceDescending = "-distance"
    
    var localizable: String {
        switch self {
        case .DateShuffled:
            return LocalizableConstants.sortTypeDateShuffledTitle
        case .DateAscending:
            return LocalizableConstants.sortTypeDateAscendingTitle
        case .DateDescending:
            return LocalizableConstants.sortTypeDateDescendingTitle
        case .DistanceAscending:
            return LocalizableConstants.sortTypeDistanceAscendingTitle
        case .DistanceDescending:
            return LocalizableConstants.sortTypeDistanceDescendingTitle
        }
    }
    
    var isEnabled: Bool {
        switch self {
        case .DateShuffled, .DateAscending, .DateDescending:
            return true
        default:
            return false
        }
    }
    
    var canBeDisabled: Bool {
        switch self {
        case .DistanceAscending, .DistanceDescending:
            return true
        default:
            return false
        }
    }
}

enum FilterType: String, CaseIterable {
    case PetType
    case Gender
    case Location
    case Distance
    
    var localizable: String {
        switch self {
        case .PetType:
            return LocalizableConstants.typeLabelTitle
        default:
            return rawValue
        }
    }
    
    var canBeDisabled: Bool {
        switch self {
        case .Distance:
            return true
        default:
            return false
        }
    }
}

enum PetType: String, CaseIterable {
    case AnySpecies
    case Cat
    case Dog
    
    var localizable: String {
        switch self {
        case .AnySpecies:
            return LocalizableConstants.anyLabelTitle
        default:
            return rawValue
        }
    }
}

enum Gender: String, CaseIterable {
    case AnyGender
    case Male
    case Female
    
    var localizable: String {
        switch self {
        case .AnyGender:
            return LocalizableConstants.anyLabelTitle
        default:
            return rawValue
        }
    }
}

enum Location: String, CaseIterable {
    case AnyLocation
    case Louisiana = "LA"
    case NewYork = "NY"
    case NorthCarolina = "NC"
    case Pennsylvania = "PA"
    case Ohio = "OH"
    
    var localizable: String {
        switch self {
        case .AnyLocation:
            return "Any"
        case .Louisiana:
            return "Louisiana"
        case .NewYork:
            return "New York"
        case .NorthCarolina:
            return "North Carolina"
        case .Pennsylvania:
            return "Pennsylvania"
        case .Ohio:
            return "Ohio"
        }
    }
}

enum Distance: String, CaseIterable {
    case Miles10 = "10"
    case Miles50 = "50"
    case Miles100 = "100"
    case Miles250 = "250"
    case Miles500 = "500"
    
    var localizable: String {
        return rawValue + " " + LocalizableConstants.milesLabelTitle.lowercased()
    }
}
