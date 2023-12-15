//
//  DetailNetworkManager.swift
//  apple_trade
//
// Created by Öykü Hazer Ekinci on 18.11.2023.

import SwiftUI
import Combine
import FirebaseFirestore

class DetailNetworkManager: ObservableObject {
    static let shared = DetailNetworkManager()

    private var cancellables: Set<AnyCancellable> = []

    private init() {}

    func saveDataToFirestore(productName: String, selectedColor: String, selectedValues: [String: String?], price: String) {
        let data: [String: Any] = [
            "productName": productName,
            "selectedColor": selectedColor,
            "selectedValues": selectedValues,
            "price": price
        ]

        let db = Firestore.firestore()

        Future<Void, Error> { promise in
            db.collection("cartItems").addDocument(data: data) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .finished:
                print("The data has been successfully added to Firestore.")
            case .failure(let error):
                print("Error adding data to Firestore: \(error.localizedDescription)")
                if let errorCode = (error as NSError).userInfo["error"] as? String {
                    print("Firestore Error Code: \(errorCode)")
                }
            }
        } receiveValue: { _ in }
        .store(in: &cancellables)
    }
}
