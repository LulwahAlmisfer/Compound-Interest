//
//  Shimmer.swift
//  Compounded
//
//  Created by Lulwah almisfer on 24/04/2025.

import SwiftUI

private struct Shimmer: ViewModifier {
    static let defaultColors: [Color] = [.black.opacity(0.4), .black, .black.opacity(0.4)]
    @State private var isInitialState = true
    let colors: [Color]
    let viewState: ViewState
    
    public func body(content: Content) -> some View {
        contentView(content: content)
    }
    
    @ViewBuilder
    func contentView(content: Content) -> some View {
        switch viewState {
        case .loading:
            content
                .mask(maskView)
                .redacted(reason: .placeholder)
                .onAppear {
                    isInitialState = false
                }
        case .failed, .empty:
            content
                .redacted(reason: .placeholder)
                .onAppear {
                    isInitialState = true
                }
        default:
            content
                .onAppear {
                    isInitialState = true
                }
        }
    }
    
    var maskView: some View {
        LinearGradient(
            gradient: .init(colors: colors),
            startPoint: (isInitialState ? .init(x: -0.3, y: -0.3) : .init(x: 1, y: 1)),
            endPoint: (isInitialState ? .init(x: 0, y: 0) : .init(x: 1.3, y: 1.3))
        )
        .animation(.linear(duration: 1).delay(0.25).repeatForever(autoreverses: false), value: isInitialState)
    }
}

extension View {
    
    @ViewBuilder
    func shimmer(_ viewState: ViewState,
                 colors: [Color] = Shimmer.defaultColors) -> some View {
        self.modifier(Shimmer(colors: colors, viewState: viewState))
    }
}

enum ViewState: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none): return true
        case (.done, .done): return true
        case (.loading, .loading): return true
        case (.empty, .empty): return true
        case (.failed, .failed): return true
        default: return false
        }
    }
    case none
    case done
    case loading
    case empty
    case failed(_ failureMessage: FailureMessage? = nil, error: Error? = nil)
    
    func isViewState(_ viewState: ViewState) -> Bool {
        self == viewState
    }
}

extension ViewState {
    
    struct FailureMessage {
        let title: String?
        let message: String?
        let icon: Image?
        let retryAction: (() -> Void)?
        
        init(title: String? = nil,
             message: String? = nil,
             icon: Image? = nil,
             retryAction: (() -> Void)? = nil) {
            self.title = title
            self.message = message
            self.icon = icon
            self.retryAction = retryAction
        }
    }
    
}
