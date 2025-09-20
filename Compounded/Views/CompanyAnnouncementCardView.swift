//
//  CompanyAnnouncementCardView.swift
//  Compounded
//
//  Created by Lulwah almisfer on 20/09/2025.
//

import SwiftUI

struct CompanyAnnouncementCardView: View {
    
    var item: Dividends
    
    var body: some View {
        HStack(alignment: .top,spacing: 12) {
            AsyncRoundedRectangleCompanyLogoView(ticker: item.symbol, urlString: item.imageUrl)
            
            VStack(alignment: .leading, spacing: 6) {
                
                HStack {
                    CompanyAnnouncementTagView(type: item.type)
                    Spacer()
                    if item.type != .assembly {
                        HStack {
                            Text(item.amount.rounded(to: 2))
                            Image("sar")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(Color("AccentColor"))
                                .frame(width: 15,height: 15)
                        }
                        .font(.system(size: 12))
                    }
                }
                
                Group {
                    if Helper.isArabic() {
                        Text(item.companyName)
                    } else {
                        Text(item.companyNameEng ?? item.companyName)
                    }
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .font(.subheadline)
                .bold()
                
                HStack {
                    Text(item.eventDate.formatDateInEnglish())
                        .foregroundStyle(.secondary)
                    
                    if let type = item.holdingType {
                        Text(.init(type.title))
                            .foregroundStyle(.purple)
                    }
                }
                .font(.caption2)
            }
            
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}
