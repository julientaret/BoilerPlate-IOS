//
//  MonthlyCalendarView.swift
//  Boilerplate
//
//  Created by Julien TARET on 28/08/2025.
//

import SwiftUI

/// Vue calendrier mensuelle utilisant UICalendarView natif
struct MonthlyCalendarView: View {
    
    @StateObject private var sharedService = SharedCalendarService.shared
    
    private var calendarService: CalendarService {
        sharedService.calendarService
    }
    @State private var selectedDate = Date()
    @State private var selectedEvent: CalendarEvent?
    @State private var showCreateEventSheet = false
    @State private var refreshTrigger = UUID()
    @State private var isInitialLoadComplete = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if isInitialLoadComplete {
                    // UICalendarView natif
                    UICalendarViewWrapper(
                        selectedDate: $selectedDate,
                        events: calendarService.events,
                        onDateSelected: { date in
                            selectedDate = date
                        },
                        onEventTap: { event in
                            selectedEvent = event
                        }
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .id(refreshTrigger) // Force le rechargement complet quand refreshTrigger change
                } else {
                    // Indicateur de chargement pendant l'initialisation
                    VStack {
                        Spacer()
                        ProgressView("Chargement du calendrier...")
                            .scaleEffect(1.2)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                Spacer()
            }
            .navigationTitle("Calendrier")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCreateEventSheet = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .task {
                await loadData()
            }
            .onAppear {
                Task {
                    print("👀 MonthlyCalendarView appeared, auth status: \(calendarService.authorizationStatus)")
                    // Rafraîchir uniquement si on revient sur la vue avec autorisation
                    if calendarService.authorizationStatus == .authorized {
                        print("🔄 MonthlyCalendarView refreshing on appear...")
                        await loadData()
                    }
                }
            }
            .sheet(item: $selectedEvent) { event in
                EventDetailView(event: event)
            }
            .sheet(isPresented: $showCreateEventSheet) {
                QuickCreateEventView(calendarService: calendarService, selectedDate: selectedDate) {
                    await loadData()
                }
            }
            .onChange(of: selectedDate) { _, newDate in
                Task {
                    await loadEventsForDate(newDate)
                }
            }
            .onChange(of: calendarService.events) { _, newEvents in
                // Force le rafraîchissement du UICalendarView quand les événements changent
                print("🔄 MonthlyCalendarView: Events changed, new count: \(newEvents.count)")
                refreshTrigger = UUID()
            }
            .refreshable {
                await loadData()
            }
        }
    }
    
    // MARK: - Helper Methods
    
    
    private func loadEventsForDate(_ date: Date) async {
        let calendar = Foundation.Calendar.current
        
        // Charger une plage plus large autour de la date sélectionnée
        let startDate = calendar.date(byAdding: .month, value: -1, to: date) ?? date
        let endDate = calendar.date(byAdding: .month, value: 2, to: date) ?? date
        
        await calendarService.loadEvents(from: startDate, to: endDate)
        
        print("📅 Events loaded for date range: \(calendarService.events.count) events")
    }
    
    private func loadData() async {
        print("🔄 MonthlyCalendarView: Loading data...")
        print("🔐 MonthlyCalendarView: Current auth status: \(calendarService.authorizationStatus)")
        
        // S'assurer d'avoir l'autorisation avant de charger
        if calendarService.authorizationStatus != .authorized {
            print("🔐 MonthlyCalendarView: Requesting calendar access...")
            let granted = await calendarService.requestCalendarAccess()
            if !granted {
                print("❌ MonthlyCalendarView: Calendar access denied")
                isInitialLoadComplete = true // Afficher même en cas d'échec
                return
            }
            print("✅ MonthlyCalendarView: Calendar access granted")
        }
        
        await calendarService.loadCalendars()
        let now = Date()
        let startDate = Foundation.Calendar.current.date(byAdding: .month, value: -1, to: now) ?? now
        let endDate = Foundation.Calendar.current.date(byAdding: .month, value: 2, to: now) ?? now
        await calendarService.loadEvents(from: startDate, to: endDate)
        print("✅ MonthlyCalendarView: Data loaded, \(calendarService.events.count) events found")
        
        // Marquer le chargement initial comme terminé
        isInitialLoadComplete = true
        
        // Petit délai puis forcer une mise à jour de l'UI
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconde
        print("🔄 MonthlyCalendarView: Initial load complete, UI ready")
    }
    
    private func refreshEvents() async {
        await loadData()
    }
}

// MARK: - Quick Create Event View

struct QuickCreateEventView: View {
    let calendarService: CalendarService
    let selectedDate: Date
    let onEventCreated: () async -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var location = ""
    @State private var isAllDay = false
    @State private var isCreating = false
    
    init(calendarService: CalendarService, selectedDate: Date, onEventCreated: @escaping () async -> Void) {
        self.calendarService = calendarService
        self.selectedDate = selectedDate
        self.onEventCreated = onEventCreated
        
        let calendar = Foundation.Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let defaultStart = calendar.date(byAdding: .hour, value: 9, to: startOfDay) ?? selectedDate
        
        _startDate = State(initialValue: defaultStart)
        _endDate = State(initialValue: defaultStart.addingTimeInterval(3600)) // +1h
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Détails de l'événement") {
                    TextField("Titre *", text: $title)
                        .textInputAutocapitalization(.words)
                    
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                    
                    TextField("Lieu", text: $location)
                        .textInputAutocapitalization(.words)
                    
                    Toggle("Toute la journée", isOn: $isAllDay)
                }
                
                Section("Date et heure") {
                    DatePicker(
                        "Début", 
                        selection: $startDate, 
                        displayedComponents: isAllDay ? [.date] : [.date, .hourAndMinute]
                    )
                    
                    if !isAllDay {
                        DatePicker(
                            "Fin", 
                            selection: $endDate, 
                            displayedComponents: [.date, .hourAndMinute]
                        )
                    }
                }
            }
            .navigationTitle("Nouvel événement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                    .disabled(isCreating)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Enregistrer") {
                        Task {
                            await createEvent()
                        }
                    }
                    .disabled(title.isEmpty || isCreating)
                    .overlay {
                        if isCreating {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                    }
                }
            }
            .onChange(of: startDate) { _, newStartDate in
                if !isAllDay && endDate <= newStartDate {
                    endDate = newStartDate.addingTimeInterval(3600) // +1h
                }
            }
        }
    }
    
    private func createEvent() async {
        isCreating = true
        defer { isCreating = false }
        
        let finalEndDate: Date
        if isAllDay {
            let calendar = Foundation.Calendar.current
            let startOfDay = calendar.startOfDay(for: startDate)
            finalEndDate = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? endDate
        } else {
            finalEndDate = endDate
        }
        
        let event = CalendarEvent(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.isEmpty ? nil : description.trimmingCharacters(in: .whitespacesAndNewlines),
            startDate: isAllDay ? Foundation.Calendar.current.startOfDay(for: startDate) : startDate,
            endDate: finalEndDate,
            location: location.isEmpty ? nil : location.trimmingCharacters(in: .whitespacesAndNewlines),
            isAllDay: isAllDay
        )
        
        do {
            let eventId = try await calendarService.createEvent(event)
            print("✅ Event created successfully with ID: \(eventId)")
            print("📝 Event title: \(event.title)")
            print("📅 Event date: \(event.startDate)")
            
            await onEventCreated()
            dismiss()
        } catch {
            print("❌ Failed to create event: \(error)")
            // TODO: Ajouter une alerte d'erreur
        }
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