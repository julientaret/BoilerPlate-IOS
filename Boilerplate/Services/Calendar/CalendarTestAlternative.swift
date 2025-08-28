//
//  CalendarTestAlternative.swift
//  Boilerplate
//
//  Created by Julien TARET on 28/08/2025.
//

import SwiftUI
import EventKit

/// Vue pour tester les fonctionnalités calendrier sans permissions complètes
struct CalendarTestAlternative: View {
    
    @State private var calendars: [EKCalendar] = []
    @State private var testResults: [String] = []
    @State private var isLoading = false
    
    private let eventStore = EKEventStore()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Calendar Alternative Test")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Tests sans permissions complètes")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                Button("Test Basic Calendar Access") {
                    Task {
                        await testBasicAccess()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading)
                
                Button("Test Available Calendars") {
                    Task {
                        await testAvailableCalendars()
                    }
                }
                .buttonStyle(.bordered)
                .disabled(isLoading)
                
                Button("Test Permission Status") {
                    testPermissionStatus()
                }
                .buttonStyle(.bordered)
                
                Button("Clear Results") {
                    testResults.removeAll()
                    calendars.removeAll()
                }
                .buttonStyle(.bordered)
            }
            
            if isLoading {
                ProgressView("Running tests...")
            }
            
            // Results
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(testResults.indices, id: \.self) { index in
                        Text(testResults[index])
                            .font(.system(.caption, design: .monospaced))
                            .padding(.horizontal)
                    }
                    
                    if !calendars.isEmpty {
                        Text("\nAvailable Calendars:")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(calendars.indices, id: \.self) { index in
                            HStack {
                                Circle()
                                    .fill(Color(calendars[index].cgColor))
                                    .frame(width: 12, height: 12)
                                
                                VStack(alignment: .leading) {
                                    Text(calendars[index].title)
                                        .font(.subheadline)
                                    Text(calendars[index].source.title)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Text(calendars[index].allowsContentModifications ? "✓" : "ReadOnly")
                                    .font(.caption)
                                    .foregroundColor(calendars[index].allowsContentModifications ? .green : .orange)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .background(.secondary.opacity(0.1))
            .cornerRadius(8)
            
            Spacer()
        }
        .padding()
    }
    
    private func addResult(_ message: String) {
        testResults.append("\(Date().formatted(date: .omitted, time: .shortened)): \(message)")
    }
    
    private func testPermissionStatus() {
        let status = EKEventStore.authorizationStatus(for: .event)
        addResult("Permission Status: \(status.rawValue)")
        
        switch status {
        case .notDetermined:
            addResult("Status: Not Determined - Permission popup should appear when requesting")
        case .denied:
            addResult("Status: Denied - Check Settings > Privacy > Calendars")
        case .authorized:
            addResult("Status: Authorized (Legacy)")
        case .restricted:
            addResult("Status: Restricted - Device restrictions active")
        case .fullAccess:
            addResult("Status: Full Access - All operations allowed")
        case .writeOnly:
            addResult("Status: Write Only - Limited access")
        @unknown default:
            addResult("Status: Unknown (\(status.rawValue))")
        }
    }
    
    private func testBasicAccess() async {
        isLoading = true
        addResult("=== Testing Basic EventKit Access ===")
        
        do {
            // Test si EventKit est disponible
            addResult("EventKit framework: Available")
            
            // Test création d'un EKEventStore
            let store = EKEventStore()
            addResult("EKEventStore: Created successfully")
            
            // Test des constantes EventKit
            addResult("Event entity type: \(EKEntityType.event.rawValue)")
            addResult("Current permission: \(EKEventStore.authorizationStatus(for: .event).rawValue)")
            
        } catch {
            addResult("Error: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    private func testAvailableCalendars() async {
        isLoading = true
        addResult("=== Testing Available Calendars ===")
        
        do {
            // Essayer de récupérer les calendriers (peut fonctionner même sans permissions complètes)
            let availableCalendars = eventStore.calendars(for: .event)
            calendars = availableCalendars
            
            addResult("Found \(availableCalendars.count) calendars")
            
            for calendar in availableCalendars {
                let editableText = calendar.allowsContentModifications ? "Editable" : "ReadOnly"
                addResult("- \(calendar.title) (\(calendar.source.title)) - \(editableText)")
            }
            
            if let defaultCalendar = eventStore.defaultCalendarForNewEvents {
                addResult("Default calendar: \(defaultCalendar.title)")
            } else {
                addResult("No default calendar available")
            }
            
        } catch {
            addResult("Error accessing calendars: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
}

#Preview {
    CalendarTestAlternative()
}