//
//  Filter.swift
//  Pets
//
//  Created by Cristian Serea on 21.02.2024.
//

import Foundation

struct Filter {
    let filterType: FilterType
    var placeholder: String?
    var value: String?
    var isEnabled: Bool = true
    
    var canBeDisabled: Bool {
        return filterType.canBeDisabled
    }
    
    var hint: String {
        return isEnabled ? LocalizableConstants.changeLabelTitle : LocalizableConstants.disabledLabelTitle
    }
}
