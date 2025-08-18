//
//  LocalizationManager.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI
import Foundation

enum SupportedLanguage: String, CaseIterable {
    case french = "fr"
    case english = "en"
    case spanish = "es"
    
    var displayName: String {
        switch self {
        case .french:
            return "Français"
        case .english:
            return "English"
        case .spanish:
            return "Español"
        }
    }
    
    var flag: String {
        switch self {
        case .french:
            return "🇫🇷"
        case .english:
            return "🇬🇧"
        case .spanish:
            return "🇪🇸"
        }
    }
}

class LocalizationManager: ObservableObject {
    @Published var currentLanguage: SupportedLanguage = .french {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "selected_language")
            loadLocalizations()
            // Force UI update immédiatement
            forceUIUpdate()
        }
    }
    
    // Propriété pour forcer le rerender de l'UI
    @Published private(set) var uiUpdateTrigger: UUID = UUID()
    
    private var localizations: [String: [String: String]] = [:]
    
    init() {
        // Charger la langue sauvegardée ou détecter la langue système
        if let savedLanguage = UserDefaults.standard.string(forKey: "selected_language"),
           let language = SupportedLanguage(rawValue: savedLanguage) {
            currentLanguage = language
        } else {
            // Détecter la langue système
            let systemLanguage = Locale.current.language.languageCode?.identifier ?? "fr"
            currentLanguage = SupportedLanguage(rawValue: systemLanguage) ?? .french
        }
        
        loadLocalizations()
    }
    
    func setLanguage(_ language: SupportedLanguage) {
        // Animation fluide pour le changement de langue
        withAnimation(.easeInOut(duration: 0.3)) {
            currentLanguage = language
        }
    }
    
    private func forceUIUpdate() {
        DispatchQueue.main.async {
            self.uiUpdateTrigger = UUID()
            self.objectWillChange.send()
        }
    }
    
    private func loadLocalizations() {
        // Charger toutes les localisations pour la langue courante
        localizations.removeAll()
        
        let modules = [
            "Common",
            "Theme", 
            "Navigation",
            "Buttons",
            "Forms",
            "Messages"
        ]
        
        for module in modules {
            loadModuleLocalizations(module: module)
        }
    }
    
    private func loadModuleLocalizations(module: String) {
        guard let path = Bundle.main.path(forResource: "\(module)_\(currentLanguage.rawValue)", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: String] else {
            print("⚠️ Could not load \(module)_\(currentLanguage.rawValue).json")
            return
        }
        
        localizations[module] = json
    }
    
    func localized(_ key: String, module: String = "Common") -> String {
        return localizations[module]?[key] ?? key
    }
    
    func localizedFormatted(_ key: String, module: String = "Common", _ arguments: CVarArg...) -> String {
        let template = localized(key, module: module)
        return String(format: template, arguments)
    }
}

// MARK: - Helper Extensions
extension LocalizationManager {
    static let shared = LocalizationManager()
}

// MARK: - SwiftUI Environment Key
struct LocalizationManagerKey: EnvironmentKey {
    static let defaultValue = LocalizationManager.shared
}

extension EnvironmentValues {
    var localizationManager: LocalizationManager {
        get { self[LocalizationManagerKey.self] }
        set { self[LocalizationManagerKey.self] = newValue }
    }
}