//
//  CompanyPickerViewModel.swift
//  Compounded
//
//  Created by Lulwah almisfer on 20/09/2025.
//


import SwiftUI
import Combine

@MainActor
class CompanyPickerViewModel: ObservableObject {
    @Published var companies: [Company] = []
    @Published var search: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let tokenManager = PushManager.shared

    var filteredCompanies: [Company] {
        if search.isEmpty { return companies }
        return companies.filter {
            $0.companyShortNameEn.lowercased().contains(search.lowercased()) ||
            $0.companyShortNameAr.lowercased().contains(search.lowercased()) ||
            $0.id.lowercased().contains(search.lowercased())
        }
    }

    func loadCompanies() async {
        guard let url = URL(string: "https://www.saudiexchange.sa/tadawul.eportal.theme.helper/TickerServlet") else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(CompanyResponse.self, from: data)
            companies = decoded.stockData
        } catch {
            errorMessage = "❌ Failed to load companies: \(error.localizedDescription)"
        }
    }

    func subscribe(to company: Company) async throws {
        guard let deviceToken = tokenManager.deviceToken else {
            throw NSError(domain: "CompanyPicker", code: -1, userInfo: [NSLocalizedDescriptionKey: "No device token available"])
        }

        try await tokenManager.subscribeToCompany(
            deviceToken: deviceToken,
            companySymbol: company.id
        )
    }
}
