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

    @StateObject private var viewModel = CompanyPickerViewModel()

    var body: some View {
        List(viewModel.filteredCompanies) { company in
            Button {
                Task {
                    await handleCompanySelection(company)
                }
            } label: {
                VStack(alignment: .leading) {
                    Text(Helper.isArabic() ? company.companyShortNameAr : company.companyShortNameEn)
                    Text(company.id)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $viewModel.search, placement: .navigationBarDrawer(displayMode: .always))
        .task { await viewModel.loadCompanies() }
        .navigationTitle("Companies")
        .overlay {
            if viewModel.isLoading {
                ProgressView("Loading...")
            }
        }
    }
    
    func handleCompanySelection(_ company: Company) async {
        do {
            try await viewModel.subscribe(to: company)

            let favorite = FavoriteCompany(
                id: company.id,
                nameAr: company.companyShortNameAr,
                nameEn: company.companyShortNameEn
            )

            modelContext.insert(favorite)
            try modelContext.save()

            print("✅ Subscribed to \(company.companyShortNameEn)")
            dismiss()
        } catch {
            print("❌ Failed to subscribe: \(error)")
        }
    }
}

#Preview {
    NavigationStack{
        CompanyPickerView()
    }
}

