//
//  HomeView.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: UITheme.Spacing.xl) {
                    
                    // Header Section
                    VStack(spacing: UITheme.Spacing.md) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 60))
                            .foregroundColor(UITheme.Colors.primary(for: themeManager.isDarkMode))
                        
                        LocalizedText("welcome", module: "Messages")
                            .font(UITheme.Typography.title1)
                            .foregroundColor(UITheme.Colors.textPrimary(for: themeManager.isDarkMode))
                        
                        LocalizedText("app_description", module: "Common")
                            .font(UITheme.Typography.body)
                            .foregroundColor(UITheme.Colors.textSecondary(for: themeManager.isDarkMode))
                            .multilineTextAlignment(.center)
                    }
                    
                    // Quick Actions
                    VStack(spacing: UITheme.Spacing.md) {
                        LocalizedText("quick_actions", module: "Navigation")
                            .font(UITheme.Typography.headline)
                            .foregroundColor(UITheme.Colors.textPrimary(for: themeManager.isDarkMode))
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: UITheme.Spacing.md) {
                            QuickActionCard(
                                title: "Theme",
                                description: "Customize appearance",
                                icon: "paintbrush.fill",
                                color: UITheme.Colors.primary(for: themeManager.isDarkMode)
                            ) {
                                navigationManager.selectTab(.settings)
                            }
                            
                            QuickActionCard(
                                title: "Profile",
                                description: "Manage account",
                                icon: "person.fill",
                                color: UITheme.Colors.secondary(for: themeManager.isDarkMode)
                            ) {
                                navigationManager.selectTab(.profile)
                            }
                            
                            QuickActionCard(
                                title: "Settings",
                                description: "App preferences",
                                icon: "gear.circle.fill",
                                color: UITheme.Colors.success
                            ) {
                                navigationManager.selectTab(.settings)
                            }
                            
                            QuickActionCard(
                                title: "UI Library",
                                description: "Component showcase",
                                icon: "book.fill",
                                color: UITheme.Colors.error
                            ) {
                                navigationManager.selectTab(.library)
                            }
                        }
                    }
                    
                    // Recent Activity
                    VStack(alignment: .leading, spacing: UITheme.Spacing.md) {
                        LocalizedText("recent_activity", module: "Common")
                            .font(UITheme.Typography.headline)
                            .foregroundColor(UITheme.Colors.textPrimary(for: themeManager.isDarkMode))
                        
                        VStack(spacing: UITheme.Spacing.sm) {
                            ActivityItem(
                                title: "Theme changed to Dark Mode",
                                timestamp: "2 minutes ago",
                                icon: "moon.fill"
                            )
                            
                            ActivityItem(
                                title: "Language switched to French",
                                timestamp: "1 hour ago",
                                icon: "globe"
                            )
                            
                            ActivityItem(
                                title: "Profile updated",
                                timestamp: "3 hours ago",
                                icon: "person.fill"
                            )
                        }
                    }
                }
                .padding(UITheme.Spacing.lg)
            }
            .background(ThemeAwareBackground())
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct QuickActionCard: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    let title: String
    let description: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: UITheme.Spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                
                VStack(spacing: UITheme.Spacing.xs) {
                    Text(title)
                        .font(UITheme.Typography.headline)
                        .foregroundColor(UITheme.Colors.textPrimary(for: themeManager.isDarkMode))
                    
                    Text(description)
                        .font(UITheme.Typography.caption)
                        .foregroundColor(UITheme.Colors.textSecondary(for: themeManager.isDarkMode))
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(UITheme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: UITheme.CornerRadius.medium)
                    .fill(UITheme.Colors.surface(for: themeManager.isDarkMode))
            )
            .overlay(
                RoundedRectangle(cornerRadius: UITheme.CornerRadius.medium)
                    .stroke(UITheme.Colors.outline(for: themeManager.isDarkMode).opacity(0.5), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ActivityItem: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    let title: String
    let timestamp: String
    let icon: String
    
    var body: some View {
        HStack(spacing: UITheme.Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(UITheme.Colors.primary(for: themeManager.isDarkMode))
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: UITheme.Spacing.xs) {
                Text(title)
                    .font(UITheme.Typography.body)
                    .foregroundColor(UITheme.Colors.textPrimary(for: themeManager.isDarkMode))
                
                Text(timestamp)
                    .font(UITheme.Typography.caption)
                    .foregroundColor(UITheme.Colors.textSecondary(for: themeManager.isDarkMode))
            }
            
            Spacer()
        }
        .padding(UITheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: UITheme.CornerRadius.medium)
                .fill(UITheme.Colors.surface(for: themeManager.isDarkMode))
        )
    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationManager())
        .environmentObject(ThemeManager())
        .environmentObject(LocalizationManager())
}