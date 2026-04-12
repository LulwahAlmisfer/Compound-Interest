//
//  WatchlistView.swift
//  Compounded
//
//  Created by Lulwah almisfer on 12/04/2026.
//

import SwiftUI
import SwiftData

struct WatchlistView: View {
    @Query private var favorites: [FavoriteCompany]
    @Environment(\.modelContext) private var modelContext
    @ObservedObject private var pushManager = PushManager.shared
    @StateObject private var viewModel = WatchlistViewModel()

    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastSuccess = true

    private var favoriteSymbols: [String] { favorites.map { $0.id } }
    private var upcomingEvents: [Dividends] { viewModel.upcomingEvents(for: favoriteSymbols) }

    var body: some View {
        NavigationView {
            Group {
                if favorites.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            companiesStrip
                            eventsSection
                        }
                        .padding(.top)
                        .padding(.bottom, 32)
                    }
                    .shimmer(viewModel.isLoading ? .loading : .done)
                    .refreshable { viewModel.fetchDividends() }
                }
            }
            .navigationTitle("Watchlist")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: CompanyPickerView()) {
                        Image(systemName: "plus")
                    }
                }
            }
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
            .task {
                guard viewModel.dividends.isEmpty else { return }
                viewModel.fetchDividends()
            }
        }
    }

    // MARK: - Companies strip

    private var companiesStrip: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Companies")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(favorites) { fav in
                        WatchlistCompanyChip(
                            fav: fav,
                            imageUrl: viewModel.imageUrl(for: fav.id),
                            nextEvent: upcomingEvents.first(where: { $0.symbol == fav.id })
                        )
                        .contextMenu {
                            Button(role: .destructive) {
                                unsubscribe(fav)
                            } label: {
                                Label("Unsubscribe", systemImage: "bell.slash")
                            }
                        }
                    }

                    NavigationLink(destination: CompanyPickerView()) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                                .foregroundColor(.accentColor)
                            Text("Add")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: - Events section

    private var eventsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Upcoming Events")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)

            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
            } else if upcomingEvents.isEmpty {
                Text("No upcoming events for your companies.")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 30)
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(Array(upcomingEvents.enumerated()), id: \.element.id) { index, item in
                        eventLink(item: item)
                        if index < upcomingEvents.count - 1 {
                            Divider().padding(.leading, 50)
                        }
                    }
                }
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                .tint(.white)
            }
        }
    }

    @ViewBuilder
    private func eventLink(item: Dividends) -> some View {
        if let url = item.annurl {
            NavigationLink(destination: AnnouncementDetailView(url: url)) {
                eventRow(item: item)
            }
        } else {
            NavigationLink(destination: DividendDetailView(dividend: item)) {
                eventRow(item: item)
            }
        }
    }

    // MARK: - Event row

    private func eventRow(item: Dividends) -> some View {
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
        .padding(8)
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "star.slash")
                .font(.system(size: 52))
                .foregroundStyle(.secondary)

            Text("No companies yet")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Subscribe to companies to track their upcoming dividend events here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            NavigationLink(destination: CompanyPickerView()) {
                Label("Add Company", systemImage: "plus.circle.fill")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Unsubscribe

    private func unsubscribe(_ fav: FavoriteCompany) {
        Task {
            do {
                guard let token = pushManager.deviceToken else { return }
                try await pushManager.unSubscribeCompany(deviceToken: token, companySymbol: fav.id)
                modelContext.delete(fav)
                try modelContext.save()
                withAnimation {
                    toastMessage = "✅ Unsubscribed"
                    toastSuccess = true
                    showToast = true
                }
            } catch {
                withAnimation {
                    toastMessage = "❌ Failed to unsubscribe"
                    toastSuccess = false
                    showToast = true
                }
            }
        }
    }
}

// MARK: - Company chip

struct WatchlistCompanyChip: View {
    let fav: FavoriteCompany
    let imageUrl: String
    let nextEvent: Dividends?

    var body: some View {
        HStack(spacing: 10) {
            AsyncCircleCompanyLogoView(ticker: fav.id, urlString: imageUrl)

            VStack(alignment: .leading, spacing: 2) {
                Text(Helper.isArabic() ? fav.nameAr : fav.nameEn)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)

                if let event = nextEvent {
                    Text(event.eventDate.formatDateInEnglish())
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                } else {
                    Text("No events")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

#Preview {
    WatchlistView()
}
