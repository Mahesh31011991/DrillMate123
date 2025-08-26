//
//  File.swift
//  DrillMate
//
//  Created by Mahesh Behere on 22/07/25.
//

import Foundation
import MSAL
import AuthenticationServices

final class MSALManager {
    static let shared = MSALManager()
    
    private var applicationContext: MSALPublicClientApplication?
    private var account: MSALAccount?
    
    private let clientId = "<YOUR_CLIENT_ID>"
    private let tenantId = "<YOUR_TENANT_ID>"
    private let redirectUri = "msauth.<your.bundle.id>://auth" // must match in Azure Portal
    private let scopes = ["User.Read"]
    
    private init() {
        do {
            let authority = try MSALAADAuthority(url: URL(string: "https://login.microsoftonline.com/\(tenantId)")!)
            let config = MSALPublicClientApplicationConfig(clientId: clientId, redirectUri: redirectUri, authority: authority)
            self.applicationContext = try MSALPublicClientApplication(configuration: config)
        } catch {
            print("MSAL Initialization error: \(error)")
        }
    }
    
    // MARK: - Interactive Login
    func signIn(presentationAnchor: UIViewController, completion: @escaping (Result<String, Error>) -> Void) {
        let parameters = MSALInteractiveTokenParameters(scopes: scopes, webviewParameters: MSALWebviewParameters(authPresentationViewController: presentationAnchor))
        
        
        applicationContext?.acquireToken(with: parameters) { (result, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let result = result else {
                completion(.failure(NSError(domain: "MSAL", code: 0, userInfo: nil)))
                return
            }
            self.account = result.account
            KeychainHelper.saveToken(result.accessToken)
            completion(.success(result.accessToken))
        }
    }
    
    // MARK: - Silent Token
    func acquireTokenSilently(completion: @escaping (Result<String, Error>) -> Void) {
        guard let account = self.account else {
            completion(.failure(NSError(domain: "MSAL", code: 1, userInfo: [NSLocalizedDescriptionKey: "No account available"])))
            return
        }
        
        let parameters = MSALSilentTokenParameters(scopes: scopes, account: account)
        
        applicationContext?.acquireTokenSilent(with: parameters) { (result, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let result = result else {
                completion(.failure(NSError(domain: "MSAL", code: 2, userInfo: nil)))
                return
            }
            KeychainHelper.saveToken(result.accessToken)
            completion(.success(result.accessToken))
        }
    }
    
    func signOut() {
        guard let account = self.account else { return }
        do {
            try applicationContext?.remove(account)
            KeychainHelper.deleteToken()
        } catch {
            print("Logout failed: \(error)")
        }
    }
}
