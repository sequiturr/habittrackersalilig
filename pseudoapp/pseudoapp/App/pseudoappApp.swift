//
//  HabitTracker_SaliligApp.swift
//  HabitTracker-Salilig
//
//  Created by Charle Salilig on 5/22/26.
//

import SwiftUI
import CoreData

@main
struct pseudoappApp: App {
    @StateObject private var authService = AuthService.shared
    
    var body: some Scene {
        WindowGroup {
            if authService.isAuthenticated {
                NavigationView {
                    HabitListView()
                        .environment(\.managedObjectContext, CoreDataManager.shared.context)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Sign Out") {
                                    authService.signOut()
                                }
                                .foregroundColor(.red)
                            }
                        }
                }
            } else {
                FrontPage()
            }
        }
    }
}
