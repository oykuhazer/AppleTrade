//
//  MainProductDetailView.swift
//  apple_trade
//
// Created by Öykü Hazer Ekinci on 15.11.2023.

import SwiftUI
import FirebaseFirestore

struct ProductDetailView: View {
    @ObservedObject var viewModel: MainViewModel
    let product: Product

    var body: some View {
        VStack(spacing: -15) {
            Text(product.name)
                .font(.system(size: 15))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding(.top, 50)

            ZStack(alignment: .topTrailing) {
                if let image = viewModel.productImages[product.name] {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 130, height: 180)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 250)
                }
                Button(action: {
                    let db = Firestore.firestore()
                    db.collection("PRODUCTS")
                        .addDocument(data: ["productName": product.name])
                        { error in
                            if let error = error {
                                print("Firestore'a veri eklenirken hata oluştu: \(error)")
                            } else {
                                print("\(product.name) başarıyla Firestore'a eklendi.")
                            }
                        }
                }) {
                    Image("applelogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding()
                }
                .padding([.top, .trailing], -30)
                .padding(.top, -30)
            }

            Spacer(minLength: 5)

            HStack {
                Spacer()
                ForEach(product.colors, id: \.self) { color in
                    Image(color)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 10, height: 10)
                }
                Spacer()
            }
        }
        .frame(width: 170, height: 250)
        .padding(.bottom, 40)
        .border(Color.gray, width: 1)
        .background(Color.white)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color.gray, lineWidth: 3))
    }
}
