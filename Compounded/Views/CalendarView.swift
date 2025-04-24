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

                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 24) {
                            
                            if !viewModel.getTodayAnnouncements().isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Today")
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
                            } else {
                                Text("No Announcements for Today")
                                    .padding(30)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Recent Announcements")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal)

                                LazyVStack(spacing: 0) {
                                    ForEach(viewModel.getAllAnnouncements(), id: \.id) { item in
                                        VStack {
                                            HStack {
                                                AsyncCircleCompanyLogoView(ticker: item.symbol, urlString: item.imageUrl)

                                                VStack(alignment: .leading) {
                                                    Group {
                                                        if Helper.isArabic() {
                                                            Text(item.companyName)
                                                        } else {
                                                            Text(item.companyNameEng ?? item.companyName)
                                                        }
                                                    }
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.5)
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
                                            .padding(.horizontal,8)

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
                        .shimmer(viewModel.isLoading ? .loading : .done)
                        .padding(.top)
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
                
                HStack {
                    CompanyAnnouncementTagView(type: item.type)
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
                
                Text(item.eventDate.formatDateInEnglish())
                    .foregroundStyle(.secondary)
                    .font(.caption2)

            }

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
        HStack(spacing: 3){
            Text(.init(type.title))
                .bold()
            Image(systemName: type.imageTitle)
        }
        .font(.system(size: 10))
        .foregroundStyle(.white)
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .padding(6)
        .padding(.horizontal,4)
        .background(
            Capsule()
                .fill(Color(type.color))
        )
        
    }
}
