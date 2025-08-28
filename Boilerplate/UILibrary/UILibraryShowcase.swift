//
//  UILibraryShowcase.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

/// Demo view of all UI Library components
/// Used to test and showcase components
struct UILibraryShowcase: View {
    
    @State private var showModal = false
    @State private var showFullScreenModal = false
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: UITheme.Spacing.xl) {
                    
                    // MARK: - Buttons Section
                    showcaseSection(title: "Buttons") {
                        VStack(spacing: UITheme.Spacing.md) {
                            HStack(spacing: UITheme.Spacing.sm) {
                                UIButton(title: "Primary", style: .primary, size: .small) {}
                                    .frame(maxWidth: .infinity)
                                UIButton(title: "Secondary", style: .secondary, size: .small) {}
                                    .frame(maxWidth: .infinity)
                                UIButton(title: "Tertiary", style: .tertiary, size: .small) {}
                                    .frame(maxWidth: .infinity)
                            }
                            
                            UIButton(title: "With Icon", style: .primary, icon: "heart.fill") {}
                                .frame(maxWidth: .infinity)
                            UIButton(title: "Loading", style: .primary, isLoading: true) {}
                                .frame(maxWidth: .infinity)
                            UIButton(title: "Disabled", style: .primary, isDisabled: true) {}
                                .frame(maxWidth: .infinity)
                            UIButton(title: "Destructive", style: .destructive, size: .large) {}
                                .frame(maxWidth: .infinity)
                        }
                    }
                    
                    // MARK: - Text Fields Section
                    showcaseSection(title: "Text Fields") {
                        VStack(spacing: UITheme.Spacing.md) {
                            UITextField(
                                text: $email,
                                placeholder: "votre@email.com",
                                label: "Email (Outlined)",
                                style: .outlined,
                                keyboardType: .emailAddress,
                                leadingIcon: "envelope"
                            )
                            
                            UITextField(
                                text: $password,
                                placeholder: "Mot de passe",
                                label: "Mot de passe (Filled)",
                                style: .filled,
                                isSecure: true,
                                leadingIcon: "lock"
                            )
                            
                            UITextField(
                                text: .constant("John Doe"),
                                placeholder: "Nom",
                                label: "Nom complet (Underlined)",
                                style: .underlined,
                                leadingIcon: "person"
                            )
                            
                            UITextField(
                                text: .constant("invalid@email"),
                                placeholder: "Email",
                                label: "Email avec erreur",
                                style: .outlined,
                                errorMessage: "Format d'email invalide",
                                leadingIcon: "envelope"
                            )
                        }
                    }
                    
                    // MARK: - Cards Section
                    showcaseSection(title: "Cards") {
                        VStack(spacing: UITheme.Spacing.md) {
                            UICard(style: .elevated) {
                                cardContent(title: "Carte Élevée", description: "Avec ombre pour l'élévation")
                            }
                            .frame(maxWidth: .infinity)
                            
                            UICard(style: .outlined, onTap: {}) {
                                cardContent(title: "Carte avec Bordure", description: "Cliquable avec bordure")
                            }
                            .frame(maxWidth: .infinity)
                            
                            UICard(style: .filled) {
                                HStack {
                                    cardContent(title: "Carte Remplie", description: "Avec fond coloré")
                                    Spacer()
                                    UIButton(title: "Action", style: .primary, size: .small) {}
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    
                    // MARK: - Badges Section
                    showcaseSection(title: "Badges") {
                        VStack(spacing: UITheme.Spacing.md) {
                            HStack(spacing: UITheme.Spacing.sm) {
                                UIBadge(text: "Primary", style: .primary)
                                UIBadge(text: "Success", style: .success)
                                UIBadge(text: "Warning", style: .warning)
                                UIBadge(text: "Error", style: .error)
                            }
                            
                            HStack(spacing: UITheme.Spacing.sm) {
                                UIBadge(text: "Vérifié", style: .success, icon: "checkmark.circle.fill")
                                UIBadge(text: "Favori", style: .warning, icon: "heart.fill")
                                UIBadge(text: "Nouveau", style: .primary, icon: "sparkles")
                            }
                            
                            HStack(spacing: UITheme.Spacing.sm) {
                                UIBadge.new
                                UIBadge.popular
                                UIBadge.premium
                                UIBadge.online
                            }
                            
                            HStack(spacing: UITheme.Spacing.sm) {
                                UIBadge(text: "Outlined", style: .primary, isOutlined: true)
                                UIBadge(text: "Success", style: .success, isOutlined: true)
                                UIBadge(text: "Error", style: .error, isOutlined: true)
                            }
                        }
                    }
                    
                    // MARK: - Loading Indicators Section
                    showcaseSection(title: "Loading Indicators") {
                        VStack(spacing: UITheme.Spacing.lg) {
                            HStack(spacing: UITheme.Spacing.xl) {
                                UILoadingIndicator(style: .circular, size: .small, message: "Small")
                                UILoadingIndicator(style: .circular, size: .medium, message: "Medium")
                                UILoadingIndicator(style: .circular, size: .large, message: "Large")
                            }
                            
                            HStack(spacing: UITheme.Spacing.xl) {
                                UILoadingIndicator(style: .dots, size: .medium, color: .orange)
                                UILoadingIndicator(style: .pulse, size: .medium, color: .green)
                                UILoadingIndicator(style: .skeleton, size: .medium, color: .purple)
                            }
                        }
                    }
                    
                    // MARK: - Modals Section
                    showcaseSection(title: "Modals") {
                        VStack(spacing: UITheme.Spacing.md) {
                            UIButton(title: "Modal Centrée", style: .secondary) {
                                showModal = true
                            }
                            
                            UIButton(title: "Modal Plein Écran", style: .tertiary) {
                                showFullScreenModal = true
                            }
                        }
                    }
                    
                    // MARK: - Backgrounds Section
                    showcaseSection(title: "Backgrounds") {
                        VStack(spacing: UITheme.Spacing.sm) {
                            // Basic Backgrounds
                            backgroundDemo(UIBackground.primary, title: "Primary", textColor: .primary)
                            backgroundDemo(UIBackground.secondary, title: "Secondary", textColor: .primary)
                            backgroundDemo(UIBackground.overlay, title: "Overlay")
                            
                            // 2025 Trending - Purple & Pink Collection
                            backgroundDemo(UIBackground.etherealPurplePink, title: "Ethereal Purple Pink")
                            backgroundDemo(UIBackground.deepPurpleGalaxy, title: "Deep Purple Galaxy")
                            backgroundDemo(UIBackground.electricVioletDreams, title: "Electric Violet Dreams")
                            
                            // Sunset Collection
                            backgroundDemo(UIBackground.vibrantSunset2025, title: "Vibrant Sunset 2025")
                            backgroundDemo(UIBackground.goldenHourMagic, title: "Golden Hour Magic")
                            
                            // Ocean & Sky Collection
                            backgroundDemo(UIBackground.electricOceanWaves, title: "Electric Ocean Waves")
                            backgroundDemo(UIBackground.dreamySkyBlue, title: "Dreamy Sky Blue", textColor: .black)
                            
                            // Soft & Pastel Collection
                            backgroundDemo(UIBackground.softPinkSerenity, title: "Soft Pink Serenity", textColor: .black)
                            backgroundDemo(UIBackground.mintFreshBreeze, title: "Mint Fresh Breeze", textColor: .black)
                            
                            // Bold & Electric Collection
                            backgroundDemo(UIBackground.electricNeonBurst, title: "Electric Neon Burst")
                            backgroundDemo(UIBackground.cyberPurpleMatrix, title: "Cyber Purple Matrix")
                            
                            // Radial Gradients
                            backgroundDemo(UIBackground.cosmicPurpleCenter, title: "Cosmic Purple Center")
                            backgroundDemo(UIBackground.sunsetGlowRadial, title: "Sunset Glow Radial")
                            
                            // Theme Collection
                            backgroundDemo(UIBackground.lightElegant, title: "Light Elegant", textColor: .black)
                            backgroundDemo(UIBackground.darkElegant, title: "Dark Elegant")
                            backgroundDemo(UIBackground.midnightPurple, title: "Midnight Purple")
                            backgroundDemo(UIBackground.darkOceanDepths, title: "Dark Ocean Depths")
                            
                            // Legacy Gradients (Enhanced)
                            backgroundDemo(UIBackground.blueGradient, title: "Blue Gradient")
                            backgroundDemo(UIBackground.sunsetGradient, title: "Sunset Gradient")
                            backgroundDemo(UIBackground.greenGradient, title: "Green Gradient")
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("UI Library Showcase")
        }
        .navigationViewStyle(.stack)
        .overlay {
            if showModal {
                modalContent
            }
        }
        .fullScreenCover(isPresented: $showFullScreenModal) {
            fullScreenModalContent
        }
    }
    
    // MARK: - Helper Views
    @ViewBuilder
    private func showcaseSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: UITheme.Spacing.md) {
            Text(title)
                .font(UITheme.Typography.title2)
                .foregroundColor(Color(.label))
            
            content()
        }
    }
    
    @ViewBuilder
    private func cardContent(title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: UITheme.Spacing.xs) {
            Text(title)
                .font(UITheme.Typography.headline)
                .foregroundColor(Color(.label))
            
            Text(description)
                .font(UITheme.Typography.body)
                .foregroundColor(Color(.secondaryLabel))
        }
    }
    
    @ViewBuilder
    private func backgroundDemo(_ background: UIBackground, title: String, textColor: Color = .white) -> some View {
        ZStack {
            background
            
            Text(title)
                .font(UITheme.Typography.title3)
                .fontWeight(.semibold)
                .foregroundColor(textColor)
        }
        .frame(height: 60)
        .cornerRadius(UITheme.CornerRadius.medium)
    }
    
    // MARK: - Modal Content
    private var modalContent: some View {
        UIModal(
            isPresented: $showModal,
            title: "Exemple Modal",
            style: .center,
            size: .medium
        ) {
            VStack(spacing: UITheme.Spacing.lg) {
                Text("Ceci est une modal de démonstration avec du contenu personnalisé.")
                    .multilineTextAlignment(.center)
                
                UILoadingIndicator(style: .dots, size: .medium, message: "Chargement...")
                
                HStack(spacing: UITheme.Spacing.md) {
                    UIButton(title: "Annuler", style: .secondary) {
                        showModal = false
                    }
                    
                    UIButton(title: "Confirmer", style: .primary) {
                        showModal = false
                    }
                }
            }
        }
    }
    
    private var fullScreenModalContent: some View {
        NavigationView {
            VStack(spacing: UITheme.Spacing.xl) {
                UIBackground.blueGradient
                    .frame(height: 200)
                    .overlay(
                        Text("Modal Plein Écran")
                            .font(UITheme.Typography.title1)
                            .foregroundColor(.white)
                    )
                    .cornerRadius(UITheme.CornerRadius.large)
                
                Text("Cette modal occupe tout l'écran et peut contenir du contenu complexe.")
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Modal Plein Écran")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        showFullScreenModal = false
                    }
                }
            }
        }
    }
}

#Preview {
    UILibraryShowcase()
}