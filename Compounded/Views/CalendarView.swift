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
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            
                            if !viewModel.getTodayAnnouncements().isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Today's Announcements")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .padding(.horizontal)

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 16) {
                                            ForEach(viewModel.getTodayAnnouncements()) { announcement in
                                                CompanyAnnouncementCardView(item: announcement)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Recent Announcements")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal)

                                LazyVStack(spacing: 0) {
                                    ForEach(viewModel.dividends, id: \.id) { item in
                                        VStack {
                                            HStack {
                                                AsyncCircleCompanyLogoView(ticker: item.symbol, urlString: item.imageUrl)

                                                VStack(alignment: .leading) {
                                                    Text(item.companyName)
                                                        .font(.headline)
                                                    Text(item.eventDate.formatDateInEnglish())
                                                        .font(.caption)
                                                        .foregroundColor(.gray)
                                                }

                                                Spacer()

                                                VStack(alignment:.trailing) {
                                                    CompanyAnnouncementTagView(type: item.type)
                                                    HStack {
                                                        Text(item.amount.rounded(to: 2))
                                                        Image("sar")
                                                            .resizable()
                                                            .renderingMode(.template)
                                                            .foregroundStyle(Color("AccentColor"))
                                                            .frame(width: 15,height: 15)
                                                    }
                                                    .font(.system(size: 10))
                                                }

                                            }
                                            .padding(6)
                                            .padding(.horizontal,4)

                                            Divider()
                                                .padding(.leading,40)
                                            
                                        }
                                        .padding(.vertical,2)
                                        .background(Color(.systemGray6))
                                    }
                                }
                                .background(Color(.systemGroupedBackground))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    }
                }
            }
            .navigationTitle("Calendar")
        }
    }
}


struct CompanyAnnouncementCardView: View {

    var item: Dividends

    var body: some View {
        HStack(alignment: .top,spacing: 12) {
            AsyncRoundedRectangleCompanyLogoView(ticker: item.symbol, urlString: item.imageUrl)

            VStack(alignment: .leading, spacing: 6) {
                CompanyAnnouncementTagView(type: item.type)

                Group {
                    if Helper.isArabic() {
                        Text(item.companyName)
                    } else {
                        Text(item.companyNameEng ?? item.companyName)
                    }
                }
                .font(.subheadline)
                .bold()
                
                Text(item.eventDate.formatDateInEnglish())
                    .foregroundStyle(.secondary)
                    .font(.caption2)

            }
            
            Spacer()
                        
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
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
        .shadow(radius: 2)
    }
}

struct CompanyAnnouncementTagView: View {
    var type :TypeEnum
    
    var body: some View {
        HStack {
            Text(.init(type.title))
                .bold()
            Image(systemName: type.imageTitle)
        }
        .font(.system(size: 10))
        .foregroundStyle(.white)
        .lineLimit(1)
        .padding(6)
        .background(
            Capsule()
                .fill(Color(type.color))
        )
        
    }
}
