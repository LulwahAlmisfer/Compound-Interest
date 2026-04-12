//
//  WatchlistViewModel.swift
//  Compounded
//
//  Created by Lulwah almisfer on 12/04/2026.
//

import Foundation
import SwiftUI

@MainActor
class WatchlistViewModel: ObservableObject {
    @Published var dividends: [Dividends] = []
    @Published var isLoading = false

    func fetchDividends() {
        isLoading = true
        guard let url = URL(string: "https://dividens-api-460632706650.me-central1.run.app/api/dividends/events") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let decoded = try? JSONDecoder().decode([Dividends].self, from: data) else {
                DispatchQueue.main.async { self.isLoading = false }
                return
            }
            DispatchQueue.main.async {
                self.dividends = decoded
                self.loadEngNames()
                self.isLoading = false
            }
        }.resume()
    }

    private func loadEngNames() {
        guard let url = Bundle.main.url(forResource: "symbols_and_titles_en", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(StockInfoContainer.self, from: data) else { return }

        let map = Dictionary(uniqueKeysWithValues: decoded.stocks.map { ($0.symbol, $0.title_en) })
        for i in dividends.indices {
            if let name = map[dividends[i].symbol] {
                dividends[i].companyNameEng = name.removeCo()
            }
        }
    }

    func upcomingEvents(for symbols: [String]) -> [Dividends] {
        dividends
            .filter { symbols.contains($0.symbol) && $0.eventDate >= Calendar.current.startOfDay(for: .now) }
            .sorted { $0.eventDate < $1.eventDate }
    }

    func imageUrl(for symbol: String) -> String {
        dividends.first(where: { $0.symbol == symbol })?.imageUrl ?? ""
    }
}
