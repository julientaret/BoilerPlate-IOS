//
//  CalendarServiceExample.swift
//  Boilerplate
//
//  Created by Julien TARET on 28/08/2025.
//

import SwiftUI

/// Exemple d'utilisation du CalendarService
/// Cette vue démontre toutes les fonctionnalités principales du service calendrier
struct CalendarServiceExample: View {
    
    @StateObject private var calendarService = CalendarService()
    @State private var showCreateEventSheet = false
    @State private var selectedDate = Date()
    @State private var searchQuery = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if calendarService.authorizationStatus == .notDetermined {
                    // Permission Request View
                    permissionRequestView
                } else if calendarService.authorizationStatus == .denied {
                    // Permission Denied View
                    permissionDeniedView
                } else {
                    // Main Calendar View
                    mainCalendarView
                }
            }
            .navigationTitle("Calendar Service Demo")
            .sheet(isPresented: $showCreateEventSheet) {
                CreateEventView(calendarService: calendarService)
            }
            .alert("Error", isPresented: .constant(calendarService.errorMessage != nil)) {
                Button("OK") {
                    calendarService.clearError()
                }
            } message: {
                Text(calendarService.errorMessage ?? "Unknown error")
            }
        }
        .task {
            await calendarService.loadCalendars()
        }
    }
    
    // MARK: - Permission Views
    
    private var permissionRequestView: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.circle")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("Calendar Access Required")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("This demo needs access to your calendar to show events and create new ones.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button("Request Permission") {
                Task {
                    await calendarService.requestCalendarAccess()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private var permissionDeniedView: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("Calendar Access Denied")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Please enable calendar access in Settings to use this feature.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button("Open Settings") {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    // MARK: - Main Calendar View
    
    private var mainCalendarView: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Quick Actions
                quickActionsSection
                
                // Calendars List
                calendarsSection
                
                // Search Events
                searchSection
                
                // Recent Events
                eventsSection
                
                // Create Event Examples
                createEventExamples
            }
            .padding()
        }
        .refreshable {
            await loadData()
        }
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
            
            HStack(spacing: 12) {
                Button("Create Event") {
                    showCreateEventSheet = true
                }
                .buttonStyle(.borderedProminent)
                
                Button("Today's Events") {
                    Task {
                        _ = await calendarService.getEventsForDay(Date())
                    }
                }
                .buttonStyle(.bordered)
                
                Button("Upcoming") {
                    Task {
                        _ = await calendarService.getUpcomingEvents()
                    }
                }
                .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var calendarsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Available Calendars (\(calendarService.calendars.count))")
                .font(.headline)
            
            if calendarService.calendars.isEmpty {
                Text("No calendars found")
                    .foregroundColor(.secondary)
            } else {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(calendarService.calendars) { calendar in
                        CalendarRowView(calendar: calendar)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Search Events")
                .font(.headline)
            
            HStack {
                TextField("Search events...", text: $searchQuery)
                    .textFieldStyle(.roundedBorder)
                
                Button("Search") {
                    Task {
                        let now = Date()
                        let futureDate = Foundation.Calendar.current.date(byAdding: .month, value: 1, to: now) ?? now
                        let results = await calendarService.searchEvents(
                            query: searchQuery,
                            from: now,
                            to: futureDate
                        )
                        // Handle search results
                        print("Found \(results.count) events")
                    }
                }
                .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var eventsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Events (\(calendarService.events.count))")
                .font(.headline)
            
            if calendarService.isLoading {
                ProgressView("Loading events...")
            } else if calendarService.events.isEmpty {
                Text("No events found")
                    .foregroundColor(.secondary)
            } else {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(calendarService.events) { event in
                        EventRowView(event: event, calendarService: calendarService)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var createEventExamples: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Event Examples")
                .font(.headline)
            
            VStack(spacing: 8) {
                Button("Create Meeting in 1 Hour") {
                    Task {
                        let startDate = Foundation.Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
                        do {
                            _ = try await calendarService.createQuickEvent(
                                title: "Team Meeting",
                                startDate: startDate,
                                duration: 3600,
                                location: "Conference Room A",
                                notes: "Weekly team sync meeting"
                            )
                            await loadData()
                        } catch {
                            print("Failed to create event: \(error)")
                        }
                    }
                }
                .buttonStyle(.bordered)
                
                Button("Create All-Day Event Tomorrow") {
                    Task {
                        let tomorrow = Foundation.Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
                        do {
                            _ = try await calendarService.createAllDayEvent(
                                title: "Company Holiday",
                                date: tomorrow,
                                notes: "All-day company event"
                            )
                            await loadData()
                        } catch {
                            print("Failed to create all-day event: \(error)")
                        }
                    }
                }
                .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Helper Methods
    
    private func loadData() async {
        await calendarService.loadCalendars()
        let now = Date()
        let futureDate = Foundation.Calendar.current.date(byAdding: .month, value: 1, to: now) ?? now
        await calendarService.loadEvents(from: now, to: futureDate)
    }
}

// MARK: - Supporting Views

struct CalendarRowView: View {
    let calendar: Calendar
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color(UIColor(hex: calendar.color) ?? .systemBlue))
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(calendar.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(calendar.source)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if !calendar.isEditable {
                Text("Read Only")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.secondary.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 4)
    }
}

struct EventRowView: View {
    let event: CalendarEvent
    let calendarService: CalendarService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(event.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Button("Delete") {
                    Task {
                        do {
                            try await calendarService.deleteEvent(event)
                        } catch {
                            print("Failed to delete event: \(error)")
                        }
                    }
                }
                .font(.caption)
                .foregroundColor(.red)
            }
            
            if let location = event.location {
                Text("📍 \(location)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(event.isAllDay ? "All Day" : "\(event.startDate.formatted(date: .abbreviated, time: .shortened))")
                .font(.caption)
                .foregroundColor(.secondary)
            
            if let description = event.description, !description.isEmpty {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(.secondary.opacity(0.1))
        .cornerRadius(8)
    }
}

struct CreateEventView: View {
    let calendarService: CalendarService
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(3600)
    @State private var location = ""
    @State private var isAllDay = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Event Details") {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                    TextField("Location", text: $location)
                    Toggle("All Day", isOn: $isAllDay)
                }
                
                Section("Date & Time") {
                    DatePicker("Start", selection: $startDate, displayedComponents: isAllDay ? [.date] : [.date, .hourAndMinute])
                    
                    if !isAllDay {
                        DatePicker("End", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }
            }
            .navigationTitle("Create Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            await createEvent()
                        }
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func createEvent() async {
        let finalEndDate = isAllDay 
            ? Foundation.Calendar.current.date(byAdding: .day, value: 1, to: Foundation.Calendar.current.startOfDay(for: startDate)) ?? endDate
            : endDate
        
        let event = CalendarEvent(
            title: title,
            description: description.isEmpty ? nil : description,
            startDate: startDate,
            endDate: finalEndDate,
            location: location.isEmpty ? nil : location,
            isAllDay: isAllDay
        )
        
        do {
            _ = try await calendarService.createEvent(event)
            dismiss()
        } catch {
            print("Failed to create event: \(error)")
        }
    }
}

// MARK: - UIColor Extension
extension UIColor {
    convenience init?(hex: String) {
        let r, g, b: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }
        
        return nil
    }
}

#Preview {
    CalendarServiceExample()
}