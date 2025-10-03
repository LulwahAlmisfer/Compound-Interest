//
//  AnnouncementDetailView.swift
//  Compounded
//
//  Created by Lulwah almisfer on 02/10/2025.
//
import SwiftUI

struct AnnouncementDetailView: View {
    let url: String
    @StateObject private var viewModel = AnnouncementDetailViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else if let announcement = viewModel.response?.announcement {
                List {
                    
                    if let introduction = announcement.introduction, !introduction.isEmpty {
                        Section("Introduction") {
                            Text(introduction)
                        }
                    }
                    
                    if let agenda = announcement.agenda, !agenda.isEmpty {
                        Section("Agenda") {
                            Text(agenda)
                        }
                    }
                    
                    if let attachedFiles = announcement.attachedFiles, !attachedFiles.isEmpty {
                        Section("Attached Files") {
                            AnnouncementFilesView(attachedFiles: attachedFiles)
                        }
                    }
                    
                    if let meetingDate = announcement.meetingDate,
                       let meetingTime = announcement.meetingTime,
                       let meetingLocation = announcement.meetingLocation,
                       let meetingMethod = announcement.meetingMethod {
                        Section("Meeting Info") {
                            if !meetingDate.isEmpty { Text("Date: \(meetingDate)") }
                            if !meetingTime.isEmpty { Text("Time: \(meetingTime)") }
                            if !meetingLocation.isEmpty { Text("Location: \(meetingLocation)") }
                            if !meetingMethod.isEmpty { Text("Method: \(meetingMethod)") }
                        }
                    }
                    
                    
                    if let shareholderRights = announcement.shareholderRights, !shareholderRights.isEmpty {
                        Section("Shareholder Rights") {
                            Text(shareholderRights)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            } else {
                Text("No announcement found")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Announcement")
        .onAppear { viewModel.fetchAnnouncement(from: url) }
    }
}

struct AnnouncementFilesView: View {
    let attachedFiles: [String]?
    
    @State private var selectedURL: IdentifiableURL?
    
    var body: some View {
        VStack(spacing: 0) {
            if let files = attachedFiles, !files.isEmpty {
                ForEach(Array(files.enumerated()), id: \.element) { index, file in
                    if let url = URL(string: file) {
                        VStack(spacing: 0) {
                            Button {
                                selectedURL = IdentifiableURL(url: url)
                            } label: {
                                HStack {
                                    Image(systemName: "doc.text")
                                    
                                    Text("\(Double(index + 1).rounded(to: 0))")
                                        .truncationMode(.middle)
                                    Text("\(url.lastPathComponent)")
                                        .foregroundStyle(.gray)
                                        .font(.caption)
                                    
                                    Spacer()
                                }
                            }
                            .lineLimit(1)
                            .padding(.vertical, 5)
                            .buttonStyle(BorderlessButtonStyle())
                            
                            if index < files.count - 1 {
                                Divider()
                            }
                        }
                    }
                }

            }
        }
        .fullScreenCover(item: $selectedURL) { item in
            SafariView(url: item.url)
        }
    }
}

import SafariServices
struct SafariView: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

struct IdentifiableURL: Identifiable, Equatable {
    let id = UUID()
    let url: URL
}
