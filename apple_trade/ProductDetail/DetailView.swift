//
//  DetailView.swift
//  apple_trade
//
// Created by Öykü Hazer Ekinci on 18.11.2023.


import SwiftUI
import Combine
import FirebaseStorage
import Firebase
import FirebaseFirestore


struct DetailView: View {
    @StateObject var viewModel: DetailViewModel

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Product Information").font(.headline)) {
                    VStack {
                        Text(viewModel.productName)
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.top, 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    if let productImage = viewModel.productImage {
                        Image(uiImage: productImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                            .offset(x: (UIScreen.main.bounds.width - 300) / 5.3)
                    }

                    if let colors = viewModel.attributes["Colors"] as? [String] {
                        Section {
                            HStack {
                                Spacer()
                                ForEach(colors, id: \.self) { color in
                                    Image(color)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                        .padding(5)
                                        .onTapGesture {
                                            viewModel.selectedColor = color
                                        }
                                        .background(viewModel.selectedColor == color ? Color.black : Color.clear)
                                        .cornerRadius(15)
                                }
                                Spacer()
                            }
                        }
                    }
                }

                Section(header: Text("Attributes").font(.headline)) {
                    ForEach(viewModel.attributes.sorted(by: { a, b in
                        if a.key == "Colors" {
                            return true
                        } else if b.key == "Colors" {
                            return false
                        }

                        if viewModel.filteredKeys.contains(b.key) {
                            return true
                        } else if viewModel.filteredKeys.contains(a.key) {
                            return false
                        }

                        return b.key < a.key
                    }), id: \.key) { key, value in
                        if viewModel.filteredKeys.contains(where: { $0 == key }) {
                            VStack(alignment: .center) {
                                Text(key)
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .padding(10)
                                    .frame(width: 350, height: viewModel.isBlackBorder(key) ? 80 : 30)
                                    .background(viewModel.isBlackBorder(key) ? Color.white : Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(viewModel.isBlackBorder(key) ? Color.white : Color.white, lineWidth: 1)
                                    )

                                if let subAttributes = value as? [String] {
                                    ForEach(subAttributes, id: \.self) { subValue in
                                        Text("\(subValue)")
                                            .font(.system(size: 16))
                                            .padding(10)
                                            .frame(width: 350, height: viewModel.isBlackBorder(key) ? 80 : 30)
                                            .background(viewModel.isBlackBorder(key) ? Color.white : Color.white)
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(viewModel.isBlackBorder(key) ? Color.black : Color.white, lineWidth: 1)
                                            )
                                    }
                                } else if let subAttributes = value as? [String: String] {
                                    ForEach(subAttributes.sorted(by: { $0.key < $1.key }), id: \.key) { subKey, subValue in
                                        Text("\(subKey): \(subValue)")
                                            .font(.system(size: 16))
                                            .padding(10)
                                            .frame(width: 350, height: viewModel.isBlackBorder(key) ? 80 : 30)
                                            .background(viewModel.isBlackBorder(key) ? Color.white : Color.white)
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(viewModel.isBlackBorder(key) ? Color.black : Color.white, lineWidth: 1)
                                            )
                                    }
                                } else {
                                    Text("\(viewModel.formatValue(value))")
                                        .font(.system(size: 16))
                                        .padding(10)
                                        .frame(width: 350, height: viewModel.isBlackBorder(key) ? 80 : 30)
                                        .background(viewModel.isBlackBorder(key) ? Color.white: Color.white)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(viewModel.isBlackBorder(key) ? Color.black : Color.white, lineWidth: 1)
                                        )
                                }
                            }
                        }
                    }
                }

                Section(header: Text("Additional Attributes").font(.headline)) {
                    ForEach(viewModel.additionalKeys, id: \.self) { key in
                        if let value = viewModel.attributes[key] {
                            Section(header: Text(key)
                                            .font(.system(size: 18).weight(.semibold))
                                            .frame(maxWidth: .infinity, alignment: .center)) {
                                if let subAttributes = value as? [String: String] {
                                    ForEach(subAttributes.sorted(by: { $0.key < $1.key }), id: \.key) { subKey, subValue in
                                        VStack {
                                            Text("\(subKey): \(subValue)")
                                                .font(.system(size: 16))
                                                .padding(10)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 60)
                                                .foregroundColor(.gray)
                                                .background(viewModel.selectedValues[key] == "\(subKey): \(subValue)" ? Color.black : Color.white)
                                                .cornerRadius(10)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(viewModel.selectedValues[key] == "\(subKey): \(subValue)" ? Color.black : Color.black, lineWidth: 1)
                                                )
                                                .onTapGesture {
                                                    viewModel.selectedValues[key] = "\(subKey): \(subValue)"
                                                }
                                        }
                                        
                                    }
                                } else {
                                    VStack {
                                        Text("\(viewModel.formatValue(value))")
                                            .font(.system(size: 16))
                                            .padding(10)
                                            .foregroundColor(.gray)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 60)
                                            .background(viewModel.selectedValues[key] == viewModel.formatValue(value) ? Color.black : Color.white)
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(viewModel.selectedValues[key] == viewModel.formatValue(value) ? Color.black : Color.black, lineWidth: 1)
                                            )
                                            .onTapGesture {
                                                viewModel.selectedValues[key] = viewModel.formatValue(value)
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarItems(trailing:
                Button(action: {
                    viewModel.saveDataToFirestore()
                }) {
                    Image("add-cart")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding(.top, -20)
                        .padding(.bottom, -40)
                }
            )
            .overlay(
                VStack {
                    Spacer()
                    if let price = viewModel.attributes["Price"] {
                        HStack {
                            Spacer()
                            Text("Price: \(viewModel.formatValue(price))")
                                .foregroundColor(.white)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(Color.black)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                            Spacer()
                        }
                    }
                    if let selectedColor = viewModel.selectedColor {
                        HStack {
                            Spacer()
                            Text("Selected Color: \(selectedColor)")
                                .foregroundColor(.white)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(Color.black)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                            Spacer()
                        }
                    }
                    if !viewModel.additionalKeys.isEmpty {
                        let selectedAdditionalValues = viewModel.selectedValues.compactMap { (key, value) in
                            return viewModel.additionalKeys.contains(key) ? value : nil
                        }
                        if !selectedAdditionalValues.isEmpty {
                            HStack {
                                Spacer()
                                Text("Additional Values: \(selectedAdditionalValues.joined(separator: ", "))")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.black)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white, lineWidth: 1)
                                    )
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.horizontal),
                alignment: .bottom
            )
        }
        .onAppear {
            viewModel.downloadProductImage()
        }
    }
}
