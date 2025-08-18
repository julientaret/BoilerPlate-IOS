//
//  TabView.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            // Content
            VStack(spacing: 0) {
                Group {
                    switch navigationManager.selectedTab {
                    case .home:
                        HomeView()
                    case .library:
                        UILibraryShowcase()
                    case .settings:
                        SettingsView()
                    case .profile:
                        ProfileView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Bottom Navigation Bar
                BottomNavBar()
            }
        }
        .background(UITheme.Colors.background(for: themeManager.isDarkMode))
    }
}

#Preview {
    MainTabView()
        .environmentObject(NavigationManager())
        .environmentObject(ThemeManager())
        .environmentObject(LocalizationManager())
}