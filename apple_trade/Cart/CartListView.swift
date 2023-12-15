//
//  CartListView.swift
//  apple_trade
//
// Created by Öykü Hazer Ekinci on 14.12.2023.

import SwiftUI
import Combine
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseDatabase


struct CartListView: View {
 @StateObject private var viewModel = CartListViewModel()

 var body: some View {
     VStack {
         Text("Cart List")
             .font(.system(size: 25, weight: .bold))
             .fontWeight(.bold)
             .foregroundColor(.white)
             .padding(.top, -40)

         List {
             ForEach(viewModel.cartItems, id: \.id) { cartItem in
                 HStack(spacing: 10) {
                     if let productImage = viewModel.productImages[cartItem.productName] {
                         Image(uiImage: productImage)
                             .resizable()
                             .aspectRatio(contentMode: .fit)
                             .frame(width: 80, height: 80)
                             .padding(.vertical, 10)
                     }

                     VStack(alignment: .leading) {
                         Text(cartItem.productName)
                             .font(.headline)
                             .padding(.bottom, 10)
                         ForEach(cartItem.selectedValues.sorted(by: { $0.0 < $1.0 }), id: \.key) { key, value in
                             HStack {
                                 Text("\(key):")
                                     .font(.subheadline)
                                     .foregroundColor(.white)

                                 let components = value.components(separatedBy: ":")
                                 if components.count == 2 {
                                     VStack(alignment: .leading) {
                                         Text(components[0].trimmingCharacters(in: .whitespacesAndNewlines))
                                             .font(.subheadline)
                                     }
                                 }
                             }
                         }

                         Text("Additional Price: $\(viewModel.calculateAdditionalPrice(for: cartItem), specifier: "%.2f")")
                             .font(.subheadline)
                             .foregroundColor(.white)

                         HStack {
                             Text("Price: $\(cartItem.price)")
                                 .font(.subheadline)
                                 .foregroundColor(.white)
                         }

                         HStack {
                             Text("Selected Color: ")
                                 .font(.subheadline)

                             Image(cartItem.selectedColor)
                                 .resizable()
                                 .aspectRatio(contentMode: .fit)
                                 .frame(width: 15, height: 15)
                                 .padding(.vertical, 10)

                             Text("(\(cartItem.selectedColor))")
                                 .font(.subheadline)
                         }
                     }
                 }
                 .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                 .swipeActions {
                     Button(action: {
                         viewModel.deleteCartItem(cartItem: cartItem)
                     }) {
                         Label("Delete", systemImage: "trash")
                             .tint(.white)
                     }
                     .tint(.black)
                 }
             }
             .listRowBackground(
                 Divider()
                     .background(Color.white)
                     .padding(.top, 190)
             )
             .listRowBackground(Color.black)
         }
         .listStyle(PlainListStyle())
         .onAppear {
             viewModel.fetchCartItems()
         }
         .padding(.top, -10)

         VStack {
             Text("Total Price: $\(viewModel.totalPrice, specifier: "%.2f")")
                 .font(.headline)
                 .foregroundColor(.white)
                 .padding(.top, 50)
                 .padding(.trailing, -125)

             if viewModel.discountApplied {
                 Text("Discount Amount: -$\(viewModel.totalPrice * 0.25, specifier: "%.2f") ")
                     .font(.headline)
                     .foregroundColor(.white)
                     .padding(.top, -10)
                     .padding(.trailing, -70)

                 Text("Discounted Total Price: $\(viewModel.discountedTotalPrice, specifier: "%.2f")")
                     .font(.headline)
                     .foregroundColor(.white)
                     .padding(.top, -10)
                     .padding(.trailing, -30)
             }

             Button(action: {
                 if !viewModel.discountApplied {
                     viewModel.applyDiscount()
                     viewModel.discountApplied = true
                     viewModel.showDiscountButton = false
                 }
             }) {
                 Text("Apply Discount")
                     .font(.headline)
                     .foregroundColor(.black)
                     .frame(width: 200, height: 40)
             }
             .background(Color.white)
             .cornerRadius(5)
             .padding(.top, 10)
             .padding(.trailing, -110)
             .padding(.bottom, -10)
         }
         .padding(.top, 20)
         .padding(.bottom, 20)

         Spacer()
     }
     .background(Color.black)
     .foregroundColor(Color.white)
 }
}
 

