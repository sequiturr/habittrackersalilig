//
//  HabitTracker_SaliligApp.swift
//  HabitTracker-Salilig
//
//  Created by Charle Salilig on 5/22/26.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct HabitTracker_SaliligApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authService = AuthService.shared
    
    var body: some Scene {
        WindowGroup {
            if authService.isAuthenticated {
                NavigationView {
                    HabitListView()
                        .navigationBarBackButtonHidden(true)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Sign Out") {
                                    AuthService.shared.signOut()
                                }
                                .foregroundStyle(.red)
                            }
                        }
                }
            } else {
                FrontPage()
            }
        }
    }
}
