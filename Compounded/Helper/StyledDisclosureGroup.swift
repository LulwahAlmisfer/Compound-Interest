//
//  StyledDisclosureGroup.swift
//  Compounded
//
//  Created by Lulwah almisfer on 20/09/2025.
//


import SwiftUI

struct StyledDisclosureGroup<Content: View>: View {
    let title: String
    @Binding var isExpanded: Bool
    let content: () -> Content

    init(_ title: String,
         isExpanded: Binding<Bool>,
         @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self._isExpanded = isExpanded
        self.content = content
    }

    var body: some View {
        DisclosureGroup(title, isExpanded: $isExpanded) {
            content()
                .background(Color(.systemGroupedBackground))
                .cornerRadius(12)
        }
        .foregroundStyle(.primary)
        .tint(.primary)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .animation(.easeInOut(duration: 0.5), value: isExpanded)
    }
}
