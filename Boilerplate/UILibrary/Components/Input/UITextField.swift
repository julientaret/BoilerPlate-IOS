//
//  UITextField.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

/// Text field style
/// - outlined: Style with border
/// - filled: Style with colored background
/// - underlined: Style with bottom line
enum UITextFieldStyle {
    case outlined
    case filled
    case underlined
}

/// Text field state
/// - normal: Normal state
/// - focused: Focused state
/// - error: Error state
/// - disabled: Disabled state
enum UITextFieldState {
    case normal
    case focused
    case error
    case disabled
}

/// Reusable and customizable TextField component
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
    /// Initialize a new text field
    /// - Parameters:
    ///   - text: Binding du texte
    ///   - placeholder: Texte de placeholder
    ///   - label: Label above the field
///   - style: Visual style of the field
    ///   - keyboardType: Type de clavier
    ///   - isSecure: Secure field (password)
///   - isDisabled: Disabled field
    ///   - errorMessage: Message d'erreur
    ///   - helperText: Texte d'aide
    ///   - maxLength: Longueur maximale
    ///   - leadingIcon: Left icon
///   - trailingIcon: Right icon
///   - onTrailingIconTap: Action on right icon
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
                    .foregroundColor(Color(.secondaryLabel))
            }
        }
        .animation(UITheme.Animation.fast, value: isFocused)
        .animation(UITheme.Animation.fast, value: currentState)
        .onChange(of: isFocused) { _, _ in
            updateState()
        }
        .onChange(of: text) { _, newText in
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
            return Color(.systemBackground)
        case .filled:
            return Color(.secondarySystemBackground)
        case .underlined:
            return Color.clear
        }
    }
    
    private var borderColor: Color {
        switch currentState {
        case .normal:
            return Color(.separator)
        case .focused:
            return .blue
        case .error:
            return UITheme.Colors.error
        case .disabled:
            return Color(.separator).opacity(0.5)
        }
    }
    
    private var labelColor: Color {
        switch currentState {
        case .error:
            return UITheme.Colors.error
        case .focused:
            return .blue
        default:
            return Color(.secondaryLabel)
        }
    }
    
    private var textColor: Color {
        isDisabled ? Color(.secondaryLabel) : Color(.label)
    }
    
    private var iconColor: Color {
        switch currentState {
        case .error:
            return UITheme.Colors.error
        case .focused:
            return .blue
        default:
            return Color(.secondaryLabel)
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