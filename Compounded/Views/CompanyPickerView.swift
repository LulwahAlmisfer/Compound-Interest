//
//  CompanyPickerView.swift
//  Compounded
//
//  Created by Lulwah almisfer on 05/09/2025.
//

import SwiftUI

struct CompanyPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var companies: [Company] = []
    @State private var search = ""
    @ObservedObject var tokenManager = PushManager.shared

    
    var body: some View {
            List(filteredCompanies) { company in
                Button {
                    Task {
                        do {
                            guard let tokenmanagerDeviceToken = tokenManager.deviceToken else {
                                print("❌ No device token available.")
                                return
                            }
                            try await tokenManager.subscribeToCompany(
                                deviceToken: tokenmanagerDeviceToken,
                                companySymbol: company.id
                            )
                            
                            let favorite = FavoriteCompany(
                                id: company.id,
                                nameAr: company.companyShortNameAr,
                                nameEn: company.companyShortNameEn
                            )
                            
                            modelContext.insert(favorite)
                            try modelContext.save()
                            

                            print("✅ Subscribed to \(company.companyShortNameEn)")
                        } catch {
                            print("❌ Failed to subscribe: \(error)")
                        }
                        dismiss()
                    }
                } label: {
                    Text(Helper.isArabic() ? company.companyShortNameAr : company.companyShortNameEn)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $search,placement: .navigationBarDrawer(displayMode: .always))
            .task {
                await loadCompanies()
            }
    }
    
    var filteredCompanies: [Company] {
        if search.isEmpty { return companies }
        return companies.filter { $0.companyShortNameEn.lowercased().contains(search.lowercased()) ||
            $0.companyShortNameAr.lowercased().contains(search.lowercased()) ||
            $0.id.lowercased().contains(search.lowercased())
        }
    }
    
    private func loadCompanies() async {
        guard let url = URL(string: "https://www.saudiexchange.sa/tadawul.eportal.theme.helper/TickerServlet") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(CompanyResponse.self, from: data)
            companies = decoded.stockData
        } catch {
            print("Error: \(error)")
        }
    }
}

struct CompanyResponse: Codable {
    var stockData: [Company]
}

struct Company: Codable, Identifiable {
    var id: String { pk_rf_company }
    let pk_rf_company: String
    let companyShortNameEn: String
    let companyShortNameAr: String
}

#Preview {
    NavigationStack{
        CompanyPickerView()
    }
}

