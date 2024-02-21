//
//  Option.swift
//  Pets
//
//  Created by Cristian Serea on 21.02.2024.
//

import Foundation

struct Option {
    var sort: Sort?
    var filter: Filter?
    
    var title: String? {
        return sort?.sortType.localizable ?? filter?.filterType.localizable
    }
    
    var hint: String? {
        return sort?.hint ?? filter?.hint
    }
    
    var isEnabled: Bool {
        return sort?.isEnabled ?? filter?.isEnabled ?? true
    }
    
    var canBeDisabled: Bool {
        return sort?.canBeDisabled ?? filter?.canBeDisabled ?? false
    }
}
