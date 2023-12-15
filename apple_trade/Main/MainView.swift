//
//  MainView.swift
//  apple_trade
//
// Created by Öykü Hazer Ekinci on 15.11.2023.

import SwiftUI
import Combine
import Firebase
import FirebaseDatabase
import FirebaseStorage

struct MainView: View {
    @ObservedObject var viewModel = MainViewModel()
    let products = ["MacBook", "Apple Watch", "iPad", "iPhone", "AirPods"]

    var body: some View {
        NavigationView {
            VStack {
                Text("Product List")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, -145)
                    .padding(.bottom, 0)

                Text("High Performance, Aesthetic Design: Apple Products")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, -70)
                    .padding(.leading, -10)

                ScrollView(.horizontal) {
                    LazyHGrid(rows: [GridItem(.fixed(300))], spacing: 25) {
                        ForEach(products, id: \.self) { product in
                            ProductView(viewModel: viewModel, productName: product)
                                .onTapGesture {
                                    viewModel.selectedCategory = product
                                    viewModel.fetchAndPrintDataFromFirebase()
                                }
                        }
                    }
                    .frame(height: 180)
                    .padding(.top, -50)
                }

                Text("Products")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, -20)
                    .padding(.leading, -180)

                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(minimum: 150, maximum: 200), spacing: 20),
                        GridItem(.flexible(minimum: 150, maximum: 200), spacing: 20)
                    ], spacing: 15) {
                        ForEach(viewModel.firebaseProducts) { product in
                            NavigationLink(destination: DetailView(viewModel: DetailViewModel(productName: product.name, attributes: product.attributes))) {
                                ProductDetailView(viewModel: viewModel, product: product)
                            }
                        }
                    }
                    .padding(.top, 0)
                    .background(GeometryReader { geometry in
                        Color.clear.onAppear {
                            let lazyVGridHeight = geometry.size.height
                            print("LazyVGrid Yüksekliği: \(lazyVGridHeight)")
                        }
                    })
                }
            }
            .padding(15)
            .onAppear {
                viewModel.selectedCategory = "MacBook"
                viewModel.fetchAndPrintDataFromFirebase()
            }
            .background(Color.black)
            .navigationBarItems(
                leading: NavigationLink(destination: FavoriteListView()) {
                    Image("apple")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding()
                        .padding(.top, 6)
                },
                trailing: NavigationLink(destination: CartListView()) {
                    Image("cart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .padding()
                }
            )
        }
    }
}
