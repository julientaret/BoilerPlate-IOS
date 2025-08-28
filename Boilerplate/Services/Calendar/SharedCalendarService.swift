//
//  SharedCalendarService.swift
//  Boilerplate
//
//  Created by Julien TARET on 28/08/2025.
//

import Foundation

/// Singleton pour partager la même instance de CalendarService entre toutes les vues
@MainActor
class SharedCalendarService: ObservableObject {
    static let shared = SharedCalendarService()
    
    let calendarService = CalendarService()
    
    private init() {}
}