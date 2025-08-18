//
//  UIButton.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

/// Style de bouton disponible dans l'UI Library
/// - primary: Style principal avec fond coloré
/// - secondary: Style secondaire avec contour
/// - tertiary: Style tertiaire transparent
/// - destructive: Style pour actions destructives
enum UIButtonStyle {
    case primary
    case secondary 
    case tertiary
    case destructive
}

/// Taille de bouton disponible
/// - small: Bouton compact
/// - medium: Taille standard
/// - large: Bouton proéminent
enum UIButtonSize {
    case small
    case medium
    case large
    
    var height: CGFloat {
        switch self {
        case .small: return 32
        case .medium: return 44
        case .large: return 56
        }
    }
    
    var font: Font {
        switch self {
        case .small: return UITheme.Typography.footnote
        case .medium: return UITheme.Typography.body
        case .large: return UITheme.Typography.headline
        }
    }
    
    var padding: EdgeInsets {
        switch self {
        case .small: return EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
        case .medium: return EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        case .large: return EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
        }
    }
}

/// Composant Button réutilisable et customisable
/// 
/// Exemple d'utilisation :
/// ```swift
/// UIButton(
///     title: "Connexion",
///     style: .primary,
///     size: .medium,
///     isLoading: false
/// ) {
///     // Action du bouton
/// }
/// ```
struct UIButton: View {
    
    // MARK: - Properties
    let title: String
    let style: UIButtonStyle
    let size: UIButtonSize
    let isLoading: Bool
    let isDisabled: Bool
    let icon: String?
    let action: () -> Void
    
    @State private var isPressed = false
    
    // MARK: - Initializer
    /// Initialise un nouveau bouton
    /// - Parameters:
    ///   - title: Texte affiché sur le bouton
    ///   - style: Style visuel du bouton
    ///   - size: Taille du bouton
    ///   - isLoading: Affiche un indicateur de chargement
    ///   - isDisabled: Désactive le bouton
    ///   - icon: Nom de l'icône SF Symbols (optionnel)
    ///   - action: Action exécutée lors du tap
    init(
        title: String,
        style: UIButtonStyle = .primary,
        size: UIButtonSize = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        icon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.icon = icon
        self.action = action
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            if !isDisabled && !isLoading {
                action()
            }
        }) {
            HStack(spacing: UITheme.Spacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                        .scaleEffect(0.8)
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(iconFont)
                }
                
                if !isLoading {
                    Text(title)
                        .font(size.font)
                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(textColor)
            .padding(size.padding)
            .frame(minHeight: size.height)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: UITheme.CornerRadius.medium)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: UITheme.CornerRadius.medium))
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .opacity(effectiveOpacity)
            .animation(UITheme.Animation.fast, value: isPressed)
            .animation(UITheme.Animation.fast, value: isDisabled)
            .animation(UITheme.Animation.fast, value: isLoading)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .disabled(isDisabled || isLoading)
    }
    
    // MARK: - Computed Properties
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return UITheme.Colors.primary
        case .secondary:
            return Color.clear
        case .tertiary:
            return Color.clear
        case .destructive:
            return UITheme.Colors.error
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary:
            return .white
        case .secondary:
            return UITheme.Colors.primary
        case .tertiary:
            return UITheme.Colors.textPrimary
        case .destructive:
            return .white
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .primary, .destructive:
            return Color.clear
        case .secondary:
            return UITheme.Colors.primary
        case .tertiary:
            return UITheme.Colors.outline
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .primary, .destructive:
            return 0
        case .secondary, .tertiary:
            return 1
        }
    }
    
    private var effectiveOpacity: Double {
        if isDisabled {
            return 0.5
        }
        return 1.0
    }
    
    private var iconFont: Font {
        switch size {
        case .small:
            return .caption
        case .medium:
            return .body
        case .large:
            return .title3
        }
    }
}

#Preview {
    VStack(spacing: UITheme.Spacing.md) {
        UIButton(title: "Primary Button", style: .primary, size: .medium) {}
        UIButton(title: "Secondary Button", style: .secondary, size: .medium) {}
        UIButton(title: "Tertiary Button", style: .tertiary, size: .medium) {}
        UIButton(title: "Destructive Button", style: .destructive, size: .medium) {}
        
        UIButton(title: "With Icon", style: .primary, size: .medium, icon: "heart.fill") {}
        UIButton(title: "Loading", style: .primary, size: .medium, isLoading: true) {}
        UIButton(title: "Disabled", style: .primary, size: .medium, isDisabled: true) {}
        
        UIButton(title: "Small", style: .primary, size: .small) {}
        UIButton(title: "Large", style: .primary, size: .large) {}
    }
    .padding()
}