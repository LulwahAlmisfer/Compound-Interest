//
//  AppDelegate.swift
//  Compounded
//
//  Created by Lulwah almisfer on 04/09/2025.
//

import SwiftUI
import UserNotifications

final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // Device token from APNs
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02x", $0) }.joined()
        PushManager.shared.updateDeviceToken(token)
        print("APNs token: \(token)")
        
        
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed:", error)
    }

    // Show notifications while app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound, .badge])
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        PushManager.shared.configure()
    }
}

import UIKit
import UserNotifications

enum PushAuthState {
    case notDetermined, denied, authorized
}

final class PushManager: NSObject, ObservableObject {
    static let shared = PushManager()

    @Published private(set) var state: PushAuthState = .notDetermined
    @Published private(set) var deviceToken: String? {
        didSet { UserDefaults.standard.set(deviceToken, forKey: "apns_token") }
    }

    func configure() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined: self.state = .notDetermined
                case .denied:        self.state = .denied
                default:             self.state = .authorized
                }
                
                if self.state == .authorized {
                    UIApplication.shared.registerForRemoteNotifications()
                    return
                }
                
                self.registerForPushNotifications()
            }
        }
        

        if let t = UserDefaults.standard.string(forKey: "apns_token") {
            deviceToken = t
        }
    }
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                print("Permission granted: \(granted)")
                guard granted else { return }
                
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
    }
 
    func updateDeviceToken(_ token: String) {
        DispatchQueue.main.async { self.deviceToken = token }
    }

    /// Call this right before you subscribe a company.
    /// If permission is granted, it registers for remote notifications and returns the token (when available).
    func ensurePermissionAndRegister(completion: @escaping (Result<String, Error>) -> Void) {
        // If already authorized and we have a token, return it.
        if state == .authorized, let token = deviceToken {
            completion(.success(token)); return
        }

        // Ask for permission (only once)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if let error { completion(.failure(error)); return }
                guard granted else {
                    self.state = .denied
                    completion(.failure(NSError(domain: "Push", code: 1, userInfo: [NSLocalizedDescriptionKey: "Notifications denied"])))
                    return
                }
                self.state = .authorized
                // Ask APNs for a device token
                UIApplication.shared.registerForRemoteNotifications()

                // Poll briefly for the token (simple/robust enough for first setup)
                self.waitForToken(maxWait: 3.0) { token in
                    if let token { completion(.success(token)) }
                    else {
                        completion(.failure(NSError(domain: "Push", code: 2, userInfo: [NSLocalizedDescriptionKey: "No device token yet"])))
                    }
                }
            }
        }
    }

    private func waitForToken(maxWait: TimeInterval, completion: @escaping (String?) -> Void) {
        // simple retry loop for initial registration
        let deadline = Date().addingTimeInterval(maxWait)
        func tick() {
            if let t = self.deviceToken { completion(t); return }
            if Date() > deadline { completion(nil); return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: tick)
        }
        tick()
    }

    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
    
    func subscribeToCompany(deviceToken: String, companySymbol: String) async throws {
        guard let url = URL(string: "https://dividens-api-460632706650.me-central1.run.app/api/subscriptions") else { return }
//        guard let url = URL(string: "http://localhost:8080/api/subscriptions") else { return }
        
        let request = SubscriptionRequest(deviceToken: deviceToken, companySymbol: companySymbol)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        print(response)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
    
    public func unSubscribeCompany(deviceToken: String, companySymbol: String) async throws {
        guard let url = URL(string: "https://dividens-api-460632706650.me-central1.run.app/api/subscriptions/unSubscribe") else { return }
        
        let request = SubscriptionRequest(deviceToken: deviceToken, companySymbol: companySymbol)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        print(response)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }

}
