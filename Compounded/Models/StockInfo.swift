//
//  StockInfo.swift
//  Compounded
//
//  Created by Lulwah almisfer on 25/04/2025.
//

import Foundation

struct StockInfo: Codable {
    let symbol: String
    let title_en: String
}

struct StockInfoContainer: Codable {
    let stocks: [StockInfo]
}
