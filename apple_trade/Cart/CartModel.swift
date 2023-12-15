//
//  CartModel.swift
//  apple_trade
//
//  Created by Öykü Hazer Ekinci on 14.12.2023.
//

import SwiftUI

struct CartItem: Identifiable {
 var id: String
 var productName: String
 var selectedColor: String
 var selectedAdditionalKey: String
 var selectedValues: [String: String]
 var price: String
 var productImageName: String
}

