//
//  Sort.swift
//  Pets
//
//  Created by Cristian Serea on 21.02.2024.
//

import Foundation

struct Sort {
    let sortType: SortType
    var isSelected: Bool = false
    var isEnabled: Bool = true
    
    var canBeDisabled: Bool {
        return sortType.canBeDisabled
    }
    
    var hint: String {
        return isEnabled ? LocalizableConstants.selectLabelTitle : LocalizableConstants.disabledLabelTitle
    }
}
