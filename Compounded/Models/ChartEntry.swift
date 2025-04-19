//
//  ChartEntry.swift
//  Compounded
//
//  Created by Lulwah almisfer on 19/04/2025.
//

import SwiftUI

struct ChartEntry: Identifiable {
    let id = UUID()
    let year: Int
    let value: Double
    let type: String
    let color: Color
}

