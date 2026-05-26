//
//  AuthViewModel.swift
//  HabitTracker-Salilig
//
//  Created by Charle Salilig on 5/25/26.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isLoginMode: Bool = true
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    func submit() {
        errorMessage = ""
        
        // Basic checks
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        
        if !isLoginMode {
            guard password == confirmPassword else {
                errorMessage = "Passwords do not match."
                return
            }
        }
        
        isLoading = true
        
        if isLoginMode {
            AuthService.shared.signIn(email: email, password: password) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success:
                        break
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
        } else {
            AuthService.shared.signUp(email: email, password: password) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success:
                        break
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}
