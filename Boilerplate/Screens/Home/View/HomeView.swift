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
                    
                    // Quick Actions - Redesigned
                    VStack(spacing: UITheme.Spacing.lg) {
                        HStack {
                            VStack(alignment: .leading, spacing: UITheme.Spacing.xs) {
                                LocalizedText("quick_actions", module: "Navigation")
                                    .font(UITheme.Typography.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(UITheme.Colors.textPrimary(for: themeManager.isDarkMode))
                                
                                Text("Explore app features")
                                    .font(UITheme.Typography.caption)
                                    .foregroundColor(UITheme.Colors.textSecondary(for: themeManager.isDarkMode))
                            }
                            Spacer()
                        }
                        
                        // Main featured action
                        ModernQuickActionCard(
                            title: "Theme Studio",
                            description: "Customize your app appearance with beautiful themes",
                            icon: "paintbrush.pointed.fill",
                            gradientColors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                            isLarge: true
                        ) {
                            navigationManager.selectTab(.settings)
                        }
                        
                        // Secondary actions grid
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: UITheme.Spacing.md) {
                            ModernQuickActionCard(
                                title: "Profile",
                                description: "Manage account",
                                icon: "person.crop.circle.fill",
                                gradientColors: [Color(hex: "ffecd2"), Color(hex: "fcb69f")]
                            ) {
                                navigationManager.selectTab(.profile)
                            }
                            
                            ModernQuickActionCard(
                                title: "Settings",
                                description: "Preferences",
                                icon: "gearshape.fill",
                                gradientColors: [Color(hex: "a8edea"), Color(hex: "fed6e3")]
                            ) {
                                navigationManager.selectTab(.settings)
                            }
                        }
                        
                        // Bottom action
                        ModernQuickActionCard(
                            title: "UI Components",
                            description: "Explore the complete design system",
                            icon: "square.stack.3d.up.fill",
                            gradientColors: [Color(hex: "fad0c4"), Color(hex: "ffd1ff")],
                            isHorizontal: true
                        ) {
                            navigationManager.selectTab(.library)
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

struct ModernQuickActionCard: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.colorScheme) var colorScheme
    
    let title: String
    let description: String
    let icon: String
    let gradientColors: [Color]
    let isLarge: Bool
    let isHorizontal: Bool
    let action: () -> Void
    
    init(
        title: String,
        description: String,
        icon: String,
        gradientColors: [Color],
        isLarge: Bool = false,
        isHorizontal: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.description = description
        self.icon = icon
        self.gradientColors = gradientColors
        self.isLarge = isLarge
        self.isHorizontal = isHorizontal
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            if isHorizontal {
                horizontalLayout
            } else {
                verticalLayout
            }
        }
        .buttonStyle(ModernCardButtonStyle())
    }
    
    @ViewBuilder
    private var verticalLayout: some View {
        VStack(spacing: isLarge ? UITheme.Spacing.md : UITheme.Spacing.sm) {
            // Icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: adjustedGradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: isLarge ? 60 : 44, height: isLarge ? 60 : 44)
                    .shadow(
                        color: gradientColors.first?.opacity(0.3) ?? .clear,
                        radius: isLarge ? 8 : 6,
                        x: 0,
                        y: 4
                    )
                
                Image(systemName: icon)
                    .font(.system(size: isLarge ? 26 : 20, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: UITheme.Spacing.xs) {
                Text(title)
                    .font(isLarge ? UITheme.Typography.title3 : UITheme.Typography.headline)
                    .fontWeight(.bold)
                    .foregroundColor(UITheme.Colors.textPrimary(for: themeManager.isDarkMode))
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(isLarge ? UITheme.Typography.body : UITheme.Typography.caption)
                    .foregroundColor(UITheme.Colors.textSecondary(for: themeManager.isDarkMode))
                    .multilineTextAlignment(.center)
                    .lineLimit(isLarge ? 3 : 2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(isLarge ? UITheme.Spacing.lg : UITheme.Spacing.md)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: isLarge ? UITheme.CornerRadius.large : UITheme.CornerRadius.medium))
    }
    
    @ViewBuilder
    private var horizontalLayout: some View {
        HStack(spacing: UITheme.Spacing.md) {
            // Icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: adjustedGradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .shadow(
                        color: gradientColors.first?.opacity(0.3) ?? .clear,
                        radius: 6,
                        x: 0,
                        y: 3
                    )
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: UITheme.Spacing.xs) {
                Text(title)
                    .font(UITheme.Typography.headline)
                    .fontWeight(.bold)
                    .foregroundColor(UITheme.Colors.textPrimary(for: themeManager.isDarkMode))
                
                Text(description)
                    .font(UITheme.Typography.caption)
                    .foregroundColor(UITheme.Colors.textSecondary(for: themeManager.isDarkMode))
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "arrow.right.circle.fill")
                .font(.title3)
                .foregroundColor(UITheme.Colors.textSecondary(for: themeManager.isDarkMode))
        }
        .padding(UITheme.Spacing.md)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: UITheme.CornerRadius.medium))
    }
    
    private var adjustedGradientColors: [Color] {
        if colorScheme == .dark {
            return gradientColors.map { color in
                Color(
                    red: min(1.0, color.cgColor?.components?[0] ?? 0 + 0.2),
                    green: min(1.0, color.cgColor?.components?[1] ?? 0 + 0.2),
                    blue: min(1.0, color.cgColor?.components?[2] ?? 0 + 0.2)
                )
            }
        }
        return gradientColors
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: isLarge ? UITheme.CornerRadius.large : UITheme.CornerRadius.medium)
            .fill(UITheme.Colors.surface(for: themeManager.isDarkMode))
            .overlay(
                RoundedRectangle(cornerRadius: isLarge ? UITheme.CornerRadius.large : UITheme.CornerRadius.medium)
                    .stroke(
                        LinearGradient(
                            colors: adjustedGradientColors.map { $0.opacity(0.3) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: UITheme.Colors.textPrimary(for: themeManager.isDarkMode).opacity(0.1),
                radius: isLarge ? 12 : 8,
                x: 0,
                y: isLarge ? 6 : 4
            )
    }
}

struct ModernCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// Legacy component for compatibility
struct QuickActionCard: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    let title: String
    let description: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        ModernQuickActionCard(
            title: title,
            description: description,
            icon: icon,
            gradientColors: [color, color.opacity(0.7)],
            action: action
        )
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