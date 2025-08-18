//
//  BottomNavBar.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

struct BottomNavBar: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(UITheme.Colors.outline(for: themeManager.isDarkMode))
            
            HStack {
                ForEach(TabItem.allCases) { tab in
                    TabBarItem(
                        tab: tab,
                        isSelected: navigationManager.selectedTab == tab
                    ) {
                        withAnimation(UITheme.Animation.fast) {
                            navigationManager.selectTab(tab)
                        }
                    }
                }
            }
            .padding(.horizontal, UITheme.Spacing.md)
            .padding(.vertical, UITheme.Spacing.sm)
            .background(
                UITheme.Colors.surface(for: themeManager.isDarkMode)
                    .ignoresSafeArea(.container, edges: .bottom)
            )
        }
    }
}

struct TabBarItem: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: UITheme.Spacing.xs) {
                Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                    .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(
                        isSelected 
                            ? UITheme.Colors.primary(for: themeManager.isDarkMode)
                            : UITheme.Colors.textSecondary(for: themeManager.isDarkMode)
                    )
                
                Text(localizationManager.localized(tab.title.key, module: tab.title.module))
                    .font(UITheme.Typography.caption2)
                    .foregroundColor(
                        isSelected 
                            ? UITheme.Colors.primary(for: themeManager.isDarkMode)
                            : UITheme.Colors.textSecondary(for: themeManager.isDarkMode)
                    )
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, UITheme.Spacing.xs)
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(UITheme.Animation.fast, value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        Spacer()
        BottomNavBar()
    }
    .environmentObject(NavigationManager())
    .environmentObject(ThemeManager())
    .environmentObject(LocalizationManager())
}