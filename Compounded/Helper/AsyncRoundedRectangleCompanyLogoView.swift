//
//  AsyncCompanyLogoView.swift
//  Compounded
//
//  Created by Lulwah almisfer on 19/04/2025.
//

import SwiftUI
import Combine

struct AsyncRoundedRectangleCompanyLogoView: View {
    @StateObject private var loader = ImageLoader()

    var ticker: String
    var urlString: String

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if loader.hasFailed {
                placeHolderView
            } else {
                ProgressView()
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.25)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            if let url = URL(string: urlString) {
                loader.loadImage(from: url)
            }
        }
        .onDisappear { loader.cancel() }
    }

    var placeHolderView: some View {
        Group {
            if UIImage(named: ticker) != nil {
                Image(ticker)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.25)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ZStack {
                   RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: UIScreen.main.bounds.width * 0.25)

                    Text(ticker)
                        .bold()
                        .foregroundColor(.white)
                        .font(.title2)
                }
            }
        }
    }
}

struct AsyncCircleCompanyLogoView: View {
    @StateObject private var loader = ImageLoader()

    var ticker: String
    var urlString: String

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if loader.hasFailed {
                placeHolderView
            } else {
                ProgressView()
            }
        }
        .frame(width: 30, height: 30)
        .clipShape(.circle)
        .onAppear {
            if let url = URL(string: urlString) {
                loader.loadImage(from: url)
            }
        }
        .onDisappear { loader.cancel() }
    }

    var placeHolderView: some View {
        Group {
            if UIImage(named: ticker) != nil {
                Image(ticker)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(.circle)
            } else {
                ZStack {
                   Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 30, height: 30)

                    Text(ticker)
                        .bold()
                        .foregroundColor(.white)
                        .font(.caption2)
                        .minimumScaleFactor(0.5)
                }
            }
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var hasFailed = false
    private var url: URL?
    private var cancellable: AnyCancellable?

    func loadImage(from url: URL) {
        guard self.url != url, image == nil else { return }

        self.url = url
        self.hasFailed = false

        if let cachedImage = ImageCache.shared.object(forKey: url as NSURL) {
            self.image = cachedImage
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                if let image = image {
                    ImageCache.shared.setObject(image, forKey: url as NSURL)
                    self?.image = image
                } else {
                    self?.hasFailed = true
                }
            }
    }

    func cancel() {
        cancellable?.cancel()
    }
}

class ImageCache {
    static let shared = NSCache<NSURL, UIImage>()
}
