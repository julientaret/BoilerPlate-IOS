//
//  UICalendarViewWrapper.swift
//  Boilerplate
//
//  Created by Julien TARET on 28/08/2025.
//

import SwiftUI
import UIKit
import Foundation

struct UICalendarViewWrapper: UIViewRepresentable {
    @Binding var selectedDate: Date
    let events: [CalendarEvent]
    let onDateSelected: (Date) -> Void
    let onEventTap: (CalendarEvent) -> Void
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.delegate = context.coordinator
        calendarView.calendar = Foundation.Calendar(identifier: .gregorian)
        calendarView.locale = Locale(identifier: "fr_FR")
        calendarView.fontDesign = .default
        calendarView.availableDateRange = DateInterval(start: .distantPast, end: .distantFuture)
        
        let selection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        selection.selectedDate = Foundation.Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        calendarView.selectionBehavior = selection
        
        return calendarView
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        print("🔄 UICalendarView updateUIView called with \(events.count) events")
        
        if !events.isEmpty {
            print("📋 Event details:")
            for event in events.prefix(3) {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                print("   - \(event.title) on \(formatter.string(from: event.startDate))")
            }
        }
        
        // Mise à jour de la date sélectionnée
        if let selection = uiView.selectionBehavior as? UICalendarSelectionSingleDate {
            let newSelectedComponents = Foundation.Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
            if selection.selectedDate != newSelectedComponents {
                selection.selectedDate = newSelectedComponents
            }
        }
        
        // Forcer un rafraîchissement complet plus agressif
        context.coordinator.forceReloadDecorations(uiView)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: UICalendarViewWrapper
        
        init(_ parent: UICalendarViewWrapper) {
            self.parent = parent
        }
        
        func forceReloadDecorations(_ calendarView: UICalendarView) {
            print("🎯 ForceReloadDecorations called with \(parent.events.count) events")
            
            // Calculer une plage plus large de dates à rafraîchir
            let calendar = Foundation.Calendar.current
            let today = Date()
            
            // Rafraîchir 3 mois avant et après
            var allDatesToReload: [DateComponents] = []
            for monthOffset in -3...3 {
                if let monthDate = calendar.date(byAdding: .month, value: monthOffset, to: today),
                   let monthInterval = calendar.dateInterval(of: .month, for: monthDate) {
                    
                    var date = monthInterval.start
                    while date < monthInterval.end {
                        let components = calendar.dateComponents([.year, .month, .day], from: date)
                        allDatesToReload.append(components)
                        date = calendar.date(byAdding: .day, value: 1, to: date) ?? monthInterval.end
                    }
                }
            }
            
            print("🔄 Reloading \(allDatesToReload.count) dates")
            
            // Forcer le rechargement immédiatement
            DispatchQueue.main.async {
                calendarView.reloadDecorations(forDateComponents: allDatesToReload, animated: false)
            }
            
            // Puis avec animation dans un délai court
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                calendarView.reloadDecorations(forDateComponents: allDatesToReload, animated: true)
            }
        }
        
        // MARK: - UICalendarViewDelegate
        
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            guard let date = Foundation.Calendar.current.date(from: dateComponents) else {
                return nil
            }
            
            let eventsForDate = parent.events.filter { event in
                Foundation.Calendar.current.isDate(event.startDate, inSameDayAs: date)
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM"
            let dateString = formatter.string(from: date)
            
            if !eventsForDate.isEmpty {
                print("🎯 Decoration for \(dateString): \(eventsForDate.count) event(s) - \(eventsForDate.map { $0.title }.joined(separator: ", "))")
            }
            
            if eventsForDate.isEmpty {
                return nil
            }
            
            if eventsForDate.count == 1 {
                // Un seul événement : point coloré
                return .default(color: colorForEvent(eventsForDate.first!), size: .large)
            } else {
                // Plusieurs événements : point simple
                return .default(color: .systemBlue, size: .large)
            }
        }
        
        private func colorForEvent(_ event: CalendarEvent) -> UIColor {
            let hash = event.title.hash
            let colors: [UIColor] = [.systemBlue, .systemGreen, .systemOrange, .systemRed, .systemPurple, .systemPink, .systemYellow, .systemCyan]
            return colors[abs(hash) % colors.count]
        }
        
        // MARK: - UICalendarSelectionSingleDateDelegate
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            guard let dateComponents = dateComponents,
                  let date = Foundation.Calendar.current.date(from: dateComponents) else {
                return
            }
            
            parent.selectedDate = date
            parent.onDateSelected(date)
            
            // Si il y a des événements ce jour-là, déclencher le tap sur le premier
            let eventsForDate = parent.events.filter { event in
                Foundation.Calendar.current.isDate(event.startDate, inSameDayAs: date)
            }
            
            if let firstEvent = eventsForDate.first {
                parent.onEventTap(firstEvent)
            }
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
            return true
        }
    }
}