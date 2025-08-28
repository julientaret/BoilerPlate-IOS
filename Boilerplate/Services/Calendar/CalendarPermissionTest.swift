//
//  CalendarPermissionTest.swift
//  Boilerplate
//
//  Created by Julien TARET on 28/08/2025.
//

import SwiftUI
import EventKit

/// Vue pour tester spécifiquement les permissions calendrier
struct CalendarPermissionTest: View {
    
    @State private var permissionStatus: String = "Unknown"
    @State private var errorMessage: String = ""
    @State private var isLoading = false
    
    private let eventStore = EKEventStore()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Calendar Permission Test")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Status: \(permissionStatus)")
                .font(.headline)
                .foregroundColor(statusColor)
            
            if !errorMessage.isEmpty {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            VStack(spacing: 12) {
                Button("Check Current Status") {
                    checkCurrentStatus()
                }
                .buttonStyle(.bordered)
                
                Button("Request Permission") {
                    Task {
                        await requestPermission()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading)
                
                if isLoading {
                    ProgressView("Requesting permission...")
                }
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Debug Info:")
                    .font(.headline)
                
                Text("iOS Version: \(UIDevice.current.systemVersion)")
                Text("Device: \(UIDevice.current.model)")
                Text("Is Simulator: \(isSimulator)")
                
                Text("\nSteps to enable on Simulator:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("1. Go to Settings app on simulator")
                Text("2. Privacy & Security > Calendars")
                Text("3. Enable permission for this app")
                Text("4. Try the request again")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            .padding()
            .background(.secondary.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .onAppear {
            checkCurrentStatus()
        }
    }
    
    private var statusColor: Color {
        switch permissionStatus {
        case "Authorized", "Full Access":
            return .green
        case "Denied", "Restricted":
            return .red
        case "Not Determined":
            return .orange
        default:
            return .secondary
        }
    }
    
    private var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    private func checkCurrentStatus() {
        let status = EKEventStore.authorizationStatus(for: .event)
        
        switch status {
        case .notDetermined:
            permissionStatus = "Not Determined"
        case .denied:
            permissionStatus = "Denied"
        case .authorized:
            permissionStatus = "Authorized (Legacy)"
        case .restricted:
            permissionStatus = "Restricted"
        case .fullAccess:
            permissionStatus = "Full Access"
        case .writeOnly:
            permissionStatus = "Write Only"
        @unknown default:
            permissionStatus = "Unknown (\(status.rawValue))"
        }
        
        print("Calendar permission status: \(permissionStatus)")
    }
    
    private func requestPermission() async {
        isLoading = true
        errorMessage = ""
        
        print("=== Starting calendar permission request ===")
        print("Current status before request: \(EKEventStore.authorizationStatus(for: .event).rawValue)")
        
        // Essayer d'abord avec requestAccess (legacy) pour compatibilité
        let success = await requestPermissionLegacy()
        
        if !success {
            print("Legacy request failed, trying modern API...")
            await requestPermissionModern()
        }
        
        isLoading = false
        checkCurrentStatus()
    }
    
    private func requestPermissionLegacy() async -> Bool {
        return await withCheckedContinuation { continuation in
            if #available(iOS 17.0, *) {
                // iOS 17+ method
                eventStore.requestFullAccessToEvents { granted, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            self.errorMessage = "Legacy API Error: \(error.localizedDescription)"
                            print("Legacy permission error: \(error)")
                        }
                        print("Legacy API - Permission granted: \(granted)")
                        continuation.resume(returning: granted)
                    }
                }
            } else {
                // Fallback pour iOS 16 et antérieur
                eventStore.requestAccess(to: .event) { granted, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            self.errorMessage = "Fallback API Error: \(error.localizedDescription)"
                            print("Fallback permission error: \(error)")
                        }
                        print("Fallback API - Permission granted: \(granted)")
                        continuation.resume(returning: granted)
                    }
                }
            }
        }
    }
    
    private func requestPermissionModern() async {
        await withCheckedContinuation { continuation in
            eventStore.requestFullAccessToEvents { granted, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.errorMessage = "Modern API Error: \(error.localizedDescription)"
                        print("Modern permission error: \(error)")
                    } else if !granted {
                        self.errorMessage = "Permission denied. Please enable in Settings > Privacy & Security > Calendars"
                    }
                    
                    print("Modern API - Permission granted: \(granted)")
                    continuation.resume()
                }
            }
        }
    }
}

#Preview {
    CalendarPermissionTest()
}