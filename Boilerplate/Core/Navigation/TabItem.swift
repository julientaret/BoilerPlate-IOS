//
//  TabItem.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

enum TabItem: String, CaseIterable, Identifiable {
    case home = "home"
    case settings = "settings"
    case profile = "profile"
    case library = "library"
    
    var id: String { rawValue }
    
    var title: LocalizedString {
        switch self {
        case .home:
            return LocalizedString("home", module: "Navigation")
        case .settings:
            return LocalizedString("settings", module: "Navigation")
        case .profile:
            return LocalizedString("profile", module: "Navigation")
        case .library:
            return LocalizedString("library", module: "Navigation")
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house"
        case .settings:
            return "gear"
        case .profile:
            return "person"
        case .library:
            return "book"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .home:
            return "house.fill"
        case .settings:
            return "gear.circle.fill"
        case .profile:
            return "person.fill"
        case .library:
            return "book.fill"
        }
    }
}