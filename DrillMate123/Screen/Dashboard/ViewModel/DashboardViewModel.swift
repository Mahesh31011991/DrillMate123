//
//  DashboardViewModel.swift
//  DrillMate
//
//  Created by Mahesh Behere on 22/07/25.
//

import Foundation
import Combine
import SwiftUI

enum DashboardModule: String, CaseIterable, Identifiable {
    case siteMap = "Site Map"
    case inspections = "Inspections"
    case reports = "Reports"
    case openWorkOrder = "open Work Order"
    case pendingTransactions = "Pending Transactions"
    case incidentToday = "Incident Today"
    case documentStorgaeView = "Document Storgae View"
    case settingsView = "Settings View"
    case userActivityView = "User Activity View"
    case equipmentChecklist = "Equipment Checklist"
    
    
    var id: String { self.rawValue }
    
    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .siteMap:
            EmptyView()
        default:
            EmptyView()
            //MapScreen()
//        case .inspections:
//            InspectionScreen() // Replace with InspectionScreen()
//        case .reports:
//           // ReportsView() // Replace with ReportsScreen()
//        case .openWorkOrder:
//            //WorkOrdersView()
//        case .pendingTransactions:
//            // For test
//           // PendingTransactionsView()
//        case .incidentToday:
//            //IncidentTodayView()
//        case .documentStorgaeView:
//            //DocumentStorageView()
//        case .settingsView:
//            //SettingsView()
//        case .userActivityView:
//           // UserActivityView()
//        case .equipmentChecklist:
//         //   SiteChecklistView()
        }
    }
    
    var summary: DashboardSummary {
        switch self {
        case .siteMap:
            return DashboardSummary(title: rawValue, value: "", icon: "map.fill", color: "green")
        case .inspections:
            return DashboardSummary(title: rawValue, value: "", icon: "checkmark.seal.fill", color: "blue")
        default:
            return DashboardSummary(title: "", value: "", icon: "", color: "")
//        case .reports:
//            return DashboardSummary(title: rawValue, value: "", icon: "doc.plaintext", color: "orange")
//        case .openWorkOrder:
//            return DashboardSummary(title: rawValue, value: "", icon: "wrench.fill", color: "pink")
//        case .incidentToday:
//            return DashboardSummary(title: rawValue, value: "", icon: "exclamationmark.triangle.fill", color: "red")
//        case .documentStorgaeView:
//            return DashboardSummary(title: rawValue, value: "", icon: "doc.text.magnifyingglass", color: "blue")
//        case .pendingTransactions:
//         //   let testTx = PendingTransaction(
//                type: .siteCheckIn,
//                payloadDescription: "Checked into Site A - offline",
//                timestamp: Date(),
//                syncStatus: .pending
//            )
//            PendingTransactionManager.shared.save(transaction: testTx)
//            return DashboardSummary(title:rawValue, value: "", icon: "shippingbox.fill", color: "purple")
//        case .settingsView:
//            return DashboardSummary(title: rawValue, value: "", icon: "gearshape", color: "gray")
//        case .userActivityView:
//            return DashboardSummary(title: rawValue, value: "", icon: "clock", color: "gray")
//        case .equipmentChecklist:
//            return DashboardSummary(title: rawValue, value: "", icon: "wrench.and.screwdriver", color: "gray")
        }
    }
}




class DashboardViewModel:ObservableObject{
    @Published var summaries: [DashboardSummary] = []
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
//        fetchDashBoardSummary()
        loadSummary()
    }
    
    func loadSummary() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.summaries = DashboardModule.allCases.map { $0.summary }
            self.isLoading = false
        }
    }
    
    func fetchDashBoardSummary(){
        isLoading = true
        
        Just([
            DashboardSummary(title: "Open Work Orders", value: "12", icon: "wrench.fill", color: "orange"),
            DashboardSummary(title: "Pending Inspections", value: "5", icon: "doc.text.magnifyingglass", color: "blue"),
            DashboardSummary(title: "Incidents Today", value: "1", icon: "exclamationmark.triangle.fill", color: "red"),
            DashboardSummary(title: "Low Inventory Alerts", value: "3", icon: "shippingbox.fill", color: "purple"),
            DashboardSummary(title: "Site Map", value: "", icon: "map.fill", color: "green")

        ])
        .delay(for: 1.2, scheduler: DispatchQueue.main)
        .sink { [weak self] data in
            self?.summaries = data
            self?.isLoading = false
        }
        .store(in: &cancellables)
    
        
    }
}
