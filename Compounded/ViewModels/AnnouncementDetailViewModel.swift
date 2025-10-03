//
//  AnnouncementDetailViewModel.swift
//  Compounded
//
//  Created by Lulwah almisfer on 02/10/2025.
//

import SwiftUI
import Combine

@MainActor
class AnnouncementDetailViewModel: ObservableObject {
    @Published var response: AnnouncementResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func fetchAnnouncement(from url: String) {
        guard let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let requestUrl = URL(string: "https://dividens-api-460632706650.me-central1.run.app/api/announcements/scrape?url=\(encodedUrl)") else {
            self.errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        URLSession.shared.dataTaskPublisher(for: requestUrl)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: AnnouncementResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.response = response
            }
            .store(in: &cancellables)
    }
}
