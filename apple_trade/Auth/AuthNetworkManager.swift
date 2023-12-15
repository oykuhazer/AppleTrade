//
//  AuthNetworkManager.swift
//  apple_trade
//
// Created by Öykü Hazer Ekinci on 04.11.2023.

import SwiftUI
import FirebaseAuth
import Combine

class AuthNetworkManager {
    static let shared = AuthNetworkManager()

    private init() {}

    func createUser(email: String, password: String) -> AnyPublisher<(Bool, String), Error> {
        return Future<(Bool, String), Error> { promise in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success((true, "Registration successful!")))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func signInUser(email: String, password: String) -> AnyPublisher<(Bool, String), Error> {
        return Future<(Bool, String), Error> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success((true, "Login successful!")))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
