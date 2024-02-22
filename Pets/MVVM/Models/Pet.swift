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
    let videos: [Video]
    let tags: [String]
    let published_at: String
}

extension Pet {
    var formattedName: String {
        return name + " " + "#" + String(id)
    }
    
    var speciesGender: String {
        return species + " • " + gender + " • " + age
    }
    
    var published: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = GlobalConstants.DateFormat.server
        
        guard let date = dateFormatter.date(from: published_at) else {
            return nil
        }
        
        dateFormatter.dateFormat = GlobalConstants.DateFormat.mobile
        let string = dateFormatter.string(from: date)
            
        return string
    }
    
    var formattedPublished: String? {
        return published?.replacingOccurrences(of: " • ", with: "\n")
    }
    
    var formattedDistance: String? {
        guard let distance = distance else {
            return nil
        }
        
        return String(format: "%.1f %@", distance, LocalizableConstants.milesAwayLabelTitle.lowercased())
    }
    
    var placeholderImage: UIImage? {
        return photos.isEmpty ? ImageConstants.Image.pawprint : nil
    }
    
    var media: [Media] {
        return videos.compactMap { Media(photo: nil, video: $0) } + photos.compactMap { Media(photo: $0, video: nil) }
    }
}

extension Pet {
    var attributes: [Attribute] {
        return [Attribute(title: LocalizableConstants.statusLabelTitle, value: status),
                Attribute(title: LocalizableConstants.typeLabelTitle, value: type),
                Attribute(title: LocalizableConstants.speciesLabelTitle, value: species),
                Attribute(title: LocalizableConstants.breedLabelTitle, value: breeds.primary),
                Attribute(title: LocalizableConstants.colorLabelTitle, value: colors.primary),
                Attribute(title: LocalizableConstants.genderLabelTitle, value: gender),
                Attribute(title: LocalizableConstants.ageLabelTitle, value: age),
                Attribute(title: LocalizableConstants.sizeLabelTitle, value: size),
                Attribute(title: LocalizableConstants.coatLabelTitle, value: coat)]
            .filter { $0.value != nil }
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
    let address: Address?
}

struct Address: Decodable {
    let address1: String?
    let address2: String?
    let city: String
    let state: String
    let postcode: String
    let country: String
    
    var fullAddress: String {
        return [address1, address2, city, state, country, postcode]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}

struct Photo: Decodable, Hashable {
    let medium: String
    let full: String
    
    var mediumURL: URL? {
        return URL(string: medium)
    }
    
    var fullURL: URL? {
        return URL(string: full)
    }
}

struct Video: Decodable, Hashable {
    let embed: String
    
    var url: URL? {
        guard let src = embed.src else {
            return nil
        }
        
        return URL(string: src)
    }
}

struct PetsWrapper: Decodable {
    let animals: [Pet]
    let pagination: Pagination
}
