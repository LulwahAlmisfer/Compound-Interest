//
//  CompoundInterestResult.swift
//  Compounded
//
//  Created by Lulwah almisfer on 19/04/2025.
//

import Foundation

struct CompoundInterestResult: Identifiable {
    let id = UUID()
    let year: Int
    let totalContributions: Double
    let futureValue: Double
    let nonCompounded: Double
}
