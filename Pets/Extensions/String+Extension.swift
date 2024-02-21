//
//  String+Extension.swift
//  Pets
//
//  Created by Cristian Serea on 20.02.2024.
//

import Foundation

extension String {
    var localizable: String {
        guard let bundle = getBundle() else {
            return self
        }

        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }

    func getBundle() -> Bundle? {
        guard let path = Bundle.main.path(forResource: "en", ofType: "lproj") else {
            return nil
        }

        return Bundle(path: path)
    }
}

extension String {
    var ensurePeriod: String {
        guard hasSuffix(".") else {
            return self + "."
        }
        
        return self
    }
}

extension Optional where Wrapped == String {
    mutating func appendQuery(string: String) {
        switch self {
        case var .some(value):
            if !value.isEmpty {
                value.append("&")
            }            
            value.append(string)
            self = value
        case .none:
            self = string
        }
    }
}
