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
        
        static let invalidAccessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI4RnZCOTJDT0wzbG9Ka1JIQm96R1BMT1ZLWlRHNENnWGFsNkRvdTZFanNINWxqMlNYQiIsImp0aSI6IjNiNDk3OGIwMGZkZGZjMTY2NmI3Nzg1N2Y3NGYxZDlkODYyZTdkZDZlYjNhMzA3NWY3NDhhZjVjZmQ0ZDRlYzdhOTMxNzY2MjI0ZmJlMzRkIiwiaWF0IjoxNzA4NTg0MzU3LCJuYmYiOjE3MDg1ODQzNTcsImV4cCI6MTcwODU4Nzk1Nywic3ViIjoiIiwic2NvcGVzIjpbXX0.RNT2rfCKHR6eyA1ywM7z70NVodDwAkxjmHdh6YJ9aLjgvmF-y7GhyTmb5In36euMIFZXJ8bS4YOhQaYDx4jTZsayZIm3CVxSpyW5nigegiwmZAEVfXoJq7e_IgJQHSng7OXjcMv9Q-77YRacjit1WtmwHmC-4rUer19p59fCU2u9hvGaBqwKXycrU0sJcO9LcW7pUGyqwfjiwOFe8IY1spdfRL-C1VuF7LNWn-TcHY9NCnUAGswpoyZjOWecr_xhNMLwco_Wod93ttlf4JpM4FD6gpr0HxXDDEMPhrIevirgvJM2rdEUKJ8LxhnypX3h8pW1nVM2lW_2QfdCDINFHQ"
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
