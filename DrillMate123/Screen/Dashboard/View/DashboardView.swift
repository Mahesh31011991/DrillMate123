//
//  DashboardView.swift
//  DrillMate
//
//  Created by Mahesh Behere on 22/07/25.
//

import SwiftUI

struct DashboardView: View {
    @State private var isDrawerOpen = false
    //    @State private var navigateTo: SideMenuAction?
    @ObservedObject var viewModel = DashboardViewModel()
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    //    @State private var selectedFile: LocalFile?
    
    @State private var selectedModule: DashboardModule? = nil
    
    let columns = [GridItem(.adaptive(minimum: 110), spacing: 16)]
    
    var body: some View {
        ZStack{
            NavigationView {
                
                VStack(spacing: 16) {
                    
                    // HamburgerMenu
//                    hamburgerMenu()
                    ScrollView {
                        Text("DrillMate")
                            .font(.largeTitle.bold())
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal)
                        
                        if viewModel.isLoading {
                            ProgressView("Loading...")
                                .padding()
                        } else {
                            LazyVGrid(columns: columns, spacing: 12) {
                                ForEach(DashboardModule.allCases) { module in
                                    Button {
                                        selectedModule = module
                                    } label: {
                                        DashboardCard(item: module.summary)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                        
                        Button("Logout") {
                            authViewModel.logout()
                        }
                        .foregroundColor(.red)
                        .padding(.top, 20)
                    }
                    .padding(.top)
                }
                .background(
                    NavigationLink(
                        destination: selectedModule?.destinationView,
                        isActive: Binding<Bool>(
                            get: { selectedModule != nil },
                            set: { if !$0 { selectedModule = nil } }
                        ),
                        label: { EmptyView() }
                    )
                    .hidden()
                )
                //            .navigationTitle("Dashboard").padding()
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}
            
////            if isDrawerOpen {
//                Color.black.opacity(0.4)
//                    .ignoresSafeArea()
//                    .onTapGesture {
//                        withAnimation {
//                            isDrawerOpen = false
//                        }
//                    }
                
//                HStack(spacing: 0) {
////                    SideMenuView { action in
//                        withAnimation {
//                            isDrawerOpen = false
//                        }
//                        
//                        // Delay to allow drawer to close
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
////                            navigateTo = action
//                        }
//                    }
                    
//                    Spacer()
//                }
////                .transition(.move(edge: .leading))
//            }
//        }
//        .fullScreenCover(item: $navigateTo) { action in
//            switch action {
//            case .settings:
//                SettingsView()
//            case .appInfo:
//                AppInfoView()
//            case .logout:
////                AuthManager.shared.signOut()
//                LoginView()
//            }
//        }
//    }

    
    
    
    
//    func hamburgerMenu() -> some View{
//        HStack {
//            Button(action: {
//                withAnimation {
//                    isDrawerOpen.toggle()
//                }
//            }) {
//                Image(systemName: "line.3.horizontal")
//                    .font(.title)
//                    .padding()
//            }
//            Spacer()
//        }
//    }
    




//struct DashboardView: View {
//    @ObservedObject var viewModel: DashboardViewModel = DashboardViewModel()
//    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
//    
//    let columns = [GridItem(.adaptive(minimum: 160), spacing: 20)]
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(spacing: 16) {
//                    Text("FieldOps360")
//                        .font(.largeTitle.bold())
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.horizontal)
//                    
//                    if viewModel.isLoading {
//                        ProgressView("Loading...")
//                            .padding()
//                    } else {
//                        LazyVGrid(columns: columns, spacing: 16) {
//                            ForEach(viewModel.summaries) { item in
//                                DashboardCard(item: item)
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                    
//                    Spacer()
//                    
//                    Button("Logout") {
//                        authViewModel.logout()
//                    }
//                    .foregroundColor(.red)
//                    .padding(.top, 20)
//                }
//                .padding(.top)
//            }
//            .navigationTitle("Dashboard")
//        }
//    }
//}



// Conform enum to Identifiable for fullScreenCover
//extension SideMenuAction: Identifiable {
//    var id: String {
//        switch self {
//        case .settings: return "settings"
//        case .appInfo: return "appInfo"
//        case .logout: return "logout"
//        }
//    }
//}

#Preview {
    DashboardView()
}



struct DashboardCard: View {
    let item: DashboardSummary
    
    @State private var showMap = false
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: item.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundColor(Color.orange)
                .padding()
            
            Text(item.title)
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
        .frame(maxWidth: .infinity, minHeight: 150)
//        .background(Color(item.color))
        .cornerRadius(20)
        .shadow(radius: 2)
    }
}

