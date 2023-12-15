//
//  MainViewModel.swift
//  apple_trade
//
// Created by Öykü Hazer Ekinci on 15.11.2023.

import SwiftUI
import Combine
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class MainViewModel: ObservableObject {
    @Published var firebaseProducts: [Product] = []
    @Published var selectedCategory: String?
    @Published var productImages: [String: UIImage] = [:]

    private var cancellables: Set<AnyCancellable> = []

    func fetchAndPrintDataFromFirebase() {
        guard let selectedCategory = selectedCategory else { return }

        MainNetworkManager.shared.fetchDataFromFirebase(category: selectedCategory)
            .map { data -> [Product] in
                return data.map { (product, attributes) in
                    let colors = attributes["Colors"] as? [String] ?? []
                    return Product(id: product, name: product, colors: colors, attributes: attributes)
                }
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] products in
                self?.firebaseProducts = products

                for product in products {
                    let imageName = "\(product.name).png"
                    self?.downloadProductImage(imageName: imageName, productName: product.name)
                }
            })
            .store(in: &cancellables)
    }

    func downloadProductImage(imageName: String, productName: String) {
        let storageRef = Storage.storage().reference(withPath: imageName)

        storageRef.downloadURL { url, error in
            if let error = error {
                print("Error getting download URL: \(error)")
                return
            }

            guard let url = url else {
                print("Download URL is nil.")
                return
            }

            MainNetworkManager.shared.downloadImage(from: url)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error: \(error)")
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] data in
                    if let image = UIImage(data: data) {
                        self?.productImages[productName] = image
                    }
                })
                .store(in: &self.cancellables)
        }
    }
}

enum MainError: Error {
    case dataConversionError
}
