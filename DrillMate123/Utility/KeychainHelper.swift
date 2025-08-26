//
//  KeychainHelper.swift
//  DrillMate
//
//  Created by Mahesh Behere on 22/07/25.
//

import Foundation
import Security


class KeychainHelper{
    
    static let tokenKey = "msalToken"
    
    static func saveToken(_ token:String){
        guard let data = token.data(using: .utf8) else { return }
        
        let query : [String:Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : tokenKey,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    
    static func getToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : tokenKey,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess, let data = item as? Data, let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        return token
    }
    
    static func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : tokenKey
        ]
        SecItemDelete(query as CFDictionary)
    }
}
