//
//  CompoundInterestViewModel.swift
//  Compounded
//
//  Created by Lulwah almisfer on 18/04/2025.
//

import Foundation
import SwiftUI

class CompoundInterestViewModel: ObservableObject {
    @Published var initialDeposit: Double? = 1000
    @Published var contribution: Double? = 100
    @Published var interestRate: Double = 5.0
    @Published var years: Int? = 10
    @Published var isMonthly: Bool = true

    @Published var results: [CompoundInterestResult] = []

    var chartData: [ChartEntry] {
        results.flatMap { result in
            [
                ChartEntry(year: result.year, value: result.nonCompounded, type: "Non-Compounded",color: .green),
                ChartEntry(year: result.year, value: result.futureValue, type: "Compounded",color: .accentColor),
            ]
        }
    }

    
    func calculate() {
        guard let deposit = initialDeposit,
              let contrib = contribution,
              let years = years else {
            results = []
            return
        }

        let n = isMonthly ? 12.0 : 1.0
        let r = interestRate / 100.0 / n
        let t = Double(years)

        var futureValues: [CompoundInterestResult] = []

        for year in 1...Int(t) {
            let periods = Double(year) * n


            let compound = deposit * pow(1 + r, periods) +
                contrib * (pow(1 + r, periods) - 1) / r

            let nonCompound = deposit + contrib * periods

            let totalContributions = deposit + contrib * periods

            futureValues.append(CompoundInterestResult(
                year: year,
                totalContributions: totalContributions,
                futureValue: compound,
                nonCompounded: nonCompound
            ))
        }

        results = futureValues
    }
}
