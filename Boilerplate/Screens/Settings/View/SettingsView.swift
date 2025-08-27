//
//  SettingsView.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: UITheme.Spacing.lg) {
                    
                    // Appearance Section
                    SettingsSection(title: "Appearance") {
                        ThemeToggleSwitch()
                    }
                    
                    // Language Section  
                    SettingsSection(title: "Language") {
                        LanguageSelector()
                    }
                    
                    // General Section
                    SettingsSection(title: "General") {
                        VStack(spacing: UITheme.Spacing.sm) {
                            SettingsRow(
                                title: "Notifications",
                                subtitle: "Manage push notifications",
                                icon: "bell.fill",
                                isToggle: true,
                                toggleValue: .constant(true)
                            )
                            
                            SettingsRow(
                                title: "Auto-sync",
                                subtitle: "Sync data automatically",
                                icon: "arrow.clockwise.circle.fill",
                                isToggle: true,
                                toggleValue: .constant(false)
                            )
                            
                            SettingsRow(
                                title: "Cache Management",
                                subtitle: "Clear app cache",
                                icon: "externaldrive.fill"
                            )
                        }
                    }
                    
                    // Privacy & Security Section
                    SettingsSection(title: "Privacy & Security") {
                        VStack(spacing: UITheme.Spacing.sm) {
                            SettingsRow(
                                title: "Face ID / Touch ID",
                                subtitle: "Use biometric authentication",
                                icon: "faceid",
                                isToggle: true,
                                toggleValue: .constant(true)
                            )
                            
                            SettingsRow(
                                title: "Data Collection",
                                subtitle: "Analytics and crash reports",
                                icon: "chart.bar.fill",
                                isToggle: true,
                                toggleValue: .constant(false)
                            )
                            
                            SettingsRow(
                                title: "Privacy Policy",
                                subtitle: "View privacy policy",
                                icon: "doc.text.fill"
                            )
                        }
                    }
                    
                    // Support Section
                    SettingsSection(title: "Support") {
                        VStack(spacing: UITheme.Spacing.sm) {
                            SettingsRow(
                                title: "Help Center",
                                subtitle: "Get help and support",
                                icon: "questionmark.circle.fill"
                            )
                            
                            SettingsRow(
                                title: "Contact Support",
                                subtitle: "Send feedback or report issues",
                                icon: "envelope.fill"
                            )
                            
                            SettingsRow(
                                title: "Rate App",
                                subtitle: "Rate us on the App Store",
                                icon: "star.fill"
                            )
                        }
                    }
                    
                    // About Section
                    SettingsSection(title: "About") {
                        VStack(spacing: UITheme.Spacing.sm) {
                            SettingsRow(
                                title: "Version",
                                subtitle: "1.0.0 (Build 1)",
                                icon: "info.circle.fill",
                                showChevron: false
                            )
                            
                            SettingsRow(
                                title: "Terms of Service",
                                subtitle: "View terms and conditions",
                                icon: "doc.fill"
                            )
                            
                            SettingsRow(
                                title: "Licenses",
                                subtitle: "Third-party licenses",
                                icon: "book.fill"
                            )
                        }
                    }
                }
                .padding(UITheme.Spacing.lg)
            }
            .background(ThemeAwareBackground())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct SettingsSection<Content: View>: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: UITheme.Spacing.md) {
            HStack {
                Text(title)
                    .font(UITheme.Typography.headline)
                    .foregroundColor(UITheme.Colors.textPrimary(for: themeManager.isDarkMode))
                Spacer()
            }
            
            content
        }
    }
}

struct SettingsRow: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    let title: String
    let subtitle: String
    let icon: String
    let isToggle: Bool
    let toggleValue: Binding<Bool>
    let showChevron: Bool
    
    init(
        title: String,
        subtitle: String,
        icon: String,
        isToggle: Bool = false,
        toggleValue: Binding<Bool> = .constant(false),
        showChevron: Bool = true
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.isToggle = isToggle
        self.toggleValue = toggleValue
        self.showChevron = showChevron
    }
    
    var body: some View {
        Button(action: isToggle ? {} : {}) {
            HStack(spacing: UITheme.Spacing.md) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(UITheme.Colors.primary(for: themeManager.isDarkMode))
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: UITheme.Spacing.xs) {
                    Text(title)
                        .font(UITheme.Typography.body)
                        .foregroundColor(UITheme.Colors.textPrimary(for: themeManager.isDarkMode))
                    
                    Text(subtitle)
                        .font(UITheme.Typography.caption)
                        .foregroundColor(UITheme.Colors.textSecondary(for: themeManager.isDarkMode))
                }
                
                Spacer()
                
                if isToggle {
                    Toggle("", isOn: toggleValue)
                        .labelsHidden()
                } else if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(UITheme.Colors.textSecondary(for: themeManager.isDarkMode))
                }
            }
            .padding(UITheme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: UITheme.CornerRadius.medium)
                    .fill(UITheme.Colors.surface(for: themeManager.isDarkMode))
            )
            .overlay(
                RoundedRectangle(cornerRadius: UITheme.CornerRadius.medium)
                    .stroke(UITheme.Colors.outline(for: themeManager.isDarkMode).opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isToggle)
    }
}

#Preview {
    SettingsView()
        .environmentObject(ThemeManager())
        .environmentObject(LocalizationManager())
}