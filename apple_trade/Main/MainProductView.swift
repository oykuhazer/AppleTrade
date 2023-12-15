//
//  MainProductView.swift
//  apple_trade
//
// Created by Öykü Hazer Ekinci on 15.11.2023.

import SwiftUI

struct ProductView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    let productName: String

    var body: some View {
        VStack {
            HStack {
                Image(productName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                Text(productName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
        }
        .frame(width: 150, height: 50)
        .border(Color.gray, width: 1)
        .background(Color.white)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color.gray, lineWidth: 3))
    }
}
