//
//  UITextField.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

/// Style de champ de texte
/// - outlined: Style avec bordure
/// - filled: Style avec fond coloré
/// - underlined: Style avec ligne en bas
enum UITextFieldStyle {
    case outlined
    case filled
    case underlined
}

/// État du champ de texte
/// - normal: État normal
/// - focused: État focus
/// - error: État d'erreur
/// - disabled: État désactivé
enum UITextFieldState {
    case normal
    case focused
    case error
    case disabled
}

/// Composant TextField réutilisable et customisable
/// 
/// Exemple d'utilisation :
/// ```swift
/// UITextField(
///     text: $username,
///     placeholder: "Nom d'utilisateur",
///     label: "Identifiant",
///     style: .outlined,
///     keyboardType: .emailAddress
/// )
/// ```
struct UITextField: View {
    
    // MARK: - Properties
    @Binding var text: String
    let placeholder: String
    let label: String?
    let style: UITextFieldStyle
    let keyboardType: UIKeyboardType
    let isSecure: Bool
    let isDisabled: Bool
    let errorMessage: String?
    let helperText: String?
    let maxLength: Int?
    let leadingIcon: String?
    let trailingIcon: String?
    let onTrailingIconTap: (() -> Void)?
    
    @State private var isSecureVisible = false
    @State private var currentState: UITextFieldState = .normal
    @FocusState private var isFocused: Bool
    
