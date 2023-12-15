//
//  AuthViewModel.swift
//  apple_trade
//
// Created by Öykü Hazer Ekinci on 04.11.2023.

import SwiftUI
import FirebaseAuth
import Combine

class AuthViewModel: ObservableObject {
    @Published var user: User = User(email: "", password: "")
    @Published var isSecureTextEntry: Bool = true
    @Published var isSignUp: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    private var cancellables: Set<AnyCancellable> = []

    public func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    public func isValidPassword(_ password: String) -> Bool {
        let specialCharacterSet = CharacterSet(charactersIn: "!@#$%^&*()_-+=<>?/[]{},.:;")
        return password.count >= 5 && password.rangeOfCharacter(from: specialCharacterSet) != nil
    }

    func signUp() {
        guard isValidEmail(user.email) else {
            showAlert = true
            alertMessage = "Invalid email address"
            return
        }

        guard isValidPassword(user.password) else {
            showAlert = true
            alertMessage = "Invalid password. Password must be at least 5 characters and contain special characters."
            return
        }

        AuthNetworkManager.shared.createUser(email: user.email, password: user.password)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.showAlert = true
                    self.alertMessage = "Registration failed: \(error.localizedDescription)"
                }
            } receiveValue: { success, message in
                self.showAlert = true
                self.alertMessage = message
            }
            .store(in: &cancellables)
    }

    func signIn() {
        guard isValidEmail(user.email) else {
            showAlert = true
            alertMessage = "Invalid email address"
            return
        }

        guard isValidPassword(user.password) else {
            showAlert = true
            alertMessage = "Invalid password. Password must be at least 5 characters and contain special characters."
            return
        }

        AuthNetworkManager.shared.signInUser(email: user.email, password: user.password)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.showAlert = true
                    self.alertMessage = "Login failed: \(error.localizedDescription)"
                }
            } receiveValue: { success, message in
                self.showAlert = true
                self.alertMessage = message
            }
            .store(in: &cancellables)
    }
}

