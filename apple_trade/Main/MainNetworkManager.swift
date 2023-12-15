//
//  MainNetworkManager.swift
//  apple_trade
//
// Created by Öykü Hazer Ekinci on 15.11.2023.

import SwiftUI
import Combine
import Firebase
import FirebaseDatabase
import FirebaseStorage

class MainNetworkManager {
    static let shared = MainNetworkManager()
    
    private init() {}

    func fetchDataFromFirebase(category: String) -> Future<[String: [String: Any]], Error> {
        return Future<[String: [String: Any]], Error> { promise in
            let ref = Database.database().reference().child("PRODUCTS").child(category)
            
            ref.observeSingleEvent(of: .value) { snapshot, error in
                if let error = error {
                    promise(.failure(error as! Error))
                    return
                }

                guard let data = snapshot.value as? [String: [String: Any]] else {
                    promise(.failure(MainError.dataConversionError))
                    return
                }

                promise(.success(data))
            }
        }
    }
    
    func downloadImage(from url: URL) -> AnyPublisher<Data, URLError> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .eraseToAnyPublisher()
    }
}
