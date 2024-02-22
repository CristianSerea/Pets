//
//  MockConstants.swift
//  Pets
//
//  Created by Cristian Serea on 22.02.2024.
//

import Foundation

struct MockConstants {
    struct SessionMock {
        static var oauthData: Data {
            let url = Bundle.main.url(forResource: "Session", withExtension: "json")
            let data = try! Data(contentsOf: url!)
            
            return data
        }
        
        static var oauth: Oauth {
            let pet = try! JSONDecoder().decode(Oauth.self, from: oauthData)
            
            return pet
        }
    }
    
    struct PetsMock {
        static var petsData: Data {
            let url = Bundle.main.url(forResource: "Pets", withExtension: "json")
            let data = try! Data(contentsOf: url!)
            
            return data
        }
        
        static var petsWrapper: PetsWrapper {
            let petsWrapper = try! JSONDecoder().decode(PetsWrapper.self, from: petsData)
            
            return petsWrapper
        }
    }
    
    struct PetMock {
        static var petData: Data {
            let url = Bundle.main.url(forResource: "Pet", withExtension: "json")
            let data = try! Data(contentsOf: url!)
            
            return data
        }
        
        static var pet: Pet {
            let pet = try! JSONDecoder().decode(Pet.self, from: petData)
            
            return pet
        }
    }
}
