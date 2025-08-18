//
//  UITheme.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

/// Configuration globale du thème de l'application
/// Centralise toutes les couleurs, polices, espacements et autres propriétés visuelles
struct UITheme {
    
    // MARK: - Colors
    struct Colors {
        // Primary colors
        static let primary = Color.blue
        static let primaryVariant = Color.blue.opacity(0.8)
        static let secondary = Color.orange
        static let secondaryVariant = Color.orange.opacity(0.8)
        
        // Semantic colors
        static let success = Color.green
        static let warning = Color.yellow
        static let error = Color.red
        static let info = Color.blue
        
        // Neutral colors
        static let background = Color(.systemBackground)
        static let surface = Color(.secondarySystemBackground)
        static let onBackground = Color(.label)
        static let onSurface = Color(.label)
        static let outline = Color(.separator)
        
        // Text colors
        static let textPrimary = Color(.label)
        static let textSecondary = Color(.secondaryLabel)
        static let textTertiary = Color(.tertiaryLabel)
        static let textQuaternary = Color(.quaternaryLabel)
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title1 = Font.title.weight(.bold)
        static let title2 = Font.title2.weight(.semibold)
        static let title3 = Font.title3.weight(.semibold)
        static let headline = Font.headline.weight(.semibold)
        static let body = Font.body
        static let callout = Font.callout
        static let subheadline = Font.subheadline
        static let footnote = Font.footnote
        static let caption = Font.caption
        static let caption2 = Font.caption2
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 4
        static let medium: CGFloat = 8
        static let large: CGFloat = 12
        static let extraLarge: CGFloat = 16
        static let round: CGFloat = 50
    }
    
    // MARK: - Shadows
    struct Shadow {
        static let small = (color: Color.black.opacity(0.1), radius: CGFloat(2), x: CGFloat(0), y: CGFloat(1))
        static let medium = (color: Color.black.opacity(0.15), radius: CGFloat(4), x: CGFloat(0), y: CGFloat(2))
        static let large = (color: Color.black.opacity(0.2), radius: CGFloat(8), x: CGFloat(0), y: CGFloat(4))
    }
    
    // MARK: - Animation
    struct Animation {
        static let fast = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let medium = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)
        static let spring = SwiftUI.Animation.spring(response: 0.6, dampingFraction: 0.8)
    }
}