//
//  DrillMate123App.swift
//  DrillMate123
//
//  Created by Mahesh Behere on 26/08/25.
//

import SwiftUI

@main
struct DrillMate123App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup{
                LoginView()
                    .onAppear{
                        NotificationManager.shared.requestAuthorization()
                    }
            
        }
    }
}
