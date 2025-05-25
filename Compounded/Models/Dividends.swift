//
//  Dividends.swift
//  Compounded
//
//  Created by Lulwah almisfer on 19/04/2025.
//

import SwiftUI

struct Dividends: Codable, Identifiable {
    let id: Int
    let symbol: String
    let type: TypeEnum
    var eventDate: Date
    let companyName: String
    var companyNameEng: String?
    let amount: Double
    var imageUrl: String

    let holdingTime: Date?
    let holdingSite: String?
    let holdingType: holdingTypeEnum?

    var isTasi: Bool {
        if let symbolNum = Int(symbol) {
            return symbolNum < 9000
        }
        return false
    }

    enum CodingKeys: String, CodingKey {
        case id, symbol, type, eventDate, companyName, companyNameEng, amount, imageUrl, holdingTime, holdingSite, holdingType
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.type = try container.decode(TypeEnum.self, forKey: .type)

        let dateString = try container.decode(String.self, forKey: .eventDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let parsedDate = formatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .eventDate, in: container, debugDescription: "Invalid date format for eventDate")
        }
        self.eventDate = parsedDate

        self.companyName = try container.decode(String.self, forKey: .companyName)
        self.companyNameEng = try container.decodeIfPresent(String.self, forKey: .companyNameEng)
        self.amount = try container.decode(Double.self, forKey: .amount)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)

        if let holdingTimeString = try container.decodeIfPresent(String.self, forKey: .holdingTime),
           let holdingDate = formatter.date(from: holdingTimeString) {
            self.holdingTime = holdingDate
        } else {
            self.holdingTime = nil
        }

        self.holdingSite = try container.decodeIfPresent(String.self, forKey: .holdingSite)
        self.holdingType = try container.decodeIfPresent(holdingTypeEnum.self, forKey: .holdingType)
    }
}


enum TypeEnum: String, Codable {
    case distributionDate = "distributionDate"
    case dueDate = "dueDate"
    case assembly
    
    
    var title: String {
        switch self {
        case .distributionDate:
            return "Dividend Distribution"
        case .dueDate:
            return "Dividend Entitlment"
        case .assembly:
            return "Assembly Meeting"
        }
    }
    
    var color: Color {
        switch self {
        case .distributionDate:
            return .blue
        case .dueDate:
            return Color("AccentColor")
        case .assembly:
            return .purple
        }
    }
    
    var imageTitle: String {
        switch self {
        case .distributionDate:
            return "creditcard"
        case .dueDate:
            return "calendar"
        case .assembly:
            return "person.3"
        }
    }
    
}

enum holdingTypeEnum: String, Codable {
    case natural
    case unNatural = "UnNatural"
    
    var title: String {
        switch self {
        case .natural:
            return "Normal"
        case .unNatural:
            return "Non Normal"
        }
    }
}
