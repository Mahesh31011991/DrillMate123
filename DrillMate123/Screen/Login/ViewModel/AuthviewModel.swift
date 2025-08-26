//
//  AuthviewModel.swift
//  DrillMate
//
//  Created by Mahesh Behere on 22/07/25.
//

import Foundation
import SwiftUI
import MSAL
import AuthenticationServices
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    
    init() {
        checkAuthenticationStatus()
        let didSignOutNotification = Notification.Name("DidSignOut")
        NotificationCenter.default.addObserver(forName: didSignOutNotification, object: nil, queue: .main) { _ in
            self.isAuthenticated = false
        }
    }
    
    func login(presentationAnchor: UIViewController) {
        //AuthManager.shared.acquireTokenInteractively { result in
            DispatchQueue.main.async {
//                switch result {
//                case .success:
                    self.isAuthenticated = true
//                case .failure(let error):
//                    self.errorMessage = error.localizedDescription
                }
           // }
//        }
    }
    
    func checkAuthenticationStatus() {
        self.isAuthenticated = true //TokenStorage.shared.getAccessToken() != nil
    }
    
    func logout() {
//        AuthManager.shared.signOut()
        self.isAuthenticated = false
    }
}


//class AuthViewModel: ObservableObject {
//    @Published var isAuthenticated = false
//    
//    func login(presentationAnchor: UIViewController) {
//        
//        MSALManager.shared.signIn(presentationAnchor: presentationAnchor) { result in
//           
//                switch result {
//                case .success:
//                    DispatchQueue.main.async {
//                        self.isAuthenticated = true
//                    }
//                case .failure(let error):
//                    DispatchQueue.main.async {
//                        print("Login failed: \(error)")
//                    }
//                }
//        }
//    
//    
//    
//    
//    func logout() {
//        MSALManager.shared.signOut()
//        isAuthenticated = false
//    }
//    
//    func checkSession() {
//        if KeychainHelper.getToken() != nil {
//            isAuthenticated = true
//        }
//    }
//}
