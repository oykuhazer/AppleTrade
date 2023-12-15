//
//  FavoriteListView.swift
//  apple_trade
//
//  Created by Öykü Hazer Ekinci on 10.12.2023.

import SwiftUI
import Combine
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct FavoriteListView: View {
    @StateObject private var viewModel = FavoriteListViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.favoriteProducts) { favoriteProduct in
                    HStack {
                        if let image = viewModel.productImages[favoriteProduct.productName] {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                        }

                        Text(favoriteProduct.productName)

                        Spacer()

                        Button(action: {
                            viewModel.deleteFavoriteProduct(productName: favoriteProduct.productName)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.black)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.toggleSelection(productName: favoriteProduct.productName)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: viewModel.selectedProducts.contains(favoriteProduct.productName) ? 5 : 3)
                            .background(viewModel.selectedProducts.contains(favoriteProduct.productName) ? Color.gray : Color.white)
                            .cornerRadius(10)
                    )
                    .foregroundColor(Color.black)
                }
                .listRowBackground(Color.black)
            }
            .onAppear {
                viewModel.fetchFavoriteProductsFromFirestore()
            }
            .navigationBarItems(trailing:
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.deleteSelectedProducts()
                    }) {
                        Image(systemName: "checkmark.rectangle")
                            .foregroundColor(.white)
                    }
                    .padding(.top, 30)
                }
            )
            .listStyle(PlainListStyle())
            .padding(20)
            .background(Color.black)
            .foregroundColor(Color.white)
        }
    }
}
