//
//  CartNetworkManager.swift
//  apple_trade
//
//  Created by Öykü Hazer Ekinci on 14.12.2023.
//

import SwiftUI
import Combine
import FirebaseFirestore

class CartNetworkManager: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []

    func fetchCartItems() -> Future<[CartItem], Error> {
        let subject = PassthroughSubject<[CartItem], Error>()

        let db = Firestore.firestore()

        db.collection("cartItems").getDocuments { snapshot, error in
            if let error = error {
                subject.send(completion: .failure(error))
            } else if let documents = snapshot?.documents {
                var cartItems: [CartItem] = []

                for document in documents {
                    let data = document.data()
                    let id = document.documentID
                    let productName = data["productName"] as? String ?? ""
                    let selectedColor = data["selectedColor"] as? String ?? ""
                    let selectedAdditionalKey = data["selectedAdditionalKey"] as? String ?? ""
                    let selectedValues = data["selectedValues"] as? [String: String] ?? [:]
                    let priceString = data["price"] as? String ?? "0.0"
                    let productImageName = data["productImageName"] as? String ?? ""

                    guard let price = self.convertPriceStringToDouble(priceString) else {
                        continue
                    }

                    let cartItem = CartItem(
                        id: id,
                        productName: productName,
                        selectedColor: selectedColor,
                        selectedAdditionalKey: selectedAdditionalKey,
                        selectedValues: selectedValues,
                        price: String(price),
                        productImageName: productImageName
                    )

                    cartItems.append(cartItem)
                }

                subject.send(cartItems)
                subject.send(completion: .finished)
            }
        }

        return Future<[CartItem], Error> { promise in
            subject.sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    promise(.failure(error))
                }
            }, receiveValue: { value in
                promise(.success(value))
            })
            .store(in: &self.cancellables)
        }
    }

 func deleteCartItem(cartItem: CartItem, completion: @escaping (Result<Void, Error>) -> Void) {
     let db = Firestore.firestore()

     db.collection("cartItems").document(cartItem.id).delete { error in
         if let error = error {
             print("Error deleting cart item: \(error.localizedDescription)")
             completion(.failure(error))
         } else {
             completion(.success(()))
         }
     }
 }

 func convertPriceStringToDouble(_ priceString: String) -> Double? {
     let numberFormatter = NumberFormatter()
     numberFormatter.locale = Locale(identifier: "tr_TR")
     numberFormatter.numberStyle = .decimal
     numberFormatter.minimumFractionDigits = 2
     numberFormatter.maximumFractionDigits = 2

     if let number = numberFormatter.number(from: priceString) {
         return number.doubleValue
     } else {
         print("Incorrect price format: \(priceString)")
         return nil
     }
 }
}

