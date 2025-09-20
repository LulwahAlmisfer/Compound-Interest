//
//  CompanyResponse.swift
//  Compounded
//
//  Created by Lulwah almisfer on 20/09/2025.
//


struct CompanyResponse: Codable {
    var stockData: [Company]
}

struct Company: Codable, Identifiable {
    var id: String { pk_rf_company }
    let pk_rf_company: String
    let companyShortNameEn: String
    let companyShortNameAr: String
}
