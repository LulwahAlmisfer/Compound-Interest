//
//  CalendarView.swift
//  Compounded
//
//  Created by Lulwah almisfer on 19/04/2025.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()

    var body: some View {
        Group {
            
            //TODO: shimmer and UI
            if viewModel.isLoading {
                ProgressView()
            } else {
                List {
                    LazyVStack(alignment: .leading) {
                        ForEach(viewModel.dividends, id: \.id) { item in
                            HStack {
                             //   AsyncCompanyLogoView(ticker: item.symbol, urlString:stock.logo)

                                Text(item.companyName)
                                Text(item.eventDate.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                Text(item.type.title)
                                    .lineLimit(1)
                                    .foregroundStyle(item.type.color)
                                    .padding(6)
                                    .background(item.type.color.opacity(0.2))
                                    .clipShape(.capsule)
                            }
                        }
                    }
                }
            }
        }
    }
}
