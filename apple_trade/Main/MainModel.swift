//
//  MainModel.swift
//  apple_trade
//
// Created by Öykü Hazer Ekinci on 15.11.2023.

import SwiftUI

struct Product: Identifiable, Hashable {
    let id: String
    let name: String
    let colors: [String]
    let attributes: [String: Any]

    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
