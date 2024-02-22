//
//  ImageConstants.swift
//  Pets
//
//  Created by Cristian Serea on 21.02.2024.
//

import UIKit

struct ImageConstants {
    struct SystemName {
        static let pawprint = "pawprint.circle.fill"
        static let slider = "slider.vertical.3"
        static let email = "envelope.fill"
        static let phone = "phone.fill"
    }
    
    struct Image {
        static let pawprint = UIImage(systemName: SystemName.pawprint)
        static let slider = UIImage(systemName: SystemName.slider)
    }
    
}
