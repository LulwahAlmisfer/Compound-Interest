//
//  ToastView.swift
//  Compounded
//
//  Created by Lulwah almisfer on 20/09/2025.
//


import SwiftUI

struct ToastView: View {
    let message: String
    let success: Bool
    
    var body: some View {
        Text(message)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(success ? Color.green : Color.red)
            .clipShape(Capsule())
            .shadow(radius: 4)
            .padding(.bottom, 32)
    }
}


extension View {
    func toast(message: String,
               isSuccess: Bool,
               isPresented: Binding<Bool>,
               duration: TimeInterval = 2.0) -> some View {
        self.overlay(
            Group {
                if isPresented.wrappedValue {
                    VStack {
                        Spacer()
                        ToastView(message: message, success: isSuccess)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                    withAnimation {
                                        isPresented.wrappedValue = false
                                    }
                                }
                            }
                    }
                    .padding(.bottom, 40)
                }
            }
        )
        .animation(.easeInOut, value: isPresented.wrappedValue)
    }
}

