////
////  CalendarViewModel.swift
////  Compounded
////
////  Created by Lulwah almisfer on 19/04/2025.
////
//
import Foundation

class CalendarViewModel: ObservableObject {
    @Published var dividends: [Dividends] = []
    @Published var isLoading = true

    init() {
        fetchDividends()
    }
    
    func getTodayAnnouncements() -> [Dividends] {
        dividends.filter { $0.eventDate.isToday }
    }

    func fetchDividends() {
        guard let url = URL(string: "https://dividens-api-460632706650.me-central1.run.app/api/dividends/events") else {
            return
        }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decodedDividends = try JSONDecoder().decode([Dividends].self, from: data)

                await MainActor.run {
                    self.dividends = decodedDividends
                    self.getEngNamesFromJson()
                    self.isLoading = false
                }
            } catch {
                print("Error: \(error)")
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    func getEngNamesFromJson() {
        guard let url = Bundle.main.url(forResource: "symbols_and_titles_en", withExtension: "json") else {
            print("JSON file not found.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(StockInfoContainer.self, from: data)
            
            let symbolToNameMap = Dictionary(uniqueKeysWithValues: decoded.stocks.map { ($0.symbol, $0.title_en) })

            for i in dividends.indices {
                if let engName = symbolToNameMap[dividends[i].symbol] {
                    dividends[i].companyNameEng = engName.removeCo()
                }
            }
        } catch {
            print("Error loading or parsing JSON: \(error)")
        }
    }
    
}
