//
//  ThemeManager.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI
import Combine

enum ThemeMode: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    case system = "system"
    
    var displayName: String {
        switch self {
        case .light:
            return "Clair"
        case .dark:
            return "Sombre"
        case .system:
            return "Auto"
        }
    }
}

class ThemeManager: ObservableObject {
    @Published var currentMode: ThemeMode = .system {
        didSet {
            UserDefaults.standard.set(currentMode.rawValue, forKey: "theme_mode")
            updateIsDarkMode()
        }
    }
    
    @Published var isDarkMode: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Charger le thème sauvegardé
        if let savedTheme = UserDefaults.standard.string(forKey: "theme_mode"),
           let themeMode = ThemeMode(rawValue: savedTheme) {
            currentMode = themeMode
        }
        
        // Mettre à jour immédiatement
        updateIsDarkMode()
        
        // Écouter les changements de colorScheme
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                self?.updateForSystemChange()
            }
            .store(in: &cancellables)
    }
    
    func setTheme(_ mode: ThemeMode) {
        withAnimation(UITheme.Animation.medium) {
            currentMode = mode
        }
    }
    
    private func updateIsDarkMode() {
        let newIsDarkMode: Bool
        
        switch currentMode {
        case .light:
            newIsDarkMode = false
        case .dark:
            newIsDarkMode = true
        case .system:
            newIsDarkMode = UITraitCollection.current.userInterfaceStyle == .dark
        }
        
        if newIsDarkMode != isDarkMode {
            isDarkMode = newIsDarkMode
        }
    }
    
    func updateForSystemChange() {
        if currentMode == .system {
            updateIsDarkMode()
        }
    }
}