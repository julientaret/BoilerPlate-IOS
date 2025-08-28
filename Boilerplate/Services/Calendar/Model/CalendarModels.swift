//
//  CalendarModels.swift
//  Boilerplate
//
//  Created by Julien TARET on 28/08/2025.
//

import Foundation
import EventKit
import UIKit

// MARK: - Calendar Event Model
struct CalendarEvent: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let description: String?
    let startDate: Date
    let endDate: Date
    let location: String?
    let isAllDay: Bool
    let recurrenceRule: CalendarRecurrenceRule?
    let alertOffset: TimeInterval?
    let calendarIdentifier: String?
    let url: URL?
    
    init(from ekEvent: EKEvent) {
        self.id = ekEvent.eventIdentifier ?? UUID().uuidString
        self.title = ekEvent.title ?? ""
        self.description = ekEvent.notes
        self.startDate = ekEvent.startDate
        self.endDate = ekEvent.endDate
        self.location = ekEvent.location
        self.isAllDay = ekEvent.isAllDay
        self.recurrenceRule = ekEvent.recurrenceRules?.first.map { CalendarRecurrenceRule(from: $0) }
        self.alertOffset = ekEvent.alarms?.first?.relativeOffset
        self.calendarIdentifier = ekEvent.calendar?.calendarIdentifier
        self.url = ekEvent.url
    }
    
    init(
        id: String = UUID().uuidString,
        title: String,
        description: String? = nil,
        startDate: Date,
        endDate: Date,
        location: String? = nil,
        isAllDay: Bool = false,
        recurrenceRule: CalendarRecurrenceRule? = nil,
        alertOffset: TimeInterval? = nil,
        calendarIdentifier: String? = nil,
        url: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.isAllDay = isAllDay
        self.recurrenceRule = recurrenceRule
        self.alertOffset = alertOffset
        self.calendarIdentifier = calendarIdentifier
        self.url = url
    }
}

// MARK: - Calendar Model
struct Calendar: Identifiable {
    let id: String
    let title: String
    let color: String
    let source: String
    let type: CalendarType
    let isEditable: Bool
    
    init(from ekCalendar: EKCalendar) {
        self.id = ekCalendar.calendarIdentifier
        self.title = ekCalendar.title
        self.color = UIColor(cgColor: ekCalendar.cgColor).toHexString()
        self.source = ekCalendar.source.title
        self.type = CalendarType(from: ekCalendar.type)
        self.isEditable = ekCalendar.allowsContentModifications
    }
}

// MARK: - Calendar Type
enum CalendarType: String, CaseIterable {
    case local = "local"
    case caldav = "caldav"
    case exchange = "exchange"
    case subscription = "subscription"
    case birthday = "birthday"
    
    init(from ekType: EKCalendarType) {
        switch ekType {
        case .local:
            self = .local
        case .calDAV:
            self = .caldav
        case .exchange:
            self = .exchange
        case .subscription:
            self = .subscription
        case .birthday:
            self = .birthday
        @unknown default:
            self = .local
        }
    }
}

// MARK: - Recurrence Rule
struct CalendarRecurrenceRule: Codable, Equatable {
    let frequency: RecurrenceFrequency
    let interval: Int
    let daysOfWeek: [Int]?
    let daysOfMonth: [Int]?
    let monthsOfYear: [Int]?
    let weeksOfYear: [Int]?
    let setPositions: [Int]?
    let endDate: Date?
    let occurrenceCount: Int?
    
    init(from ekRule: EKRecurrenceRule) {
        switch ekRule.frequency {
        case .daily:
            self.frequency = .daily
        case .weekly:
            self.frequency = .weekly
        case .monthly:
            self.frequency = .monthly
        case .yearly:
            self.frequency = .yearly
        @unknown default:
            self.frequency = .daily
        }
        
        self.interval = ekRule.interval
        self.daysOfWeek = ekRule.daysOfTheWeek?.map { $0.dayOfTheWeek.rawValue }
        self.daysOfMonth = ekRule.daysOfTheMonth?.map { $0.intValue }
        self.monthsOfYear = ekRule.monthsOfTheYear?.map { $0.intValue }
        self.weeksOfYear = ekRule.weeksOfTheYear?.map { $0.intValue }
        self.setPositions = ekRule.setPositions?.map { $0.intValue }
        
        if let ekEnd = ekRule.recurrenceEnd {
            self.endDate = ekEnd.endDate
            self.occurrenceCount = ekEnd.occurrenceCount
        } else {
            self.endDate = nil
            self.occurrenceCount = nil
        }
    }
    
    init(
        frequency: RecurrenceFrequency,
        interval: Int = 1,
        daysOfWeek: [Int]? = nil,
        daysOfMonth: [Int]? = nil,
        monthsOfYear: [Int]? = nil,
        weeksOfYear: [Int]? = nil,
        setPositions: [Int]? = nil,
        endDate: Date? = nil,
        occurrenceCount: Int? = nil
    ) {
        self.frequency = frequency
        self.interval = interval
        self.daysOfWeek = daysOfWeek
        self.daysOfMonth = daysOfMonth
        self.monthsOfYear = monthsOfYear
        self.weeksOfYear = weeksOfYear
        self.setPositions = setPositions
        self.endDate = endDate
        self.occurrenceCount = occurrenceCount
    }
}

enum RecurrenceFrequency: String, Codable, CaseIterable {
    case daily = "daily"
    case weekly = "weekly"
    case monthly = "monthly"
    case yearly = "yearly"
}

// MARK: - Calendar Authorization Status
enum CalendarAuthorizationStatus {
    case notDetermined
    case denied
    case authorized
    case restricted
    
    init(from ekStatus: EKAuthorizationStatus) {
        switch ekStatus {
        case .notDetermined:
            self = .notDetermined
        case .denied:
            self = .denied
        case .authorized:
            self = .authorized
        case .restricted:
            self = .restricted
        case .fullAccess:
            self = .authorized
        case .writeOnly:
            self = .authorized
        @unknown default:
            self = .notDetermined
        }
    }
}

// MARK: - Calendar Error
enum CalendarError: LocalizedError {
    case permissionDenied
    case eventNotFound
    case calendarNotFound
    case saveFailed(String)
    case deleteFailed(String)
    case invalidEvent
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Calendar access permission denied"
        case .eventNotFound:
            return "Event not found"
        case .calendarNotFound:
            return "Calendar not found"
        case .saveFailed(let message):
            return "Failed to save event: \(message)"
        case .deleteFailed(let message):
            return "Failed to delete event: \(message)"
        case .invalidEvent:
            return "Invalid event data"
        case .unknown(let message):
            return "Unknown error: \(message)"
        }
    }
}

// MARK: - UIColor Extension
extension UIColor {
    func toHexString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return String(format: "#%02X%02X%02X",
                     Int(red * 255),
                     Int(green * 255),
                     Int(blue * 255))
    }
}