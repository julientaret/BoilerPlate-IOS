//
//  UIBadge.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

/// Style de badge disponible
/// - primary: Badge principal
/// - secondary: Badge secondaire
/// - success: Badge de succès
/// - warning: Badge d'avertissement
/// - error: Badge d'erreur
/// - info: Badge d'information
/// - neutral: Badge neutre
enum UIBadgeStyle {
    case primary
    case secondary
    case success
    case warning
    case error
    case info
    case neutral
}

/// Taille de badge disponible
/// - small: Badge compact
/// - medium: Taille standard
/// - large: Badge proéminent
enum UIBadgeSize {
    case small
    case medium
    case large
    
    var font: Font {
        switch self {
        case .small: return UITheme.Typography.caption2
        case .medium: return UITheme.Typography.caption
        case .large: return UITheme.Typography.footnote
        }
    }
    
    var padding: EdgeInsets {
        switch self {
        case .small: return EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6)
        case .medium: return EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        case .large: return EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .small: return UITheme.CornerRadius.small
        case .medium: return UITheme.CornerRadius.medium
        case .large: return UITheme.CornerRadius.large
        }
    }
}

/// Composant Badge réutilisable et customisable
/// 
/// Exemple d'utilisation :
/// ```swift
/// UIBadge(
///     text: "Nouveau",
///     style: .success,
///     size: .medium,
///     icon: "checkmark"
/// )
/// ```
struct UIBadge: View {
    
    // MARK: - Properties
    let text: String
    let style: UIBadgeStyle
    let size: UIBadgeSize
    let icon: String?
    let isOutlined: Bool
    
    // MARK: - Initializer
    /// Initialise un nouveau badge
    /// - Parameters:
    ///   - text: Texte affiché dans le badge
    ///   - style: Style visuel du badge
    ///   - size: Taille du badge
    ///   - icon: Icône SF Symbols (optionnel)
    ///   - isOutlined: Style avec bordure seulement
    init(
        text: String,
        style: UIBadgeStyle = .primary,
        size: UIBadgeSize = .medium,
        icon: String? = nil,
        isOutlined: Bool = false
    ) {
        self.text = text
        self.style = style
        self.size = size
        self.icon = icon
        self.isOutlined = isOutlined
    }
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: UITheme.Spacing.xs) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(iconFont)
                    .foregroundColor(textColor)
            }
            
            if !text.isEmpty {
                Text(text)
                    .font(size.font)
                    .fontWeight(.semibold)
                    .foregroundColor(textColor)
            }
        }
        .padding(size.padding)
        .background(backgroundColor)
        .overlay(borderOverlay)
        .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
    }
    
    // MARK: - Computed Properties
    private var backgroundColor: Color {
        if isOutlined {
            return Color.clear
        }
        
        switch style {
        case .primary:
            return UITheme.Colors.primary
        case .secondary:
            return UITheme.Colors.secondary
        case .success:
            return UITheme.Colors.success
        case .warning:
            return UITheme.Colors.warning
        case .error:
            return UITheme.Colors.error
        case .info:
            return UITheme.Colors.info
        case .neutral:
            return UITheme.Colors.outline.opacity(0.2)
        }
    }
    
    private var textColor: Color {
        if isOutlined {
            switch style {
            case .primary:
                return UITheme.Colors.primary
            case .secondary:
                return UITheme.Colors.secondary
            case .success:
                return UITheme.Colors.success
            case .warning:
                return UITheme.Colors.warning
            case .error:
                return UITheme.Colors.error
            case .info:
                return UITheme.Colors.info
            case .neutral:
                return UITheme.Colors.textPrimary
            }
        }
        
        switch style {
        case .primary, .secondary, .success, .error, .info:
            return .white
        case .warning:
            return .black
        case .neutral:
            return UITheme.Colors.textPrimary
        }
    }
    
    @ViewBuilder
    private var borderOverlay: some View {
        if isOutlined {
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .stroke(borderColor, lineWidth: 1)
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .primary:
            return UITheme.Colors.primary
        case .secondary:
            return UITheme.Colors.secondary
        case .success:
            return UITheme.Colors.success
        case .warning:
            return UITheme.Colors.warning
        case .error:
            return UITheme.Colors.error
        case .info:
            return UITheme.Colors.info
        case .neutral:
            return UITheme.Colors.outline
        }
    }
    
    private var iconFont: Font {
        switch size {
        case .small:
            return .system(size: 8, weight: .semibold)
        case .medium:
            return .system(size: 10, weight: .semibold)
        case .large:
            return .system(size: 12, weight: .semibold)
        }
    }
}

// MARK: - Predefined Badges
extension UIBadge {
    
    /// Badge de notification (point rouge)
    static var notification: UIBadge {
        UIBadge(text: "", style: .error, size: .small)
    }
    
    /// Badge nouveau
    static var new: UIBadge {
        UIBadge(text: "Nouveau", style: .success, size: .small)
    }
    
    /// Badge populaire
    static var popular: UIBadge {
        UIBadge(text: "Populaire", style: .warning, size: .small, icon: "star.fill")
    }
    
    /// Badge premium
    static var premium: UIBadge {
        UIBadge(text: "Premium", style: .primary, size: .medium, icon: "crown.fill")
    }
    
    /// Badge en ligne
    static var online: UIBadge {
        UIBadge(text: "En ligne", style: .success, size: .small, icon: "circle.fill")
    }
    
    /// Badge hors ligne
    static var offline: UIBadge {
        UIBadge(text: "Hors ligne", style: .neutral, size: .small, icon: "circle")
    }
}

#Preview {
    VStack(spacing: UITheme.Spacing.lg) {
        // Styles différents
        HStack(spacing: UITheme.Spacing.sm) {
            UIBadge(text: "Primary", style: .primary)
            UIBadge(text: "Secondary", style: .secondary)
            UIBadge(text: "Success", style: .success)
        }
        
        HStack(spacing: UITheme.Spacing.sm) {
            UIBadge(text: "Warning", style: .warning)
            UIBadge(text: "Error", style: .error)
            UIBadge(text: "Info", style: .info)
        }
        
        // Avec icônes
        HStack(spacing: UITheme.Spacing.sm) {
            UIBadge(text: "Vérifié", style: .success, icon: "checkmark.circle.fill")
            UIBadge(text: "Favori", style: .warning, icon: "heart.fill")
            UIBadge(text: "Nouveau", style: .primary, icon: "sparkles")
        }
        
        // Tailles différentes
        HStack(spacing: UITheme.Spacing.sm) {
            UIBadge(text: "Small", style: .primary, size: .small)
            UIBadge(text: "Medium", style: .primary, size: .medium)
            UIBadge(text: "Large", style: .primary, size: .large)
        }
        
        // Style outlined
        HStack(spacing: UITheme.Spacing.sm) {
            UIBadge(text: "Outlined", style: .primary, isOutlined: true)
            UIBadge(text: "Success", style: .success, icon: "checkmark", isOutlined: true)
            UIBadge(text: "Error", style: .error, isOutlined: true)
        }
        
        // Badges prédéfinis
        HStack(spacing: UITheme.Spacing.sm) {
            UIBadge.new
            UIBadge.popular
            UIBadge.premium
            UIBadge.online
            UIBadge.notification
        }
    }
    .padding()
}