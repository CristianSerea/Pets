//
//  Pet.swift
//  Pets
//
//  Created by Cristian Serea on 20.02.2024.
//

import UIKit

struct Pet: Decodable {
    let id: Int
    let name: String
    let description: String?
    let status: String
    let type: String
    let species: String
    let gender: String
    let age: String
    let size: String
    let coat: String?
    let distance: Double?
    let breeds: Breeds
    let colors: Colors
    let contact: Contact
    let photos: [Photo]
    let tags: [String]
    let published_at: String
    
    var placeholderImage: UIImage? {
        return photos.isEmpty ? ImageConstants.pawprint : nil
    }
    
    var speciesGender: String {
        return species + " • " + gender + " • " + age
    }
    
    var published: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard let date = dateFormatter.date(from: published_at) else {
            return nil
        }
        
        dateFormatter.dateFormat = "HH:mm • dd MMM, yyyy"
        let string = dateFormatter.string(from: date)
            
        return string
    }
    
    var formattedDistance: String? {
        guard let distance = distance else {
            return nil
        }
        
        return String(format: "%.1f %@", distance, LocalizableConstants.milesLabelTitle.lowercased())
    }
}

struct Breeds: Decodable {
    let primary: String?
}

struct Colors: Decodable {
    let primary: String?
}

struct Contact: Decodable {
    let email: String?
    let phone: String?
}

struct Address: Decodable {
    let address1: String
    let address2: String
    let city: String
    let state: String
    let postcode: String
    let country: String
}

struct Photo: Decodable {
    let small: String
    let full: String
    
    var smallURL: URL? {
        return URL(string: small)
    }
    
    var fullURL: URL? {
        return URL(string: full)
    }
}

struct PetsWrapper: Decodable {
    let animals: [Pet]
    let pagination: Pagination
}
