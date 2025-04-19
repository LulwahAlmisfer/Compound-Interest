//
//  CalendarViewModel.swift
//  Compounded
//
//  Created by Lulwah almisfer on 19/04/2025.
//

import Foundation

@MainActor
class CalendarViewModel: ObservableObject {
    @Published var dividends: [Dividends] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let urlString = "https://dividens-api-460632706650.me-central1.run.app/api/dividends/events"
    
    init() {
        fetchDividends { result in
            switch result {
            case .success(let dividends):
                let twoYearsAgo = Calendar.current.date(byAdding: .year, value: -2, to: Date())!
                    self.dividends = dividends.filter { $0.eventDate >= twoYearsAgo }
            case .failure(let error):
                self.errorMessage = "Failed to load data: \(error.localizedDescription)"
            }
        }
    }

    func fetchDividends(completion: @escaping (Result<[Dividends], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL."
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        isLoading = true
        errorMessage = nil
        
        // Start the background request
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load data: \(error.localizedDescription)"
                    self.isLoading = false
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                DispatchQueue.main.async {
                    self.errorMessage = "Server error."
                    self.isLoading = false
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Server error"])))
                }
                return
            }
            
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            do {
                let decodedDividends = try decoder.decode([Dividends].self, from: data)
                DispatchQueue.main.async {
                    self.dividends = decodedDividends 
                    self.isLoading = false
                    completion(.success(decodedDividends))
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    self.isLoading = false
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
