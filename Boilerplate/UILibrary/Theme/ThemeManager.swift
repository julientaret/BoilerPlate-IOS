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
    
    var localizedKey: String {
        switch self {
        case .light:
            return "light"
        case .dark:
            return "dark"
        case .system:
            return "auto"
        }
    }
}

// MARK: - Environment-aware Theme Mode Display
struct ThemeModeText: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    let mode: ThemeMode
    
    var body: some View {
        Text(localizationManager.localized(mode.localizedKey, module: "Theme"))
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
        // Load saved theme
        if let savedTheme = UserDefaults.standard.string(forKey: "theme_mode"),
           let themeMode = ThemeMode(rawValue: savedTheme) {
            currentMode = themeMode
        }
        
        // Update immediately
        updateIsDarkMode()
        
        // Listen to colorScheme changes
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