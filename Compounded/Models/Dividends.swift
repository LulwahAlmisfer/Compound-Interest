//
//  Dividends.swift
//  Compounded
//
//  Created by Lulwah almisfer on 19/04/2025.
//

import SwiftUI

struct Dividends: Codable {
    let id: Int
    let symbol: String
    let type: TypeEnum
    let eventDate: Date
    let companyName: String
    let amount: Double
    
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
        self.amount = try container.decode(Double.self, forKey: .amount)
    }
}

enum TypeEnum: String, Codable {
    case distributionDate = "distributionDate"
    case dueDate = "dueDate"
    
    
    var title: String {
        switch self {
        case .distributionDate:
            return "Distribution Date"
        case .dueDate:
            return "Due Date"
        }
    }
    
    var color: Color {
        switch self {
        case .distributionDate:
            return .blue
        case .dueDate:
            return .red
        }
    }
}

