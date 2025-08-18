//
//  UICard.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

/// Available card style
/// - elevated: Card with elevated shadow
/// - outlined: Card with border
/// - filled: Card with colored background
enum UICardStyle {
    case elevated
    case outlined
    case filled
}

/// Reusable and customizable Card component
/// 
/// Exemple d'utilisation :
/// ```swift
/// UICard(
///     style: .elevated,
///     padding: UITheme.Spacing.md,
///     onTap: { print("Card tapped") }
/// ) {
///     VStack {
///         Text("Titre")
///         Text("Contenu")
///     }
/// }
/// ```
struct UICard<Content: View>: View {
    
    // MARK: - Properties
    let style: UICardStyle
    let padding: CGFloat
    let cornerRadius: CGFloat
    let onTap: (() -> Void)?
    let content: Content
    
    @State private var isPressed = false
    
    // MARK: - Initializer
    /// Initialize a new card
    /// - Parameters:
    ///   - style: Visual style of the card
    ///   - padding: Espacement interne
    ///   - cornerRadius: Rayon des coins
    ///   - onTap: Action lors du tap (optionnel)
    ///   - content: Card content
    init(
        style: UICardStyle = .elevated,
        padding: CGFloat = UITheme.Spacing.md,
        cornerRadius: CGFloat = UITheme.CornerRadius.medium,
        onTap: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.onTap = onTap
        self.content = content()
    }
    
    // MARK: - Body
    var body: some View {
        if let onTap = onTap {
            Button(action: onTap) {
                cardContent
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                withAnimation(UITheme.Animation.fast) {
                    isPressed = pressing
                }
            }, perform: {})
        } else {
            cardContent
        }
    }
    
    // MARK: - Card Content
    private var cardContent: some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .overlay(borderOverlay)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: shadowX,
                y: shadowY
            )
    }
    
    // MARK: - Computed Properties
    private var backgroundColor: Color {
        switch style {
        case .elevated:
            return Color(.secondarySystemBackground)
        case .outlined:
            return Color(.systemBackground)
        case .filled:
            return Color(.secondarySystemBackground)
        }
    }
    
    @ViewBuilder
    private var borderOverlay: some View {
        switch style {
        case .elevated, .filled:
            EmptyView()
        case .outlined:
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color(.separator), lineWidth: 1)
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .elevated:
            return UITheme.Shadow.medium.color
        case .outlined, .filled:
            return Color.clear
        }
    }
    
    private var shadowRadius: CGFloat {
        switch style {
        case .elevated:
            return UITheme.Shadow.medium.radius
        case .outlined, .filled:
            return 0
        }
    }
    
    private var shadowX: CGFloat {
        switch style {
        case .elevated:
            return UITheme.Shadow.medium.x
        case .outlined, .filled:
            return 0
        }
    }
    
    private var shadowY: CGFloat {
        switch style {
        case .elevated:
            return UITheme.Shadow.medium.y
        case .outlined, .filled:
            return 0
        }
    }
}

#Preview {
    VStack(spacing: UITheme.Spacing.lg) {
        UICard(style: .elevated) {
            VStack(alignment: .leading, spacing: UITheme.Spacing.sm) {
                Text("Carte Élevée")
                    .font(UITheme.Typography.headline)
                    .foregroundColor(Color(.label))
                
                Text("Ceci est une carte avec une ombre pour créer un effet d'élévation.")
                    .font(UITheme.Typography.body)
                    .foregroundColor(Color(.secondaryLabel))
            }
        }
        
        UICard(style: .outlined, onTap: {}) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(UITheme.Colors.warning)
                
                VStack(alignment: .leading) {
                    Text("Carte avec Bordure")
                        .font(UITheme.Typography.headline)
                        .foregroundColor(Color(.label))
                    
                    Text("Carte cliquable avec bordure")
                        .font(UITheme.Typography.caption)
                        .foregroundColor(Color(.secondaryLabel))
                }
                
                Spacer()
            }
        }
        
        UICard(style: .filled) {
            HStack {
                VStack(alignment: .leading, spacing: UITheme.Spacing.xs) {
                    Text("Carte Remplie")
                        .font(UITheme.Typography.title3)
                        .foregroundColor(Color(.label))
                    
                    Text("Style avec fond coloré")
                        .font(UITheme.Typography.body)
                        .foregroundColor(Color(.secondaryLabel))
                }
                
                Spacer()
                
                UIButton(title: "Action", style: .primary, size: .small) {}
            }
        }
    }
    .padding()
}