//
//  MonthlyCalendarView.swift
//  Boilerplate
//
//  Created by Julien TARET on 28/08/2025.
//

import SwiftUI

/// Vue calendrier mensuelle inspirée de l'app Calendrier d'Apple
struct MonthlyCalendarView: View {
    
    @StateObject private var calendarService = CalendarService()
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var monthEvents: [CalendarEvent] = []
    @State private var showEventDetail = false
    @State private var selectedEvent: CalendarEvent?
    
    private let calendar = Foundation.Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header avec navigation mois
                monthNavigationHeader
                
                // Jours de la semaine
                weekdayHeaders
                
                // Grille des jours du mois
                monthGrid
                
                Spacer()
            }
            .navigationTitle("Calendrier")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await loadCalendarData()
            }
            .sheet(item: $selectedEvent) { event in
                EventDetailView(event: event)
            }
        }
    }
    
    // MARK: - Month Navigation Header
    
    private var monthNavigationHeader: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Text(dateFormatter.string(from: currentMonth))
                .font(.title2)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(.regularMaterial)
    }
    
    // MARK: - Weekday Headers
    
    private var weekdayHeaders: some View {
        HStack(spacing: 0) {
            ForEach(calendar.weekdaySymbols.indices, id: \.self) { index in
                let adjustedIndex = (index + calendar.firstWeekday - 1) % 7
                Text(calendar.veryShortWeekdaySymbols[adjustedIndex])
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.regularMaterial)
    }
    
    // MARK: - Month Grid
    
    private var monthGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 1) {
            ForEach(monthDays, id: \.self) { date in
                DayCell(
                    date: date,
                    currentMonth: currentMonth,
                    selectedDate: $selectedDate,
                    events: eventsForDate(date),
                    onEventTap: { event in
                        selectedEvent = event
                    }
                )
                .frame(height: 80)
                .background(dayBackgroundColor(for: date))
            }
        }
        .background(.regularMaterial)
    }
    
    // MARK: - Helper Methods
    
    private var monthDays: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let firstOfMonth = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        let numberOfDaysToShowFromPreviousMonth = (firstWeekday + 7 - calendar.firstWeekday) % 7
        
        guard let startDate = calendar.date(
            byAdding: .day,
            value: -numberOfDaysToShowFromPreviousMonth,
            to: firstOfMonth
        ) else {
            return []
        }
        
        var days: [Date] = []
        var currentDate = startDate
        
        // Générer 42 jours (6 semaines)
        for _ in 0..<42 {
            days.append(currentDate)
            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDay
        }
        
        return days
    }
    
    private func eventsForDate(_ date: Date) -> [CalendarEvent] {
        return monthEvents.filter { event in
            calendar.isDate(event.startDate, inSameDayAs: date)
        }
    }
    
    private func dayBackgroundColor(for date: Date) -> Color {
        if calendar.isDate(date, inSameDayAs: selectedDate) {
            return .blue.opacity(0.1)
        } else if calendar.isDateInToday(date) {
            return .orange.opacity(0.1)
        } else {
            return .clear
        }
    }
    
    private func previousMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
        }
        Task {
            await loadEventsForMonth()
        }
    }
    
    private func nextMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
        }
        Task {
            await loadEventsForMonth()
        }
    }
    
    private func loadCalendarData() async {
        if calendarService.authorizationStatus != .authorized {
            let granted = await calendarService.requestCalendarAccess()
            if !granted {
                return
            }
        }
        
        await loadEventsForMonth()
    }
    
    private func loadEventsForMonth() async {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return
        }
        
        await calendarService.loadEvents(
            from: monthInterval.start,
            to: monthInterval.end
        )
        
        monthEvents = calendarService.events
    }
}

// MARK: - Day Cell

struct DayCell: View {
    let date: Date
    let currentMonth: Date
    @Binding var selectedDate: Date
    let events: [CalendarEvent]
    let onEventTap: (CalendarEvent) -> Void
    
    private let calendar = Foundation.Calendar.current
    
    var body: some View {
        VStack(spacing: 2) {
            // Numéro du jour
            HStack {
                Text("\(calendar.component(.day, from: date))")
                    .font(.system(size: 14, weight: isToday ? .bold : .medium))
                    .foregroundColor(dayTextColor)
                
                Spacer()
            }
            
            // Événements (max 3 affichés)
            VStack(spacing: 1) {
                ForEach(Array(events.prefix(3).enumerated()), id: \.element.id) { index, event in
                    EventIndicator(event: event)
                        .onTapGesture {
                            onEventTap(event)
                        }
                }
                
                if events.count > 3 {
                    Text("+\(events.count - 3)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(4)
        .contentShape(Rectangle())
        .onTapGesture {
            selectedDate = date
        }
    }
    
    private var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    private var isInCurrentMonth: Bool {
        calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
    }
    
    private var isSelected: Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }
    
    private var dayTextColor: Color {
        if isToday {
            return .orange
        } else if !isInCurrentMonth {
            return .secondary
        } else if isSelected {
            return .blue
        } else {
            return .primary
        }
    }
}

// MARK: - Event Indicator

struct EventIndicator: View {
    let event: CalendarEvent
    
    var body: some View {
        HStack(spacing: 2) {
            // Point de couleur
            Circle()
                .fill(eventColor)
                .frame(width: 4, height: 4)
            
            // Titre de l'événement (tronqué)
            Text(event.title)
                .font(.caption2)
                .lineLimit(1)
                .truncationMode(.tail)
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 2)
        .padding(.vertical, 1)
        .background(eventColor.opacity(0.15))
        .cornerRadius(2)
    }
    
    private var eventColor: Color {
        // Couleurs basées sur le titre pour une cohérence visuelle
        let hash = event.title.hash
        let colors: [Color] = [.blue, .green, .orange, .red, .purple, .pink, .yellow, .cyan]
        return colors[abs(hash) % colors.count]
    }
}

// MARK: - Event Detail View

struct EventDetailView: View {
    let event: CalendarEvent
    @Environment(\.dismiss) private var dismiss
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Titre
                    Text(event.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // Date et heure
                    VStack(alignment: .leading, spacing: 8) {
                        Label {
                            if event.isAllDay {
                                Text("Toute la journée")
                            } else {
                                VStack(alignment: .leading) {
                                    Text("Début: \(dateFormatter.string(from: event.startDate))")
                                    Text("Fin: \(dateFormatter.string(from: event.endDate))")
                                }
                            }
                        } icon: {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    // Lieu
                    if let location = event.location, !location.isEmpty {
                        Label {
                            Text(location)
                        } icon: {
                            Image(systemName: "location")
                                .foregroundColor(.red)
                        }
                    }
                    
                    // Description
                    if let description = event.description, !description.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                            
                            Text(description)
                                .font(.body)
                        }
                    }
                    
                    // URL
                    if let url = event.url {
                        Label {
                            Link(url.absoluteString, destination: url)
                        } icon: {
                            Image(systemName: "link")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Détails")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - CalendarEvent Extension
// CalendarEvent est déjà Identifiable grâce à CalendarModels.swift

#Preview {
    MonthlyCalendarView()
}