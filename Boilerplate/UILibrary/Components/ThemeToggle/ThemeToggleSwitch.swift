//
//  ThemeToggleSwitch.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

struct ThemeToggleSwitch: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: UITheme.Spacing.sm) {
            HStack {
                Label("Thème", systemImage: "paintbrush.fill")
                    .foregroundColor(UITheme.Colors.textPrimary(for: themeManager.isDarkMode))
                    .font(UITheme.Typography.headline)
                
                Spacer()
            }
            
            HStack(spacing: 0) {
                ForEach(ThemeMode.allCases, id: \.self) { mode in
                    Button(action: {
                        themeManager.setTheme(mode)
                    }) {
                        VStack(spacing: UITheme.Spacing.xs) {
                            Image(systemName: iconForMode(mode))
                                .font(.title3)
                            Text(mode.displayName)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(
                            themeManager.currentMode == mode 
                                ? .white 
                                : UITheme.Colors.textPrimary(for: themeManager.isDarkMode)
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, UITheme.Spacing.sm)
                        .background(
                            themeManager.currentMode == mode 
                                ? UITheme.Colors.primary(for: themeManager.isDarkMode)
                                : Color.clear
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .background(
                RoundedRectangle(cornerRadius: UITheme.CornerRadius.medium)
                    .fill(UITheme.Colors.surface(for: themeManager.isDarkMode))
            )
            .overlay(
                RoundedRectangle(cornerRadius: UITheme.CornerRadius.medium)
                    .stroke(UITheme.Colors.outline(for: themeManager.isDarkMode), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: UITheme.CornerRadius.medium))
        }
        .padding(UITheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: UITheme.CornerRadius.large)
                .fill(UITheme.Colors.background(for: themeManager.isDarkMode))
        )
        .overlay(
            RoundedRectangle(cornerRadius: UITheme.CornerRadius.large)
                .stroke(UITheme.Colors.outline(for: themeManager.isDarkMode).opacity(0.5), lineWidth: 1)
        )
        .animation(UITheme.Animation.medium, value: themeManager.currentMode)
    }
    
    private func iconForMode(_ mode: ThemeMode) -> String {
        switch mode {
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        case .system:
            return "gear"
        }
    }
}

struct SimpleThemeToggle: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: toggleTheme) {
            Image(systemName: themeManager.isDarkMode ? "sun.max.fill" : "moon.fill")
                .font(.title2)
                .foregroundColor(UITheme.Colors.primary(for: themeManager.isDarkMode))
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(UITheme.Colors.surface(for: themeManager.isDarkMode))
                )
                .overlay(
                    Circle()
                        .stroke(UITheme.Colors.outline(for: themeManager.isDarkMode), lineWidth: 1)
                )
        }
        .animation(UITheme.Animation.medium, value: themeManager.isDarkMode)
    }
    
    private func toggleTheme() {
        let newMode: ThemeMode = themeManager.isDarkMode ? .light : .dark
        themeManager.setTheme(newMode)
    }
}

struct CompactThemeSelector: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: UITheme.Spacing.md) {
            Image(systemName: "paintbrush.fill")
                .foregroundColor(UITheme.Colors.textSecondary(for: themeManager.isDarkMode))
            
            Picker("Thème", selection: $themeManager.currentMode) {
                ForEach(ThemeMode.allCases, id: \.self) { mode in
                    Text(mode.displayName).tag(mode)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(UITheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: UITheme.CornerRadius.medium)
                .fill(UITheme.Colors.surface(for: themeManager.isDarkMode))
        )
        .overlay(
            RoundedRectangle(cornerRadius: UITheme.CornerRadius.medium)
                .stroke(UITheme.Colors.outline(for: themeManager.isDarkMode), lineWidth: 1)
        )
        .animation(UITheme.Animation.medium, value: themeManager.currentMode)
    }
}

#Preview("Theme Toggle Switch") {
    VStack(spacing: 20) {
        Text("Sélecteurs de thème")
            .font(.title2)
            .fontWeight(.bold)
        
        ThemeToggleSwitch()
        
        CompactThemeSelector()
        
        HStack {
            Text("Toggle simple:")
            Spacer()
            SimpleThemeToggle()
        }
        .padding()
    }
    .padding()
    .background(Color(.systemGroupedBackground))
    .environmentObject(ThemeManager())
}