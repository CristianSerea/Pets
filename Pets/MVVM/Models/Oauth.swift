//
//  Oauth.swift
//  Pets
//
//  Created by Cristian Serea on 20.02.2024.
//

import Foundation

struct Oauth: Codable {
    let token_type: String
    let expires_in: Int
    let access_token: String
}

struct OauthWrapper: Codable {
    var oauth: Oauth
    var date: Date
}
