//
//  GlobalConstants.swift
//  Pets
//
//  Created by Cristian Serea on 20.02.2024.
//

import Foundation

struct GlobalConstants {
    struct Server {
        static let domain = "https://api.petfinder.com"
        static let oauth = "/v2/oauth2/token"
        static let pets = "/v2/animals"
    }
    
    struct Credentials {
        static let clientId = "8FvB92COL3loJkRHBozGPLOVKZTG4CgXal6Dou6EjsH5lj2SXB"
        static let clientSecret = "zcYSA3CrhG6yW1dc539o8rAVgj7ecwLUaYHTSe3s"
    }
    
    struct Layout {
        static let marginOffset: CGFloat = 16
        static let cornerRadius: CGFloat = 12
        static let defaultHeight: CGFloat = 44
    }
    
    struct Identifier {
        static let tableViewCell = "TableViewCell"
        static let petTableViewCell = "PetTableViewCell"
    }
    
    struct DateFormat {
        static let server = "yyyy-MM-dd'T'HH:mm:ssZ"
        static let mobile = "HH:mm • dd MMM, yyyy"
    }
    
    struct Regex {
        static let src = #"src=\"(.*?)\""#
    }
}
