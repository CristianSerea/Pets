//
//  String+Extension.swift
//  Pets
//
//  Created by Cristian Serea on 20.02.2024.
//

import UIKit
import MessageUI

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

extension String {
    var src: String? {
        guard let regex = try? NSRegularExpression(pattern: GlobalConstants.Regex.src) else {
            return nil
        }

        guard let match = regex.firstMatch(in: self, range: NSRange(startIndex..., in: self)) else {
            return nil
        }
            
        guard let srcRange = Range(match.range(at: 1), in: self) else {
            return nil
        }
        
        let src = String(self[srcRange])
        
        return src
    }
}

extension String {
    func makeCall() -> Error? {
        guard let phoneURL = URL(string: "tel://" + self) else {
            return nil
        }
        
        if UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL)
            
            return nil
        } else {
            return NSError(domain: "Invalid phone number", code: 7001)
        }
    }
    
    func sendEmail() -> Error? {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.setToRecipients([self])
            mailComposeViewController.setSubject("Pets")
            UIApplication.shared.topViewController?.present(mailComposeViewController, animated: true, completion: nil)
            
            return nil
        } else {
            return NSError(domain: "Email is not set up on this device", code: 7002)
        }
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
