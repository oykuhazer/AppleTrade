//
//  FavViewModel.swift
//  apple_trade
//
// Created by Öykü Hazer Ekinci on 06.12.2023.

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseStorage

class FavoriteListViewModel: ObservableObject {
    @Published var favoriteProducts: [FavoriteProduct] = []
    @Published var selectedProducts: Set<String> = []
    @Published var productImages: [String: UIImage] = [:]
    @Published var showingDeleteAlert = false
    private var cancellables: Set<AnyCancellable> = []

    func toggleSelection(productName: String) {
        if selectedProducts.contains(productName) {
            selectedProducts.remove(productName)
        } else {
            selectedProducts.insert(productName)
        }
    }

    func deleteSelectedProducts() {
        selectedProducts.forEach { deleteFavoriteProduct(productName: $0) }
        selectedProducts.removeAll()
    }

    func fetchFavoriteProductsFromFirestore() {
        FavNetworkManager.fetchDataFromFirestore(collection: "PRODUCTS")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error retrieving data from Firestore: \(error)")
                }
            } receiveValue: { [weak self] querySnapshot in
                var favorites: [FavoriteProduct] = []

                for document in querySnapshot.documents {
                    if let productName = document.data()["productName"] as? String {
                        let favoriteProduct = FavoriteProduct(productName: productName)
                        favorites.append(favoriteProduct)
                        self?.downloadProductImage(imageName: "\(productName).png", productName: productName)
                    }
                }

                self?.favoriteProducts = favorites
            }
            .store(in: &cancellables)
    }

    func downloadProductImage(imageName: String, productName: String) {
        let storageRef = Storage.storage().reference(withPath: imageName)

        storageRef.getData(maxSize: 1 * 1024 * 1024) { [weak self] data, error in
            if let error = error {
                print("Image download error: \(error)")
            } else if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.productImages[productName] = image
                }
            }
        }
    }

    func deleteFavoriteProduct(productName: String) {
        let db = Firestore.firestore()

        FavNetworkManager.fetchDataFromFirestore(collection: "PRODUCTS")
            .flatMap { querySnapshot -> AnyPublisher<Void, Error> in
                let deletePublishers = querySnapshot.documents
                    .filter { $0.data()["productName"] as? String == productName }
                    .map { document in
                        Future<Void, Error> { promise in
                            db.collection("PRODUCTS").document(document.documentID).delete { error in
                                if let error = error {
                                    promise(.failure(error))
                                } else {
                                    promise(.success(()))
                                }
                            }
                        }
                        .eraseToAnyPublisher()
                    }

                return Publishers.MergeMany(deletePublishers)
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error while deleting product from Firestore: \(error)")
                } else {
                    print("\(productName) successfully deleted.")
                    DispatchQueue.main.async {
                        self.favoriteProducts.removeAll { $0.productName == productName }
                    }
                    self.fetchFavoriteProductsFromFirestore()
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
