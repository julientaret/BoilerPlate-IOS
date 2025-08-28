# Calendar Service Documentation

## Vue d'ensemble

Le `CalendarService` fournit une interface Swift moderne pour interagir avec le calendrier système iOS via EventKit. Il gère les permissions, les opérations CRUD sur les événements, et offre des méthodes de recherche et de filtrage.

## Fonctionnalités

### ✅ Gestion des Permissions
- Demande automatique des permissions calendrier
- Gestion des différents états d'autorisation
- Interface utilisateur adaptative selon les permissions

### ✅ Gestion des Calendriers
- Liste de tous les calendriers disponibles
- Support des calendriers iCloud, Google, Exchange
- Identification des calendriers en lecture seule

### ✅ Opérations CRUD sur les Événements
- **Create**: Créer de nouveaux événements
- **Read**: Lire les événements existants
- **Update**: Modifier les événements
- **Delete**: Supprimer les événements

### ✅ Fonctionnalités Avancées
- Événements récurrents (quotidien, hebdomadaire, mensuel, annuel)
- Événements toute la journée
- Alertes et rappels
- Recherche d'événements par texte
- Filtrage par date et calendrier

## Structure du Code

```
Services/Calendar/
├── CalendarModels.swift          # Modèles de données Swift
├── CalendarService.swift         # Service principal EventKit
├── CalendarServiceExample.swift  # Exemple d'utilisation complet
└── README.md                    # Cette documentation
```

## Utilisation Rapide

### 1. Initialisation

```swift
@StateObject private var calendarService = CalendarService()
```

### 2. Demander les Permissions

```swift
let hasPermission = await calendarService.requestCalendarAccess()
if hasPermission {
    // Procéder avec les opérations calendrier
}
```

### 3. Créer un Événement Simple

```swift
let event = CalendarEvent(
    title: "Réunion équipe",
    description: "Réunion hebdomadaire",
    startDate: Date(),
    endDate: Date().addingTimeInterval(3600), // 1h plus tard
    location: "Salle de conférence A"
)

do {
    let eventId = try await calendarService.createEvent(event)
    print("Événement créé avec l'ID: \(eventId)")
} catch {
    print("Erreur: \(error)")
}
```

### 4. Créer un Événement Rapide

```swift
// Événement d'1 heure dans 30 minutes
try await calendarService.createQuickEvent(
    title: "Call client",
    startDate: Date().addingTimeInterval(1800),
    duration: 3600,
    location: "Bureau",
    notes: "Discuter du projet"
)
```

### 5. Créer un Événement Toute la Journée

```swift
try await calendarService.createAllDayEvent(
    title: "Vacances",
    date: tomorrow,
    notes: "Congé annuel"
)
```

### 6. Récupérer les Événements

```swift
// Événements du jour
let todayEvents = await calendarService.getEventsForDay(Date())

// Événements à venir (10 prochains)
let upcomingEvents = await calendarService.getUpcomingEvents(limit: 10)

// Événements dans une période
let now = Date()
let nextWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: now)!
await calendarService.loadEvents(from: now, to: nextWeek)
```

### 7. Rechercher des Événements

```swift
let results = await calendarService.searchEvents(
    query: "réunion",
    from: Date(),
    to: Date().addingTimeInterval(86400 * 30) // 30 jours
)
```

### 8. Supprimer un Événement

```swift
try await calendarService.deleteEvent(event)
// ou
try await calendarService.deleteEvent(withId: eventId)
```

## Modèles de Données

### CalendarEvent
```swift
struct CalendarEvent {
    let id: String
    let title: String
    let description: String?
    let startDate: Date
    let endDate: Date
    let location: String?
    let isAllDay: Bool
    let recurrenceRule: CalendarRecurrenceRule?
    let alertOffset: TimeInterval?
    let calendarIdentifier: String?
    let url: URL?
}
```

### CalendarRecurrenceRule
```swift
struct CalendarRecurrenceRule {
    let frequency: RecurrenceFrequency // .daily, .weekly, .monthly, .yearly
    let interval: Int
    let daysOfWeek: [Int]?
    let endDate: Date?
    let occurrenceCount: Int?
}
```

## Gestion des Erreurs

```swift
enum CalendarError: LocalizedError {
    case permissionDenied
    case eventNotFound
    case calendarNotFound
    case saveFailed(String)
    case deleteFailed(String)
    case invalidEvent
    case unknown(String)
}
```

## Permissions iOS

### Info.plist (si nécessaire)

Ajouter cette clé dans Info.plist pour expliquer l'utilisation du calendrier :

```xml
<key>NSCalendarsUsageDescription</key>
<string>Cette app utilise le calendrier pour créer et gérer vos événements.</string>
```

## Exemple Complet

Voir `CalendarServiceExample.swift` pour un exemple complet avec :
- Interface de demande de permissions
- Affichage des calendriers disponibles
- Création d'événements avec formulaire
- Liste des événements avec suppression
- Recherche d'événements
- Actions rapides

## États du Service

Le service expose plusieurs propriétés `@Published` pour l'interface :

```swift
@Published var authorizationStatus: CalendarAuthorizationStatus
@Published var calendars: [Calendar]
@Published var events: [CalendarEvent]
@Published var isLoading: Bool
@Published var errorMessage: String?
```

## Bonnes Pratiques

1. **Permissions** : Toujours vérifier les permissions avant les opérations
2. **Async/Await** : Utiliser les méthodes async pour éviter le blocage UI
3. **Gestion d'erreurs** : Implémenter une gestion d'erreur robuste
4. **Performance** : Limiter les requêtes de récupération d'événements
5. **UI** : Afficher des indicateurs de chargement pour les opérations longues

## Support et Dépendances

- **iOS 16.0+** (pour async/await complet)
- **EventKit.framework** (inclus dans iOS)
- **Combine** (pour les propriétés @Published)
- **SwiftUI** (pour l'exemple d'utilisation)

## Limitations

- Les événements supprimés d'autres apps peuvent ne pas être immédiatement reflétés
- Certains calendriers (comme les anniversaires) sont en lecture seule
- Les règles de récurrence complexes peuvent nécessiter des adaptations

---

*Cette documentation est mise à jour pour la version actuelle du CalendarService.*