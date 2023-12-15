//
//  FavNetworkManager.swift
//  apple_trade
//
//Created by Öykü Hazer Ekinci on 07.12.2023.

import SwiftUI
import Combine
import FirebaseFirestore

class FavNetworkManager {
    static func fetchDataFromFirestore(collection: String) -> AnyPublisher<QuerySnapshot, Error> {
        let db = Firestore.firestore()

        return Future<QuerySnapshot, Error> { promise in
            db.collection(collection).getDocuments { (querySnapshot, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(querySnapshot!))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
