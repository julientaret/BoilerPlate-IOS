//
//  BoilerplateApp.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

@main
struct BoilerplateApp: App {
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var localizationManager = LocalizationManager()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if coordinator.showSplash {
                    SplashView()
                        .transition(.opacity)
                        .zIndex(1)
                } else {
                    ContentView()
                        .transition(.opacity)
                        .localizedRoot() // Rerender complet lors du changement de langue
                }
            }
            .background(UITheme.Colors.background(for: themeManager.isDarkMode))
            .preferredColorScheme(themeManager.currentMode == .system ? nil : (themeManager.isDarkMode ? .dark : .light))
            .environmentObject(themeManager)
            .environmentObject(localizationManager)
            .onAppear {
                coordinator.dismissSplash()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                themeManager.updateForSystemChange()
            }
        }
    }
}
