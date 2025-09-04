//
//  CompoundedTabView.swift
//  Compounded
//
//  Created by Lulwah almisfer on 18/04/2025.
//

import Foundation
import SwiftUI

struct CompoundedTabView: View {
    var body: some View {
        TabView {
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
            CompoundInterestView()
                .tabItem {
                    Label("Calculator", systemImage: "chart.bar.fill")
                }

          

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    CompoundedTabView()
}
