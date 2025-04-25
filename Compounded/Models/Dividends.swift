//
//  Dividends.swift
//  Compounded
//
//  Created by Lulwah almisfer on 19/04/2025.
//

import SwiftUI

struct Dividends: Codable,Identifiable {
    let id: Int
    let symbol: String
    let type: TypeEnum
    let eventDate: Date
    let companyName: String
    var companyNameEng: String?
    let amount: Double
    let imageUrl: String
    
    var isTasi: Bool {
        if let symbolNum = Int(symbol) {
            return symbolNum < 9000
        }
        return false
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.type = try container.decode(TypeEnum.self, forKey: .type)
        
        let dateString = try container.decode(String.self, forKey: .eventDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = formatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .eventDate, in: container, debugDescription: "Invalid date format")
        }
        self.eventDate = date

        self.companyName = try container.decode(String.self, forKey: .companyName)
        self.companyNameEng = try container.decodeIfPresent(String.self, forKey: .companyNameEng)
        self.amount = try container.decode(Double.self, forKey: .amount)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
    }
}

enum TypeEnum: String, Codable {
    case distributionDate = "distributionDate"
    case dueDate = "dueDate"
    
    
    var title: String {
        switch self {
        case .distributionDate:
            return "Dividend Distribution"
        case .dueDate:
            return "Dividend Entitlment"
        }
    }
    
    var color: Color {
        switch self {
        case .distributionDate:
            return .blue
        case .dueDate:
            return .green
        }
    }
    
    var imageTitle: String {
        switch self {
        case .distributionDate:
            return "creditcard"
        case .dueDate:
            return "calendar.badge.checkmark"
        }
    }
    
}
