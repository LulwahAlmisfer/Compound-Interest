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

    func fetchDividends() {
        guard let url = URL(string: "https://dividens-api-460632706650.me-central1.run.app/api/dividends/events") else {
            return
        }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoded = try JSONDecoder().decode([Dividends].self, from: data)


                let twoYearsAgo = Calendar.current.date(byAdding: .year, value: -2, to: Date()) ?? .distantPast
                let filteredSorted = decoded
                    .filter { $0.eventDate >= twoYearsAgo }
                    .sorted { $0.eventDate < $1.eventDate }


                await MainActor.run {
                    self.dividends = filteredSorted
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
}
