//
//  NotificationView.swift
//  DrillMate
//
//  Created by Mahesh Behere on 24/07/25.
//

import Foundation

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Notifications")
                .font(.largeTitle)
                .padding(.top)
            
            Button("Schedule Test Notification (5s)") {
                NotificationManager.shared.scheduleLocalNotification(
                    title: "FieldOps360 Reminder",
                    body: "You have pending work orders!",
                    inSeconds: 5
                )
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
    }
}
