//
//  CartListViewModel.swift
//  apple_trade
//
//  Created by Öykü Hazer Ekinci on 14.12.2023.
//

import SwiftUI
import Combine
import FirebaseStorage

class CartListViewModel: ObservableObject {
 private var cancellables: Set<AnyCancellable> = []
 @Published var cartItems: [CartItem] = []
 @Published var productImages: [String: UIImage] = [:]
 @Published var totalPrice: Double = 0
 @Published var discountedTotalPrice: Double = 0
 @Published var discountApplied: Bool = false
 @Published var showDiscountButton: Bool = true
 private let networkManager = CartNetworkManager()

 func updateTotalPrice() {
     let additionalPrice = cartItems.reduce(0.0) { $0 + calculateAdditionalPrice(for: $1) }
     totalPrice = cartItems.reduce(0.0) { $0 + (Double($1.price) ?? 0.0) } + additionalPrice

     if discountApplied {
         discountedTotalPrice = totalPrice * 0.75
     } else {
         discountedTotalPrice = totalPrice
     }
 }

 func applyDiscount() {
     discountedTotalPrice = totalPrice - (totalPrice * 0.25)
     discountApplied = true
     showDiscountButton = false
 }

 func calculateAdditionalPrice(for cartItem: CartItem) -> Double {
     var additionalPrice = 0.0

     for (_, value) in cartItem.selectedValues {
         let components = value.components(separatedBy: ":")
         if components.count == 2 {
             let additionalPriceString = components[1].trimmingCharacters(in: .whitespacesAndNewlines)

             let cleanAdditionalPriceString = additionalPriceString
                 .replacingOccurrences(of: ",", with: "")
                 .replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)

             if let additionalPriceValue = Double(cleanAdditionalPriceString) {
                 additionalPrice += additionalPriceValue * 100
             } else {
                 print("Hatalı additional price formatı: \(value)")
             }
         } else {
             print("Hatalı additional price formatı: \(value)")
         }
     }

     return additionalPrice
 }

 func deleteCartItem(cartItem: CartItem) {
     networkManager.deleteCartItem(cartItem: cartItem) { [weak self] result in
         guard let self = self else { return }
         switch result {
         case .success:
             if let index = self.cartItems.firstIndex(where: { $0.id == cartItem.id }) {
                 self.cartItems.remove(at: index)
                 self.updateTotalPrice()
             }
         case .failure(let error):
             print("Firestore'dan silme hatası: \(error.localizedDescription)")
         }
     }
 }

    func fetchCartItems() {
            networkManager.fetchCartItems()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error fetching cart items: \(error.localizedDescription)")
                    }
                }, receiveValue: { [weak self] cartItems in
                    guard let self = self else { return }
                    self.cartItems = cartItems
                    self.updateTotalPrice()

                    for cartItem in cartItems {
                        self.downloadProductImage(imageName: cartItem.productImageName, productName: cartItem.productName)
                    }
                })
                .store(in: &cancellables)
        }

 func downloadProductImage(imageName: String, productName: String) {
     print("Trying to download image: \(imageName) for product: \(productName)")

     let fullImageName = "\(productName).png"
     let storageRef = Storage.storage().reference(withPath: fullImageName)

     storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
         if let error = error {
             print("Error downloading image: \(error)")
         } else if let data = data, let image = UIImage(data: data) {
             DispatchQueue.main.async {
                 print("Image downloaded successfully for product: \(productName)")
                 self.productImages[productName] = image
             }
         }
     }
 }
}
