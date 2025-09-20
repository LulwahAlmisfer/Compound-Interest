//
//  CalendarManager.swift
//  Compounded
//
//  Created by Lulwah almisfer on 04/09/2025.
//

import EventKit
import EventKitUI


class CalendarManager {
    private let eventStore = EKEventStore()
    
    func addEvent(for announcement: Dividends, completion: @escaping (Bool, Error?) -> Void) {
        if #available(iOS 17, *) {
            eventStore.requestFullAccessToEvents { granted, error in
                self.handleAccessResult(granted: granted, error: error, announcement: announcement, completion: completion)
            }
        } else {
            eventStore.requestAccess(to: .event) { granted, error in
                self.handleAccessResult(granted: granted, error: error, announcement: announcement, completion: completion)
            }
        }
    }
    
    private func handleAccessResult(granted: Bool, error: Error?, announcement: Dividends, completion: @escaping (Bool, Error?) -> Void) {
        guard granted, error == nil else {
            DispatchQueue.main.async {
                completion(false, error)
            }
            return
        }
        
        
        let event = EKEvent(eventStore: self.eventStore)
        let localizedTypeTitle = NSLocalizedString(announcement.type.title,
                                                   comment: "Announcement type title")
        event.title = localizedTypeTitle + " " + ((Helper.isArabic() ? announcement.companyName : announcement.companyNameEng) ?? announcement.companyName)


        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: announcement.eventDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        event.startDate = startOfDay
        event.endDate = endOfDay
        event.isAllDay = true
        
        event.notes =  announcement.amount != 0 ? "\(announcement.amount) SR" :  ""
        
        if announcement.type == .assembly {
            event.notes =  announcement.holdingSite
        }
        
        event.calendar = self.eventStore.defaultCalendarForNewEvents
        
        do {
            try self.eventStore.save(event, span: .thisEvent)
            DispatchQueue.main.async {
                completion(true, nil)
            }
        } catch {
            DispatchQueue.main.async {
                completion(false, error)
            }
        }
    }
}

