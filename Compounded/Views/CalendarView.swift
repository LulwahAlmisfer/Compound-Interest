//
//  CalendarView.swift
//  Compounded
//
//  Created by Lulwah almisfer on 19/04/2025.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @ObservedObject private var pushManager = PushManager.shared
    @Query private var favorites: [FavoriteCompany]
    @StateObject private var viewModel = CalendarViewModel()
    @State private var isUpcomingExpanded = true
    @State private var isPastExpanded = true
    
    var body: some View {
        NavigationView {
            Group {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 24) {
                            
                            notificationView
                            
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

                            HStack {
                                Text("Recent Announcements")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal)
                                
                                Spacer()
                                
                                picker
                                
                            }
                            LazyVStack(spacing: 12) {
                                // Upcoming Announcements
                                DisclosureGroup("Upcoming", isExpanded: $isUpcomingExpanded) {
                                    LazyVStack(spacing: 0) {
                                        ForEach(viewModel.getUpcomingAnnouncements(), id: \.id) { item in
                                            announcementRow(item: item)
                                        }
                                    }
                                    .background(Color(.systemGroupedBackground))
                                    .cornerRadius(12)
                                }
                                .foregroundStyle(.primary)
                                .tint(.primary)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .animation(.easeInOut(duration: 0.5), value: isUpcomingExpanded)

                                // Past Announcements
                                DisclosureGroup("Past", isExpanded: $isPastExpanded) {
                                    LazyVStack(spacing: 0) {
                                        ForEach(viewModel.getPastAnnouncements(), id: \.id) { item in
                                            announcementRow(item: item)
                                        }
                                    }
                                    .background(Color(.systemGroupedBackground))
                                    .cornerRadius(12)
                                }
                                .foregroundStyle(.primary)
                                .tint(.primary)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .animation(.easeInOut(duration: 0.5), value: isPastExpanded)
                            }
                            .tint(.white)
                                .padding(.horizontal)
                            }                        }
                        .shimmer(viewModel.isLoading ? .loading : .done)
                    }
                    .navigationTitle("Calendar")

            }
        
    }
    
    @ViewBuilder
    private func announcementRow(item: Dividends) -> some View {
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

                Spacer()

                VStack(alignment: .trailing) {
                    CompanyAnnouncementTagView(type: item.type)
                    
                    if item.type != .assembly {
                        HStack {
                            Text(item.amount.rounded(to: 2))
                            Image("sar")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(Color("AccentColor"))
                                .frame(width: 15, height: 15)
                        }
                        .font(.system(size: 10))
                    }
                }
            }
            .padding(4)

            Divider()
                .padding(.leading, 40)
        }
        .background(Color(.systemGray6))
        .contextMenu {
            Button("Add to Calendar") {
                CalendarManager().addEvent(for: item) { success, error in
                    if success {
                        print("Event added 🎉")
                    }
                }
            }
        }
    }
    
    
    var picker: some View {
        Menu {
            Button {
                withAnimation {
                    DispatchQueue.main.async { viewModel.filter = nil }
                }
            } label: {
                Text(LocalizedStringKey("All"))
            }
            
            ForEach(TypeEnum.allCases, id: \.self) { type in
                Button {
                    withAnimation {
                        DispatchQueue.main.async { viewModel.filter = type }
                    }

                } label: {
                    Label(LocalizedStringKey(type.title), systemImage: type.imageTitle)
                }
            }
        } label: {
            if let filter = viewModel.filter {
                Image(systemName: filter.imageTitle)
                    .font(.headline)
                    .padding()
            } else {
                Image(systemName:"slider.horizontal.3")
                    .font(.headline)
                    .padding()
            }
        }
        .foregroundStyle(.primary)
    }

    var notificationView: some View {
        Group {
            switch pushManager.state {
            case .notDetermined:
                // ⏳ Not asked yet
                VStack(spacing: 16) {
                    Button {
                        pushManager.registerForPushNotifications()
                    } label: {
                        Label("Allow Notifications", systemImage: "bell.badge.fill")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                    }
                }
                .padding(.horizontal)

            case .denied:
                // ❌ Denied by user
                VStack(spacing: 16) {
                    Button {
                        pushManager.openSettings()
                    } label: {
                        Label("Enable Notifications in Settings", systemImage: "gear")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                    }
                }
                .padding(.horizontal)

            case .authorized:
                // ✅ Authorized → show your favorites logic
                if favorites.isEmpty {
                    VStack(spacing: 16) {
                        NavigationLink(destination: CompanyPickerView()) {
                            Label("Add Notification", systemImage: "bell.badge.fill")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(Color.accentColor.opacity(0.7), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(favorites) { fav in
                                HStack {
                                    Image(systemName: "bell.badge.fill")
                                        .foregroundColor(.accentColor)
                                    Text(Helper.isArabic() ? fav.nameAr : fav.nameEn)
                                }
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.systemGray6))
                                )
                            }
                            
                            NavigationLink(destination: CompanyPickerView()) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            pushManager.configure()
        }
        .onAppear {
            pushManager.configure()
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

struct CompanyAnnouncementTagView: View {
    var type :TypeEnum
    
    var body: some View {
        HStack(spacing: 3){
            Text(.init(type.title))
                .bold()
            Image(systemName: type.imageTitle)
        }
        .font(.system(size: 12))
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

#Preview {
    CompoundedTabView()
}
