//
//  Failure.swift
//  Pets
//
//  Created by Cristian Serea on 20.02.2024.
//

import Foundation

struct Failure: Error, Decodable, LocalizedError {
    let type: String
    let status: Int
    let title: String
    let detail: String
    
    var errorDescription: String? {
        return String(status) + " " + title + "\n" + detail.ensurePeriod
    }
    
    var isUnauthorized: Bool {
        return status == 401
    }
}
