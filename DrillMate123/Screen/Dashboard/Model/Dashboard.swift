//
//  Dashboard.swift
//  DrillMate
//
//  Created by Mahesh Behere on 22/07/25.
//

import Foundation

struct DashboardSummary:Decodable,Identifiable{
    
    let id = UUID()
    let title: String
    let value :String
    let icon:String
    let color : String
}
