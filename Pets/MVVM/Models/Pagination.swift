//
//  Pagination.swift
//  Pets
//
//  Created by Cristian Serea on 20.02.2024.
//

import Foundation

struct Pagination: Decodable {
    let current_page: Int
    let total_pages: Int
    let links: Links
    
    enum CodingKeys: String, CodingKey {
        case current_page
        case total_pages
        case links = "_links"
    }
}

struct Links: Decodable {
    let next: Link?
}

struct Link: Decodable {
    let href: String
}
