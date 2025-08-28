//
//  SharedCalendarService.swift
//  Boilerplate
//
//  Created by Julien TARET on 28/08/2025.
//

import Foundation
import Combine

/// Singleton pour partager la même instance de CalendarService entre toutes les vues
@MainActor
class SharedCalendarService: ObservableObject {
    static let shared = SharedCalendarService()
    
    let calendarService = CalendarService()
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // Relayer les changements du CalendarService
        calendarService.objectWillChange
            .sink { [weak self] _ in
                print("🔄 SharedCalendarService: Relaying change notification")
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    /// Force un rafraîchissement de toutes les vues connectées
    func forceRefresh() {
        print("🔄 SharedCalendarService: Force refresh requested")
        objectWillChange.send()
    }
}