//
//  TokenStorge.swift
//  DrillMate
//
//  Created by Mahesh Behere on 25/07/25.
//

import Foundation
import KeychainAccess

class TokenStorage {
    static let shared = TokenStorage()
    
    private let keychain = Keychain(service: "com.Mahesh.DrillMate")
    
    private let accessTokenKey = "accessToken"
    
    func save(accessToken: String) {
        keychain[accessTokenKey] = accessToken
    }
    
    func getAccessToken() -> String? {
        return keychain[accessTokenKey]
    }
    
    func clear() {
        try? keychain.remove(accessTokenKey)
    }
}
