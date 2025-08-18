//
//  ContentView.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: UITheme.Spacing.lg) {
                
                // Header Section
                VStack(spacing: UITheme.Spacing.md) {
                    Image(systemName: "paintbrush.pointed.fill")
                        .font(.system(size: 60))
                        .foregroundColor(UITheme.Colors.primary(for: themeManager.isDarkMode))
                    
                    Text("Theme Manager")
                        .font(UITheme.Typography.title1)
                        .foregroundColor(UITheme.Colors.textPrimary(for: themeManager.isDarkMode))
                    
                    Text("Bascule entre les thèmes clair et sombre")
                        .font(UITheme.Typography.body)
                        .foregroundColor(UITheme.Colors.textSecondary(for: themeManager.isDarkMode))
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                // Theme Toggle Section
                VStack(spacing: UITheme.Spacing.lg) {
                    ThemeToggleSwitch()
                    
                    CompactThemeSelector()
                    
                    HStack(spacing: UITheme.Spacing.md) {
                        Text("Toggle rapide:")
                            .foregroundColor(UITheme.Colors.textSecondary(for: themeManager.isDarkMode))
                        
                        Spacer()
                        
                        SimpleThemeToggle()
                    }
                    .padding(.horizontal, UITheme.Spacing.md)
                }
                
                Spacer()
                
                // Demo Cards
                VStack(spacing: UITheme.Spacing.md) {
                    Text("Aperçu des couleurs")
                        .font(UITheme.Typography.headline)
                        .foregroundColor(UITheme.Colors.textPrimary(for: themeManager.isDarkMode))
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: UITheme.Spacing.sm) {
                        ColorPreviewCard(title: "Primary", color: UITheme.Colors.primary(for: themeManager.isDarkMode))
                        ColorPreviewCard(title: "Secondary", color: UITheme.Colors.secondary(for: themeManager.isDarkMode))
                        ColorPreviewCard(title: "Success", color: UITheme.Colors.success)
                        ColorPreviewCard(title: "Error", color: UITheme.Colors.error)
                    }
                }
                
                Spacer()
            }
            .padding(UITheme.Spacing.lg)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(UITheme.Colors.background(for: themeManager.isDarkMode))
            .navigationTitle("Boilerplate")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ColorPreviewCard: View {
    let title: String
    let color: Color
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: UITheme.Spacing.xs) {
            RoundedRectangle(cornerRadius: UITheme.CornerRadius.medium)
                .fill(color)
                .frame(height: 40)
            
            Text(title)
                .font(UITheme.Typography.caption)
                .foregroundColor(UITheme.Colors.textSecondary(for: themeManager.isDarkMode))
        }
        .padding(UITheme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: UITheme.CornerRadius.medium)
                .fill(UITheme.Colors.surface(for: themeManager.isDarkMode))
        )
        .overlay(
            RoundedRectangle(cornerRadius: UITheme.CornerRadius.medium)
                .stroke(UITheme.Colors.outline(for: themeManager.isDarkMode), lineWidth: 1)
        )
    }
}

#Preview {
    ContentView()
}
