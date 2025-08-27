//
//  LanguageSelector.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

struct LanguageSelector: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: UITheme.Spacing.sm) {
            HStack {
                Label {
                    LocalizedText("language", module: "Navigation")
                } icon: {
                    Image(systemName: "globe")
                }
                .foregroundColor(UITheme.Colors.textPrimary(for: themeManager.isDarkMode))
                .font(UITheme.Typography.headline)
                
                Spacer()
            }
            
            HStack(spacing: 0) {
                ForEach(SupportedLanguage.allCases, id: \.self) { language in
                    VStack(spacing: UITheme.Spacing.xs) {
                        Text(language.flag)
                            .font(.title2)
                        Text(language.displayName)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(
                        localizationManager.currentLanguage == language 
                            ? .white 
                            : UITheme.Colors.textPrimary(for: themeManager.isDarkMode)
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, UITheme.Spacing.sm)
                    .background(
                        localizationManager.currentLanguage == language 
                            ? UITheme.Colors.primary(for: themeManager.isDarkMode)
                            : Color.clear
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        localizationManager.setLanguage(language)
                    }
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
        .animation(.easeInOut(duration: 0.3), value: localizationManager.currentLanguage)
    }
}

struct CompactLanguageSelector: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: UITheme.Spacing.md) {
            Image(systemName: "globe")
                .foregroundColor(UITheme.Colors.textSecondary(for: themeManager.isDarkMode))
            
            Picker(localizationManager.localized("language", module: "Navigation"), selection: $localizationManager.currentLanguage) {
                ForEach(SupportedLanguage.allCases, id: \.self) { language in
                    HStack {
                        Text(language.flag)
                        Text(language.displayName)
                    }
                    .tag(language)
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
        .animation(.easeInOut(duration: 0.3), value: localizationManager.currentLanguage)
    }
}

struct SimpleLanguageToggle: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: toggleLanguage) {
            HStack(spacing: UITheme.Spacing.xs) {
                Text(localizationManager.currentLanguage.flag)
                    .font(.title3)
                Text(localizationManager.currentLanguage.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(UITheme.Colors.primary(for: themeManager.isDarkMode))
            .padding(.horizontal, UITheme.Spacing.sm)
            .padding(.vertical, UITheme.Spacing.xs)
            .background(
                RoundedRectangle(cornerRadius: UITheme.CornerRadius.small)
                    .fill(UITheme.Colors.surface(for: themeManager.isDarkMode))
            )
            .overlay(
                RoundedRectangle(cornerRadius: UITheme.CornerRadius.small)
                    .stroke(UITheme.Colors.outline(for: themeManager.isDarkMode), lineWidth: 1)
            )
        }
        .animation(.easeInOut(duration: 0.3), value: localizationManager.currentLanguage)
    }
    
    private func toggleLanguage() {
        let languages = SupportedLanguage.allCases
        guard let currentIndex = languages.firstIndex(of: localizationManager.currentLanguage) else { return }
        let nextIndex = (currentIndex + 1) % languages.count
        localizationManager.setLanguage(languages[nextIndex])
    }
}

// MARK: - Menu Version for Navigation Bars
struct LanguageMenu: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Menu {
            ForEach(SupportedLanguage.allCases, id: \.self) { language in
                Button(action: {
                    localizationManager.setLanguage(language)
                }) {
                    HStack {
                        Text(language.flag)
                        Text(language.displayName)
                        if localizationManager.currentLanguage == language {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: UITheme.Spacing.xs) {
                Image(systemName: "globe")
                Text(localizationManager.currentLanguage.flag)
            }
            .foregroundColor(UITheme.Colors.primary(for: themeManager.isDarkMode))
        }
    }
}

#Preview("Language Selectors") {
    VStack(spacing: 20) {
        Text("Sélecteurs de langue")
            .font(.title2)
            .fontWeight(.bold)
        
        LanguageSelector()
        
        CompactLanguageSelector()
        
        HStack {
            Text("Toggle simple:")
            Spacer()
            SimpleLanguageToggle()
        }
        .padding()
        
        HStack {
            Text("Menu:")
            Spacer()
            LanguageMenu()
        }
        .padding()
    }
    .padding()
    .background(Color(.systemGroupedBackground))
    .environmentObject(LocalizationManager())
    .environmentObject(ThemeManager())
}