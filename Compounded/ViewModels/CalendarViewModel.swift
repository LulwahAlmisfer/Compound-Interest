////
////  CalendarViewModel.swift
////  Compounded
////
////  Created by Lulwah almisfer on 19/04/2025.
////
//
import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var dividends: [Dividends] = []
    @Published var mockDividends: [Dividends] = []
    @Published var isLoading = true
    @Published var filter: TypeEnum? = nil
    init() {
        getMockFromJson()
        fetchDividends()
    }
    
    func getTodayAnnouncements() -> [Dividends] {
        return isLoading ? mockDividends : dividends.filter { $0.eventDate.isToday }
    }
    
    func getAllAnnouncements() -> [Dividends] {
        return isLoading ? mockDividends : dividends
    }
    
    func getUpcomingAnnouncements() -> [Dividends] {
        return applyFilter(on: getAllAnnouncements()
            .filter { $0.eventDate >= .now }
            .sorted { $0.eventDate < $1.eventDate }
        )
    }

    func getPastAnnouncements() -> [Dividends] {
        return applyFilter(on: getAllAnnouncements()
            .filter { $0.eventDate < .now }
        )
    }
    
    private func applyFilter(on list: [Dividends]) -> [Dividends] {
        guard let selectedType = filter else {
            return list
        }
        return list.filter { $0.type == selectedType }
    }
    
    
    func fetchDividends() {
        self.isLoading = true
        
        guard let url = URL(string: "https://dividens-api-460632706650.me-central1.run.app/api/dividends/events") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Fetch error: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode([Dividends].self, from: data)
                
                withAnimation {
                    DispatchQueue.main.async {
                        self.dividends = decoded
                        self.getEngNamesFromJson()
                        self.isLoading = false
                    }
                }
                
                
            } catch {
                print("Decoding error: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }.resume()
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
            
            DispatchQueue.main.async {
                for i in self.dividends.indices {
                    if let engName = symbolToNameMap[self.dividends[i].symbol] {
                        self.dividends[i].companyNameEng = engName.removeCo()
                    }
                }
            }
        } catch {
            print("Error parsing symbols_and_titles_en.json: \(error)")
        }
    }
    
    func getMockFromJson() {
        guard let url = Bundle.main.url(forResource: "CompoundedMockResponse", withExtension: "json") else {
            print("Mock JSON file not found.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            var decoded = try JSONDecoder().decode([Dividends].self, from: data)
            
            
            if !decoded.isEmpty {
                decoded[0].eventDate = .now
            }
            
            DispatchQueue.main.async {
                self.mockDividends = decoded
            }
        } catch {
            print("Error parsing mock JSON: \(error)")
        }
        
    }
}
