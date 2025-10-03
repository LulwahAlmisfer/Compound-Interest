//
//  AnnouncementResponse.swift
//  Compounded
//
//  Created by Lulwah almisfer on 02/10/2025.
//


struct AnnouncementResponse: Codable {
    let url: String
    let announcement: Announcement
}

struct Announcement: Codable {
    let meetingLink: String?
    let attachedFiles: [String]?
    let contactInfo: String?
    let proxyForm: String?
    let agenda: String?
    let meetingTime: String?
    let electronicVotingDetails: String?
    let shareholderRights: String?
    let attendanceAndVoting: String?
    let meetingDate: String?
    let meetingLocation: String?
    let meetingMethod: String?
    let introduction: String?
    let requiredQuorum: String?
}
