//
//  CalendarService.swift
//  Boilerplate
//
//  Created by Julien TARET on 28/08/2025.
//

import Foundation
import EventKit
import Combine
import UIKit

@MainActor
class CalendarService: ObservableObject {
    
    // MARK: - Properties
    private let eventStore = EKEventStore()
    private var boilerplateCalendar: EKCalendar?
    private let boilerplateCalendarTitle = "Boilerplate Calendar"
    
    @Published var authorizationStatus: CalendarAuthorizationStatus = .notDetermined
    @Published var calendars: [Calendar] = []
    @Published var events: [CalendarEvent] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Initialization
    init() {
        updateAuthorizationStatus()
    }
    
    // MARK: - Authorization
    
    func requestCalendarAccess() async -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        // Vérifier d'abord le statut actuel
        let currentStatus = EKEventStore.authorizationStatus(for: .event)
        
        switch currentStatus {
        case .authorized, .fullAccess:
            updateAuthorizationStatus()
            await loadCalendars()
            return true
            
        case .denied, .restricted:
            updateAuthorizationStatus()
            errorMessage = "Calendar access was denied. Please enable in Settings > Privacy & Security > Calendars."
            return false
            
        case .notDetermined, .writeOnly:
            // Demander l'autorisation
            return await withCheckedContinuation { continuation in
                eventStore.requestFullAccessToEvents { granted, error in
                    Task { @MainActor in
                        if let error = error {
                            self.errorMessage = "Calendar permission error: \(error.localizedDescription)"
                            print("Calendar permission error: \(error)")
                        }
                        
                        self.updateAuthorizationStatus()
                        
                        if granted {
                            await self.loadCalendars()
                        } else {
                            self.errorMessage = "Calendar access was denied. Please enable in Settings."
                        }
                        
                        continuation.resume(returning: granted)
                    }
                }
            }
            
        @unknown default:
            updateAuthorizationStatus()
            return false
        }
    }
    
    private func updateAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: .event)
        authorizationStatus = CalendarAuthorizationStatus(from: status)
    }
    
    // MARK: - Calendars Management
    
    func loadCalendars() async {
        guard authorizationStatus == .authorized else {
            errorMessage = "Calendar access not authorized"
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        // Créer ou récupérer le calendrier Boilerplate
        await ensureBoilerplateCalendar()
        
        // Ne montrer que le calendrier Boilerplate dans la liste
        if let boilerplateCalendar = boilerplateCalendar {
            calendars = [Calendar(from: boilerplateCalendar)]
        } else {
            calendars = []
        }
    }
    
    func getDefaultCalendar() -> EKCalendar? {
        return eventStore.defaultCalendarForNewEvents
    }
    
    func getCalendar(by identifier: String) -> EKCalendar? {
        return eventStore.calendar(withIdentifier: identifier)
    }
    
    // MARK: - Events CRUD Operations
    
    func loadEvents(from startDate: Date, to endDate: Date, calendars: [EKCalendar]? = nil) async {
        guard authorizationStatus == .authorized else {
            errorMessage = "Calendar access not authorized"
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        // S'assurer que le calendrier Boilerplate existe
        await ensureBoilerplateCalendar()
        
        // Charger uniquement les événements du calendrier Boilerplate
        guard let boilerplateCalendar = boilerplateCalendar else {
            events = []
            return
        }
        
        let predicate = eventStore.predicateForEvents(
            withStart: startDate,
            end: endDate,
            calendars: [boilerplateCalendar]
        )
        
        let ekEvents = eventStore.events(matching: predicate)
        events = ekEvents.map { CalendarEvent(from: $0) }
    }
    
    func createEvent(_ event: CalendarEvent) async throws -> String {
        guard authorizationStatus == .authorized else {
            throw CalendarError.permissionDenied
        }
        
        // S'assurer que le calendrier Boilerplate existe
        await ensureBoilerplateCalendar()
        
        guard let boilerplateCalendar = boilerplateCalendar else {
            throw CalendarError.calendarNotFound
        }
        
        let ekEvent = EKEvent(eventStore: eventStore)
        
        ekEvent.title = event.title
        ekEvent.notes = event.description
        ekEvent.startDate = event.startDate
        ekEvent.endDate = event.endDate
        ekEvent.location = event.location
        ekEvent.isAllDay = event.isAllDay
        ekEvent.url = event.url
        
        // Toujours utiliser le calendrier Boilerplate
        ekEvent.calendar = boilerplateCalendar
        
        // Add alert if specified
        if let alertOffset = event.alertOffset {
            let alarm = EKAlarm(relativeOffset: alertOffset)
            ekEvent.addAlarm(alarm)
        }
        
        // Add recurrence rule if specified
        if let recurrenceRule = event.recurrenceRule {
            let ekRule = createEKRecurrenceRule(from: recurrenceRule)
            ekEvent.addRecurrenceRule(ekRule)
        }
        
        do {
            try eventStore.save(ekEvent, span: .thisEvent)
            return ekEvent.eventIdentifier ?? ""
        } catch {
            throw CalendarError.saveFailed(error.localizedDescription)
        }
    }
    
    func updateEvent(_ event: CalendarEvent) async throws {
        guard authorizationStatus == .authorized else {
            throw CalendarError.permissionDenied
        }
        
        guard let ekEvent = eventStore.event(withIdentifier: event.id) else {
            throw CalendarError.eventNotFound
        }
        
        ekEvent.title = event.title
        ekEvent.notes = event.description
        ekEvent.startDate = event.startDate
        ekEvent.endDate = event.endDate
        ekEvent.location = event.location
        ekEvent.isAllDay = event.isAllDay
        ekEvent.url = event.url
        
        do {
            try eventStore.save(ekEvent, span: .thisEvent)
        } catch {
            throw CalendarError.saveFailed(error.localizedDescription)
        }
    }
    
    func deleteEvent(withId eventId: String) async throws {
        guard authorizationStatus == .authorized else {
            throw CalendarError.permissionDenied
        }
        
        guard let ekEvent = eventStore.event(withIdentifier: eventId) else {
            throw CalendarError.eventNotFound
        }
        
        do {
            try eventStore.remove(ekEvent, span: .thisEvent)
        } catch {
            throw CalendarError.deleteFailed(error.localizedDescription)
        }
    }
    
    func deleteEvent(_ event: CalendarEvent) async throws {
        try await deleteEvent(withId: event.id)
    }
    
    // MARK: - Search and Filter
    
    func searchEvents(query: String, from startDate: Date, to endDate: Date) async -> [CalendarEvent] {
        guard authorizationStatus == .authorized else {
            return []
        }
        
        await ensureBoilerplateCalendar()
        
        guard let boilerplateCalendar = boilerplateCalendar else {
            return []
        }
        
        let predicate = eventStore.predicateForEvents(
            withStart: startDate,
            end: endDate,
            calendars: [boilerplateCalendar]
        )
        
        let ekEvents = eventStore.events(matching: predicate)
        
        return ekEvents
            .filter { event in
                event.title?.localizedCaseInsensitiveContains(query) == true ||
                event.notes?.localizedCaseInsensitiveContains(query) == true ||
                event.location?.localizedCaseInsensitiveContains(query) == true
            }
            .map { CalendarEvent(from: $0) }
    }
    
    func getEventsForDay(_ date: Date) async -> [CalendarEvent] {
        let calendar = Foundation.Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay
        
        await loadEvents(from: startOfDay, to: endOfDay)
        return events
    }
    
    func getUpcomingEvents(limit: Int = 10) async -> [CalendarEvent] {
        let now = Date()
        let futureDate = Foundation.Calendar.current.date(byAdding: .month, value: 1, to: now) ?? now
        
        await loadEvents(from: now, to: futureDate)
        return Array(events.prefix(limit))
    }
    
    // MARK: - Boilerplate Calendar Management
    
    private func ensureBoilerplateCalendar() async {
        // Chercher d'abord si le calendrier existe déjà
        let existingCalendars = eventStore.calendars(for: .event)
        
        if let existingCalendar = existingCalendars.first(where: { $0.title == boilerplateCalendarTitle }) {
            boilerplateCalendar = existingCalendar
            return
        }
        
        // Créer le calendrier Boilerplate s'il n'existe pas
        await createBoilerplateCalendar()
    }
    
    private func createBoilerplateCalendar() async {
        let newCalendar = EKCalendar(for: .event, eventStore: eventStore)
        newCalendar.title = boilerplateCalendarTitle
        
        // Utiliser la source locale par défaut
        if let localSource = eventStore.sources.first(where: { $0.sourceType == .local }) {
            newCalendar.source = localSource
        } else if let defaultSource = eventStore.defaultCalendarForNewEvents?.source {
            newCalendar.source = defaultSource
        } else {
            // Fallback sur la première source disponible
            newCalendar.source = eventStore.sources.first
        }
        
        // Définir une couleur distinctive pour le calendrier Boilerplate
        newCalendar.cgColor = UIColor.systemBlue.cgColor
        
        do {
            try eventStore.saveCalendar(newCalendar, commit: true)
            boilerplateCalendar = newCalendar
            print("✅ Calendrier Boilerplate créé avec succès")
        } catch {
            print("❌ Erreur lors de la création du calendrier Boilerplate: \(error)")
            errorMessage = "Impossible de créer le calendrier Boilerplate: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Helper Methods
    
    private func createEKRecurrenceRule(from rule: CalendarRecurrenceRule) -> EKRecurrenceRule {
        let frequency: EKRecurrenceFrequency
        switch rule.frequency {
        case .daily:
            frequency = .daily
        case .weekly:
            frequency = .weekly
        case .monthly:
            frequency = .monthly
        case .yearly:
            frequency = .yearly
        }
        
        var recurrenceEnd: EKRecurrenceEnd?
        if let endDate = rule.endDate {
            recurrenceEnd = EKRecurrenceEnd(end: endDate)
        } else if let occurrenceCount = rule.occurrenceCount {
            recurrenceEnd = EKRecurrenceEnd(occurrenceCount: occurrenceCount)
        }
        
        let daysOfWeek: [EKRecurrenceDayOfWeek]? = rule.daysOfWeek?.compactMap { dayValue in
            guard let weekday = EKWeekday(rawValue: dayValue) else { return nil }
            return EKRecurrenceDayOfWeek(weekday)
        }
        
        return EKRecurrenceRule(
            recurrenceWith: frequency,
            interval: rule.interval,
            daysOfTheWeek: daysOfWeek,
            daysOfTheMonth: rule.daysOfMonth?.map { NSNumber(value: $0) },
            monthsOfTheYear: rule.monthsOfYear?.map { NSNumber(value: $0) },
            weeksOfTheYear: rule.weeksOfYear?.map { NSNumber(value: $0) },
            daysOfTheYear: nil,
            setPositions: rule.setPositions?.map { NSNumber(value: $0) },
            end: recurrenceEnd
        )
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Convenience Methods
    
    func createQuickEvent(
        title: String,
        startDate: Date,
        duration: TimeInterval = 3600, // 1 hour default
        location: String? = nil,
        notes: String? = nil
    ) async throws -> String {
        let endDate = startDate.addingTimeInterval(duration)
        
        let event = CalendarEvent(
            title: title,
            description: notes,
            startDate: startDate,
            endDate: endDate,
            location: location
        )
        
        return try await createEvent(event)
    }
    
    func createAllDayEvent(
        title: String,
        date: Date,
        location: String? = nil,
        notes: String? = nil
    ) async throws -> String {
        let calendar = Foundation.Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) ?? startDate
        
        let event = CalendarEvent(
            title: title,
            description: notes,
            startDate: startDate,
            endDate: endDate,
            location: location,
            isAllDay: true
        )
        
        return try await createEvent(event)
    }
}