//
//  LoginView.swift
//  DrillMate
//
//  Created by Mahesh Behere on 22/07/25.
//

import SwiftUI
import AuthenticationServices


class CounterViewModel: ObservableObject {
    @Published var count = 0
   var initFrom:String
    init(initViewFrom:String) {
        self.initFrom = initViewFrom
        print("✅ CounterViewModel - init From \(initViewFrom)")
    }
    
    deinit {
       
        print("❌ CounterViewModel - deinit from \(self.initFrom)")
    }
    
    func increment() {
        count += 1
    }
}



struct ParentView1: View {
    @ObservedObject private var viewModel = CounterViewModel(initViewFrom: "ParentView1")
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Parent Count: \(viewModel.count)")
                .font(.title)
            
            Button("Increment") {
                viewModel.increment()
            }
            
            ChildView(viewModel: viewModel)
        }
        .padding()
    }
}

struct ChildView: View {
    @ObservedObject var viewModel :  CounterViewModel
    
    var body: some View {
        VStack {
            Text("Child Count: \(viewModel.count)")
            Button("Child Increment") {
                viewModel.increment()
            }
        }
    }
}


struct LoginView: View {
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject var viewModel = AuthViewModel()
    
    var body: some View {
        
        VStack(spacing: 20) {
            Text("Welcome to DrillMate")
                .font(.largeTitle)
            
            Button("Login with Microsoft") {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = scene.windows.first,let vc = window.rootViewController {
                   // UserActivityLogger.log(action: "Login", details: "User successfully signed in with MSAL")
                    viewModel.login(presentationAnchor: vc)
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .onChange(of: scenePhase) { _ in
            viewModel.checkAuthenticationStatus()
        }
        .fullScreenCover(isPresented: $viewModel.isAuthenticated) {
            
            DashboardView(authViewModel: viewModel)
        }
    }
    
    
    
}


#Preview {
    ParentView1()
}
