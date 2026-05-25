//
//  AuthService.swift
//  HabitTracker-Salilig
//
//  Created by Charle Salilig on 5/25/26.
//

import Foundation
import Combine
import FirebaseAuth

class AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var currentUser: FirebaseAuth.User?
    @Published var isAuthenticated: Bool = false
    
    private var authListener: AuthStateDidChangeListenerHandle?
    
    init() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.isAuthenticated = user != nil
            }
        }
    }
    
    // MARK: - Register
    func register(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }
    
    // MARK: - Login
    func login(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        try? Auth.auth().signOut()
    }
}
