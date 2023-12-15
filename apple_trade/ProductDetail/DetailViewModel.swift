//
//  DetailViewModel.swift
//  apple_trade
//
// Created by Öykü Hazer Ekinci on 18.11.2023.

import SwiftUI
import Combine
import FirebaseStorage

class DetailViewModel: ObservableObject {
    @Published var productName: String
    @Published var attributes: [String: Any]
    @Published var productImage: UIImage?
    @Published var selectedColor: String?
    @Published var selectedValues: [String: String?] = [:]
    @Published var filteredKeys: [String] = []

    private var cancellables: Set<AnyCancellable> = []

    let additionalKeys: [String] = ["Memory", "SSD", "Connection", "Strap", "Keyboard", "Pencil"]

    init(productName: String, attributes: [String: Any]) {
        self.productName = productName
        self.attributes = attributes
        self.downloadProductImage()

        self.filteredKeys = [
            "Size", "CPU", "GPU", "Power", "Temperature", "Humidity",
            "Altitude", "Neural Engine", "Case Size",
            "Struct", "Charging Box", "Listening Time",
            "Design", "Personalized", "Sounds", "Blocker",
            "Awareness", "Screen", "Contents Display"
        ]
    }

    func downloadProductImage() {
        let storage = Storage.storage()
        let storageReference = storage.reference().child("\(productName).png")

        storageReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Image download error: \(error.localizedDescription)")
            } else {
                if let imageData = data {
                    if let uiImage = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.productImage = uiImage
                        }
                    }
                }
            }
        }
    }

    func formatValue(_ value: Any) -> String {
        if let subAttributes = value as? [String] {
            return subAttributes.joined(separator: " ")
        } else if let subAttributes = value as? [String: String] {
            return subAttributes.map { "\($0.key): \($0.value)" }.joined(separator: " ")
        } else {
            return String(describing: value)
        }
    }

    func isBlackBorder(_ key: String) -> Bool {
        return additionalKeys.contains(key)
    }

    func saveDataToFirestore() {
        guard let selectedColor = selectedColor else {
            print("Error: selectedColor value is missing.")
            return
        }

        guard !selectedValues.isEmpty else {
            print("Error: selectedValues ​​value is missing.")
            return
        }

        guard let price = attributes["Price"] as? String else {
            print("Error: attributes['Price'] value is missing or not String.")
            return
        }

        guard !productName.isEmpty else {
            print("Error: productName value is missing or empty.")
            return
        }

        DetailNetworkManager.shared.saveDataToFirestore(productName: productName, selectedColor: selectedColor, selectedValues: selectedValues, price: price)
    }
}
