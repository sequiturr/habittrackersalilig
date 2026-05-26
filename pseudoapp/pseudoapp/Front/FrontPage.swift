//
//  ContentView.swift
//  HabitTracker-Salilig
//
//  Created by Charle Salilig on 5/22/26.
//

import SwiftUI

struct FrontPage: View {
    
    @StateObject var viewModel = AuthViewModel()
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                ScrollView {
                    VStack (spacing: 20) {
                        Text("🔥")
                            .font(.system(size: 80))
                        Text("Habit Tracker")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("ITEL414")
                        Text("by Salilig")
                            .padding(.bottom, 20)
                        
                        // Email
                        TextField("Email", text: $viewModel.email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .padding(.horizontal, 40)
                        
                        // Password
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 40)
                        
                        // Confirm Password (Register only)
                        if !viewModel.isLoginMode {
                            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal, 40)
                        }
                        
                        // Error message
                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .foregroundStyle(.red)
                                .font(.caption)
                                .padding(.horizontal, 40)
                        }
                        
                        // Login / Register button
                        Button(action: {
                            viewModel.submit()
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .frame(width: 200)
                                    .padding()
                                    .background(.blue)
                                    .cornerRadius(10)
                            } else {
                                Text(viewModel.isLoginMode ? "Login" : "Register")
                                    .frame(width: 200)
                                    .padding()
                                    .background(.blue)
                                    .foregroundStyle(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .disabled(viewModel.isLoading)
                        
                        // Toggle
                        Button(action: {
                            withAnimation {
                                viewModel.isLoginMode.toggle()
                                viewModel.errorMessage = ""
                            }
                        }) {
                            Text(viewModel.isLoginMode
                                 ? "Don't have an account? Register"
                                 : "Already have an account? Login")
                                .font(.footnote)
                                .foregroundStyle(.blue)
                        }
                    }
                    .padding(.vertical, 40)
                }
            }
        }
    }
}

#Preview {
    FrontPage()
}
