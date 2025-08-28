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
                Image(systemName: "chevron.left.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            VStack(spacing: 2) {
                Text(dateFormatter.string(from: currentMonth).capitalized)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                if calendar.isDate(currentMonth, equalTo: Date(), toGranularity: .month) {
                    Text("Aujourd'hui")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .fontWeight(.medium)
                }
            }
            
            Spacer()
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            LinearGradient(
                colors: [Color(.systemBackground), Color(.systemBackground).opacity(0.95)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .overlay(
            Rectangle()
                .fill(Color(.separator))
                .frame(height: 0.5),
            alignment: .bottom
        )
    }
    
    // MARK: - Weekday Headers
    
    private var weekdayHeaders: some View {
        HStack(spacing: 0) {
            ForEach(calendar.weekdaySymbols.indices, id: \.self) { index in
                let adjustedIndex = (index + calendar.firstWeekday - 1) % 7
                Text(calendar.veryShortWeekdaySymbols[adjustedIndex].uppercased())
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemBackground))
    }
    
    // MARK: - Month Grid
    
    private var monthGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 0.5) {
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
                .frame(height: 85)
                .background(dayBackgroundColor(for: date))
                .overlay(
                    Rectangle()
                        .fill(Color(.separator))
                        .frame(width: 0.5),
                    alignment: .trailing
                )
                .overlay(
                    Rectangle()
                        .fill(Color(.separator))
                        .frame(height: 0.5),
                    alignment: .bottom
                )
            }
        }
        .background(Color(.systemBackground))
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
            return .blue.opacity(0.15)
        } else if calendar.isDateInToday(date) {
            return .orange.opacity(0.1)
        } else {
            return Color(.systemBackground)
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
        VStack(spacing: 3) {
            // Numéro du jour avec cercle si aujourd'hui
            HStack {
                if isToday {
                    Text("\(calendar.component(.day, from: date))")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 28, height: 28)
                        .background(Color.orange)
                        .clipShape(Circle())
                } else if isSelected {
                    Text("\(calendar.component(.day, from: date))")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 28, height: 28)
                        .background(Color.blue)
                        .clipShape(Circle())
                } else {
                    Text("\(calendar.component(.day, from: date))")
                        .font(.system(size: 16, weight: isInCurrentMonth ? .medium : .light))
                        .foregroundColor(dayTextColor)
                }
                
                Spacer()
            }
            
            // Événements (max 3 affichés)
            VStack(spacing: 2) {
                ForEach(Array(events.prefix(3).enumerated()), id: \.element.id) { index, event in
                    EventIndicator(event: event)
                        .onTapGesture {
                            onEventTap(event)
                        }
                }
                
                if events.count > 3 {
                    Text("+\(events.count - 3)")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(3)
                }
            }
            
            Spacer(minLength: 0)
        }
        .padding(6)
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
        HStack(spacing: 3) {
            // Point de couleur plus visible
            RoundedRectangle(cornerRadius: 1)
                .fill(eventColor)
                .frame(width: 3, height: 10)
            
            // Titre de l'événement (tronqué)
            Text(event.title)
                .font(.caption2)
                .fontWeight(.medium)
                .lineLimit(1)
                .truncationMode(.tail)
                .foregroundColor(.primary)
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(eventColor.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(eventColor.opacity(0.3), lineWidth: 0.5)
                )
        )
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