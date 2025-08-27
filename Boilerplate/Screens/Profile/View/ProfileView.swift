//
//  ProfileView.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    @State private var username = "John Doe"
    @State private var email = "john.doe@example.com"
    @State private var showEditProfile = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: UITheme.Spacing.xl) {
                    
                    // Profile Header
                    VStack(spacing: UITheme.Spacing.lg) {
                        // Avatar
                        ZStack {
                            Circle()
                                .fill(UITheme.Colors.primary(for: themeManager.isDarkMode))
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: "person.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                        }
                        
                        // User Info
                        VStack(spacing: UITheme.Spacing.sm) {
                            Text(username)
                                .font(UITheme.Typography.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(UITheme.Colors.textPrimary(for: themeManager.isDarkMode))
                            
                            Text(email)
                                .font(UITheme.Typography.body)
                                .foregroundColor(UITheme.Colors.textSecondary(for: themeManager.isDarkMode))
                        }
                        
                        // Edit Profile Button
                        UIButton(title: "Edit Profile", style: .secondary, size: .medium, icon: "pencil") {
                            showEditProfile = true
                        }
                    }
                    
                    // Stats Section
                    UICard(style: .elevated) {
                        VStack(spacing: UITheme.Spacing.md) {
                            Text("Statistics")
                                .font(UITheme.Typography.headline)
                                .foregroundColor(UITheme.Colors.textPrimary(for: themeManager.isDarkMode))
                            
                            HStack {
                                StatItem(title: "Sessions", value: "42", icon: "clock.fill")
                                
                                Divider()
                                    .frame(height: 40)
                                
                                StatItem(title: "Days Active", value: "12", icon: "calendar.fill")
                                
                                Divider()
                                    .frame(height: 40)
                                
                                StatItem(title: "Themes", value: "3", icon: "paintbrush.fill")
                            }
                        }
                    }
                    
                    // Preferences Section
                    VStack(spacing: UITheme.Spacing.md) {
                        HStack {
                            Text("Preferences")
                                .font(UITheme.Typography.headline)
                                .foregroundColor(UITheme.Colors.textPrimary(for: themeManager.isDarkMode))
                            Spacer()
                        }
                        
                        VStack(spacing: UITheme.Spacing.sm) {
                            PreferenceRow(
                                title: "Notifications",
                                subtitle: "Manage app notifications",
                                icon: "bell.fill",
                                isToggle: true,
                                toggleValue: .constant(true)
                            )
                            
                            PreferenceRow(
                                title: "Privacy",
                                subtitle: "Data and privacy settings",
                                icon: "lock.fill"
                            )
                            
                            PreferenceRow(
                                title: "About",
                                subtitle: "App version and information",
                                icon: "info.circle.fill"
                            )
                        }
                    }
                    
                    // Account Actions
                    VStack(spacing: UITheme.Spacing.sm) {
                        UIButton(title: "Export Data", style: .tertiary, size: .large, icon: "square.and.arrow.up") {}
                        
                        UIButton(title: "Sign Out", style: .destructive, size: .large, icon: "arrow.right.square") {}
                    }
                }
                .padding(UITheme.Spacing.lg)
            }
            .background(UITheme.Colors.background(for: themeManager.isDarkMode))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showEditProfile) {
            EditProfileView(username: $username, email: $email, isPresented: $showEditProfile)
        }
    }
}

struct StatItem: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: UITheme.Spacing.xs) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(UITheme.Colors.primary(for: themeManager.isDarkMode))
            
            Text(value)
                .font(UITheme.Typography.title2)
                .fontWeight(.bold)
                .foregroundColor(UITheme.Colors.textPrimary(for: themeManager.isDarkMode))
            
            Text(title)
                .font(UITheme.Typography.caption)
                .foregroundColor(UITheme.Colors.textSecondary(for: themeManager.isDarkMode))
        }
        .frame(maxWidth: .infinity)
    }
}

struct PreferenceRow: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    let title: String
    let subtitle: String
    let icon: String
    let isToggle: Bool
    let toggleValue: Binding<Bool>
    
    init(title: String, subtitle: String, icon: String, isToggle: Bool = false, toggleValue: Binding<Bool> = .constant(false)) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.isToggle = isToggle
        self.toggleValue = toggleValue
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
                } else {
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
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isToggle)
    }
}

struct EditProfileView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding var username: String
    @Binding var email: String
    @Binding var isPresented: Bool
    
    @State private var tempUsername: String = ""
    @State private var tempEmail: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: UITheme.Spacing.lg) {
                UITextField(
                    text: $tempUsername,
                    placeholder: "Full Name",
                    label: "Full Name",
                    style: .outlined,
                    leadingIcon: "person"
                )
                
                UITextField(
                    text: $tempEmail,
                    placeholder: "Email Address",
                    label: "Email",
                    style: .outlined,
                    keyboardType: .emailAddress,
                    leadingIcon: "envelope"
                )
                
                Spacer()
                
                VStack(spacing: UITheme.Spacing.md) {
                    UIButton(title: "Save Changes", style: .primary, size: .large) {
                        username = tempUsername
                        email = tempEmail
                        isPresented = false
                    }
                    
                    UIButton(title: "Cancel", style: .secondary, size: .large) {
                        isPresented = false
                    }
                }
            }
            .padding(UITheme.Spacing.lg)
            .background(UITheme.Colors.background(for: themeManager.isDarkMode))
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                tempUsername = username
                tempEmail = email
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(ThemeManager())
        .environmentObject(LocalizationManager())
}