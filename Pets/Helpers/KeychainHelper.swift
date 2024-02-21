//
//  KeychainHelper.swift
//  Pets
//
//  Created by Cristian Serea on 20.02.2024.
//

import Foundation

class KeychainHelper {
    static func saveItem(withKey key: String, withData data: Data) -> Error? {
        let query = [kSecClass as String: kSecClassGenericPassword as String,
                     kSecAttrAccount as String: key,
                     kSecValueData as String: data] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            return nil
        } else {
            return NSError(domain: LocalizableConstants.errorKeychainSaveTitle, code: Int(status))
        }
    }
    
    static func retrieveItem(withKey key: String) -> Result<Data?, Error> {
        let query = [kSecClass as String: kSecClassGenericPassword,
                     kSecAttrAccount as String: key,
                     kSecReturnData as String: true,
                     kSecMatchLimit as String: kSecMatchLimitOne] as [String : Any]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess, let data = item as? Data {
            return .success(data)
        } else if status == errSecItemNotFound {
            return .success(nil)
        } else {
            let error = NSError(domain: LocalizableConstants.errorKeychainRetrieveTitle, code: Int(status))
            return .failure(error)
        }
    }
}
