//
//  DividendDetailView.swift
//  Compounded
//
//  Created by Lulwah almisfer on 03/10/2025.
//


import SwiftUI

struct DividendDetailView: View {
    let dividend: Dividends
    
    var body: some View {
        List {

            Section("Company") {
                HStack(spacing: 12) {
                    AsyncImage(url: URL(string: dividend.imageUrl)) { phase in
                        if let image = phase.image {
                            image.resizable().scaledToFit()
                        } else if phase.error != nil {
                            Image(systemName: "building.2.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    VStack(alignment: .leading) {
                        Text((Helper.isArabic() ? dividend.companyName : dividend.companyNameEng) ?? dividend.companyName)
                            .font(.headline)
                        
                    }
                }
            }
            
            Section("Information") {
                HStack {
                    Text("Amount")
                    Spacer()
                    Text("\(dividend.amount.rounded(to: 2)) SAR")
                        .foregroundColor(.primary)
                }
                
                HStack {
                    Text("Date")
                    Spacer()
                    Text(dividend.eventDate.formatted(date: .abbreviated, time: .omitted))
                }
            }
            

            if dividend.holdingTime != nil || dividend.holdingSite != nil || dividend.holdingType != nil {
                Section("Holding") {
                    if let holdingTime = dividend.holdingTime {
                        HStack {
                            Text("Holding Time")
                            Spacer()
                            Text(holdingTime.formatted(date: .abbreviated, time: .shortened))
                        }
                    }
                    
                    if let holdingSite = dividend.holdingSite {
                        HStack {
                            Text("Site")
                            Spacer()
                            Text(holdingSite)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Announcement")
        .navigationBarTitleDisplayMode(.inline)
    }
}
