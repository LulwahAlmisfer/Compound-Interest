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
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteCompany]
    @StateObject private var viewModel = CalendarViewModel()
    @State private var isUpcomingExpanded = true
    @State private var isPastExpanded = false
    
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastSuccess = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    notificationView
                    
                    Group {
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
                            StyledDisclosureGroup("Upcoming", isExpanded: $isUpcomingExpanded) {
                                LazyVStack(spacing: 0) {
                                    ForEach(viewModel.getUpcomingAnnouncements(), id: \.id) { item in
                                        if let url = item.annurl {
                                            NavigationLink(destination: {
                                               AnnouncementDetailView(url: url)
                                            }, label: {
                                              announcementRow(item: item)
                                            })

                                        } else {
                                            announcementRow(item: item)
                                        }
                                    }
                                }
                            }
                            
                            StyledDisclosureGroup("Past", isExpanded: $isPastExpanded) {
                                LazyVStack(spacing: 0) {
                                    ForEach(viewModel.getPastAnnouncements(), id: \.id) { item in
                                        announcementRow(item: item)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .tint(.white)
                    }
                    .shimmer(viewModel.isLoading ? .loading : .done)
                }
            }
            .navigationTitle("Calendar")
            .overlay(alignment: .bottom) {
                if showToast {
                    ToastView(message: toastMessage, success: toastSuccess)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation { showToast = false }
                            }
                        }
                }
            }
        }
        .refreshable { viewModel.fetchDividends() }
    }
    
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
            
            Divider().padding(.leading, 40)
        }
        .background(Color(.systemGray6))
        .contextMenu {
            Button("Add to Calendar") {
                CalendarManager().addEvent(for: item) { success, _ in
                    withAnimation {
                        toastMessage = success ? "Event added 🎉" : "Failed to add event"
                        toastSuccess = success
                        showToast = true
                    }
                }
            }
            
            Button("Add Notification") {
                Task {
                    do {
                        guard let token = pushManager.deviceToken else {
                            withAnimation {
                                toastMessage = "❌ No device token available."
                                toastSuccess = false
                                showToast = true
                            }
                            return
                        }
                        try await pushManager.subscribeToCompany(
                            deviceToken: token,
                            companySymbol: item.symbol
                        )
                        
                        let favorite = FavoriteCompany(
                            id: item.symbol,
                            nameAr: item.companyName,
                            nameEn: item.companyNameEng ?? item.companyName
                        )
                        modelContext.insert(favorite)
                        try modelContext.save()
                        
                        withAnimation {
                            toastMessage = "✅ Subscribed to \(item.companyName)"
                            toastSuccess = true
                            showToast = true
                        }
                    } catch {
                        withAnimation {
                            toastMessage = "❌ Failed to subscribe"
                            toastSuccess = false
                            showToast = true
                        }
                    }
                }
            }
        }
    }
    
    var notificationView: some View {
        Group {
            switch pushManager.state {
            case .notDetermined:

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
                                .contextMenu{
                                    Button("Unsubscribe"){
                                        Task {
                                            do {
                                                guard let token = pushManager.deviceToken else {
                                                    withAnimation {
                                                        toastMessage = "❌ No device token available."
                                                        toastSuccess = false
                                                        showToast = true
                                                    }
                                                    return
                                                }
                                                
                                                try await pushManager.unSubscribeCompany(
                                                    deviceToken: token,
                                                    companySymbol: fav.id
                                                )
                                                
                                                modelContext.delete(fav)
                                                try modelContext.save()
                                                
                                                withAnimation {
                                                    toastMessage = "✅ unSubscribed"
                                                    toastSuccess = true
                                                    showToast = true
                                                }
                                                
                                            } catch {
                                                withAnimation {
                                                    toastMessage = "❌ Failed to Unsubscribe"
                                                    toastSuccess = false
                                                    showToast = true
                                                }
                                            }
                                        }
                                    }
                                }
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
        .onAppear { pushManager.configure() }
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
    
}


#Preview {
    CompoundedTabView()
}
