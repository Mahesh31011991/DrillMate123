//
//  AuthManager.swift
//  DrillMate
//
//  Created by Mahesh Behere on 25/07/25.
//



import Foundation
import MSAL

class AuthManager {
    static let shared = AuthManager()
    
    private let scopes = ["user.read"]
    private let clientId = "YOUR_CLIENT_ID"
    private let tenantId = "YOUR_TENANT_ID"
    
    private var applicationContext: MSALPublicClientApplication?
    
    private init() {
        do {
            let authorityURL = try MSALAuthority(url: URL(string: "https://login.microsoftonline.com/\(tenantId)")!)
            let config = MSALPublicClientApplicationConfig(clientId: clientId, redirectUri: nil, authority: authorityURL)
            applicationContext = try MSALPublicClientApplication(configuration: config)
        } catch {
            print("MSAL init error: \(error)")
        }
    }
    
    func acquireTokenInteractively(completion: @escaping (Result<String, Error>) -> Void) {
        guard let app = applicationContext else {
            completion(.failure(NSError(domain: "Auth", code: -1, userInfo: nil)))
            return
        }
        
        let params = MSALInteractiveTokenParameters(scopes: scopes)
//        let params =  MSALInteractiveTokenParameters(scopes: scopes, webviewParameters: nil)
        params.promptType = .selectAccount
        
        app.acquireToken(with: params) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let result = result else {
                completion(.failure(NSError(domain: "Auth", code: -1)))
                return
            }
            
            TokenStorage.shared.save(accessToken: result.accessToken)
            completion(.success(result.accessToken))
        }
    }
    
    func acquireTokenSilently(completion: @escaping (Result<String, Error>) -> Void) {
        guard let app = applicationContext else {
            completion(.failure(NSError(domain: "Auth", code: -1)))
            return
        }
        
        do {
            guard let account = try app.allAccounts().first else {
                completion(.failure(NSError(domain: "Auth", code: -2)))
                return
            }
            
            let params = MSALSilentTokenParameters(scopes: scopes, account: account)
            app.acquireTokenSilent(with: params) { result, error in
                if let result = result {
                    TokenStorage.shared.save(accessToken: result.accessToken)
                    completion(.success(result.accessToken))
                } else {
                    completion(.failure(error ?? NSError(domain: "Auth", code: -3)))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func signOut() {
        // ✅ This matches YOUR earlier code
        accessToken = nil
        TokenStorage.shared.clear()
        DispatchQueue.main.async {
            let didSignOutNotification = Notification.Name("DidSignOut")
            NotificationCenter.default.post(name:didSignOutNotification, object: nil)
        }
    }
    
    // Required for holding in-memory access token
    var accessToken: String? {
        get { TokenStorage.shared.getAccessToken() }
        set {
            if let token = newValue {
                TokenStorage.shared.save(accessToken: token)
            } else {
                TokenStorage.shared.clear()
            }
        }
    }
}

