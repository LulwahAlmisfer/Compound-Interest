//
//  CompoundedApp.swift
//  Compounded
//
//  Created by Lulu Khalid on 24/07/2021.
//

import SwiftUI

@main
struct CompoundedApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        PushManager.shared.configure()
    }

    var body: some Scene {
        WindowGroup {
            CompoundedTabView()
                .onAppear{ PickerStyle() }
        }
        .modelContainer(for: [FavoriteCompany.self])
    }
}