    // MARK: - Initializer
    /// Initialise un nouveau champ de texte
    /// - Parameters:
    ///   - text: Binding du texte
    ///   - placeholder: Texte de placeholder
    ///   - label: Label au-dessus du champ
    ///   - style: Style visuel du champ
    ///   - keyboardType: Type de clavier
    ///   - isSecure: Champ sécurisé (mot de passe)
    ///   - isDisabled: Champ désactivé
    ///   - errorMessage: Message d'erreur
    ///   - helperText: Texte d'aide
    ///   - maxLength: Longueur maximale
    ///   - leadingIcon: Icône à gauche
    ///   - trailingIcon: Icône à droite
    ///   - onTrailingIconTap: Action sur l'icône de droite
    init(
        text: Binding<String>,
        placeholder: String = "",
        label: String? = nil,
        style: UITextFieldStyle = .outlined,
        keyboardType: UIKeyboardType = .default,
        isSecure: Bool = false,
        isDisabled: Bool = false,
        errorMessage: String? = nil,
        helperText: String? = nil,
        maxLength: Int? = nil,
        leadingIcon: String? = nil,
        trailingIcon: String? = nil,
        onTrailingIconTap: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.label = label
        self.style = style
        self.keyboardType = keyboardType
        self.isSecure = isSecure
        self.isDisabled = isDisabled
        self.errorMessage = errorMessage
        self.helperText = helperText
        self.maxLength = maxLength
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.onTrailingIconTap = onTrailingIconTap
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: UITheme.Spacing.xs) {
            // Label
            if let label = label {
                Text(label)
                    .font(UITheme.Typography.caption)
                    .foregroundColor(labelColor)
            }
            
            // Text Field Container
            HStack(spacing: UITheme.Spacing.sm) {
                // Leading Icon
                if let leadingIcon = leadingIcon {
                    Image(systemName: leadingIcon)
                        .font(UITheme.Typography.body)
                        .foregroundColor(iconColor)
                        .frame(width: 20, height: 20)
                }
                
                // Text Field
                textFieldContent
                
                // Trailing Icon or Secure Toggle
                if isSecure {
                    Button(action: { isSecureVisible.toggle() }) {
                        Image(systemName: isSecureVisible ? "eye.slash" : "eye")
                            .font(UITheme.Typography.body)
                            .foregroundColor(iconColor)
                    }
                } else if let trailingIcon = trailingIcon {
                    Button(action: { onTrailingIconTap?() }) {
                        Image(systemName: trailingIcon)
                            .font(UITheme.Typography.body)
                            .foregroundColor(iconColor)
                    }
                }
            }
            .padding(UITheme.Spacing.md)
            .background(backgroundColor)
            .overlay(borderOverlay)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .disabled(isDisabled)
            
            // Helper Text or Error Message
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(UITheme.Typography.caption)
                    .foregroundColor(UITheme.Colors.error)
            } else if let helperText = helperText {
                Text(helperText)
                    .font(UITheme.Typography.caption)
                    .foregroundColor(UITheme.Colors.textSecondary)
            }
        }
        .animation(UITheme.Animation.fast, value: isFocused)
        .animation(UITheme.Animation.fast, value: currentState)
        .onChange(of: isFocused) { focused in
            updateState()
        }
        .onChange(of: text) { newText in
            if let maxLength = maxLength, newText.count > maxLength {
                text = String(newText.prefix(maxLength))
            }
        }
        .onAppear {
            updateState()
        }
    }
    
    // MARK: - Text Field Content
    @ViewBuilder
    private var textFieldContent: some View {
        if isSecure && !isSecureVisible {
            SecureField(placeholder, text: $text)
                .font(UITheme.Typography.body)
                .foregroundColor(textColor)
                .keyboardType(keyboardType)
                .focused($isFocused)
        } else {
            TextField(placeholder, text: $text)
                .font(UITheme.Typography.body)
                .foregroundColor(textColor)
                .keyboardType(keyboardType)
                .focused($isFocused)
        }
    }
    
    // MARK: - Computed Properties
    private var backgroundColor: Color {
        switch style {
        case .outlined:
            return UITheme.Colors.background
        case .filled:
            return UITheme.Colors.surface
        case .underlined:
            return Color.clear
        }
    }
    
    private var borderColor: Color {
        switch currentState {
        case .normal:
            return UITheme.Colors.outline
        case .focused:
            return UITheme.Colors.primary
        case .error:
            return UITheme.Colors.error
        case .disabled:
            return UITheme.Colors.outline.opacity(0.5)
        }
    }
    
    private var labelColor: Color {
        switch currentState {
        case .error:
            return UITheme.Colors.error
        case .focused:
            return UITheme.Colors.primary
        default:
            return UITheme.Colors.textSecondary
        }
    }
    
    private var textColor: Color {
        isDisabled ? UITheme.Colors.textSecondary : UITheme.Colors.textPrimary
    }
    
    private var iconColor: Color {
        switch currentState {
        case .error:
            return UITheme.Colors.error
        case .focused:
            return UITheme.Colors.primary
        default:
            return UITheme.Colors.textSecondary
        }
    }
    
    private var cornerRadius: CGFloat {
        switch style {
        case .outlined, .filled:
            return UITheme.CornerRadius.medium
        case .underlined:
            return 0
        }
    }
    
    @ViewBuilder
    private var borderOverlay: some View {
        switch style {
        case .outlined:
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: currentState == .focused ? 2 : 1)
        case .filled:
            EmptyView()
        case .underlined:
            VStack {
                Spacer()
                Rectangle()
                    .frame(height: currentState == .focused ? 2 : 1)
                    .foregroundColor(borderColor)
            }
        }
    }
    
    // MARK: - Functions
    private func updateState() {
        if isDisabled {
            currentState = .disabled
        } else if errorMessage != nil {
            currentState = .error
        } else if isFocused {
            currentState = .focused
        } else {
            currentState = .normal
        }
    }
}

#Preview {
    VStack(spacing: UITheme.Spacing.lg) {
        UITextField(
            text: .constant(""),
            placeholder: "Email",
            label: "Adresse email",
            style: .outlined,
            keyboardType: .emailAddress,
            leadingIcon: "envelope"
        )
        
        UITextField(
            text: .constant(""),
            placeholder: "Mot de passe",
            label: "Mot de passe",
            style: .filled,
            isSecure: true,
            leadingIcon: "lock"
        )
        
        UITextField(
            text: .constant("John Doe"),
            placeholder: "Nom complet",
            label: "Nom",
            style: .underlined,
            leadingIcon: "person",
            trailingIcon: "checkmark.circle.fill"
        )
        
        UITextField(
            text: .constant("test@email"),
            placeholder: "Email",
            label: "Email invalide",
            style: .outlined,
            errorMessage: "Format d'email invalide",
            leadingIcon: "envelope"
        )
        
        UITextField(
            text: .constant("Texte"),
            placeholder: "Texte",
            label: "Champ désactivé",
            style: .outlined,
            isDisabled: true
        )
    }
    .padding()
}