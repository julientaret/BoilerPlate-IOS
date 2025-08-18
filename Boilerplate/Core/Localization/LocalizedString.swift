//
//  LocalizedString.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

// MARK: - Localized String Protocol
protocol LocalizedStringConvertible {
    var localized: String { get }
    var module: String { get }
    var key: String { get }
}

// MARK: - Localized String Implementation
struct LocalizedString: LocalizedStringConvertible {
    let key: String
    let module: String
    private let arguments: [CVarArg]
    
    init(_ key: String, module: String = "Common", arguments: CVarArg...) {
        self.key = key
        self.module = module
        self.arguments = arguments
    }
    
    var localized: String {
        if arguments.isEmpty {
            return LocalizationManager.shared.localized(key, module: module)
        } else {
            return LocalizationManager.shared.localizedFormatted(key, module: module, arguments)
        }
    }
    
    // Pour utilisation dans SwiftUI avec environment
    func text(with manager: LocalizationManager) -> String {
        if arguments.isEmpty {
            return manager.localized(key, module: module)
        } else {
            return manager.localizedFormatted(key, module: module, arguments)
        }
    }
}

// MARK: - String Extension for Easy Localization
extension String {
    func localized(module: String = "Common") -> String {
        return LocalizationManager.shared.localized(self, module: module)
    }
    
    func localizedFormatted(module: String = "Common", _ arguments: CVarArg...) -> String {
        return LocalizationManager.shared.localizedFormatted(self, module: module, arguments)
    }
}

// MARK: - Environment-aware localization for SwiftUI
struct LocalizedText: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    let key: String
    let module: String
    
    init(_ key: String, module: String = "Common") {
        self.key = key
        self.module = module
    }
    
    var body: some View {
        Text(localizationManager.localized(key, module: module))
    }
}

// MARK: - SwiftUI Text Extension
extension Text {
    init(_ localizedString: LocalizedStringConvertible) {
        self.init(localizedString.localized)
    }
    
    init(localized key: String, module: String = "Common") {
        self.init(key.localized(module: module))
    }
}

// MARK: - Environment-aware Localized String Keys
enum L10nKey {
    
    // MARK: - Common
    enum Common {
        static let appName = "app_name"
        static let ok = "ok"
        static let cancel = "cancel"
        static let save = "save"
        static let delete = "delete"
        static let edit = "edit"
        static let close = "close"
        static let back = "back"
        static let next = "next"
        static let previous = "previous"
        static let yes = "yes"
        static let no = "no"
        static let loading = "loading"
        static let error = "error"
        static let success = "success"
        static let warning = "warning"
        static let info = "info"
    }
    
    // MARK: - Theme
    enum Theme {
        static let theme = "theme"
        static let light = "light"
        static let dark = "dark"
        static let auto = "auto"
        static let themeMode = "theme_mode"
        static let appearance = "appearance"
        static let themeSelection = "theme_selection"
        static let themeDescription = "theme_description"
        static let quickToggle = "quick_toggle"
        static let colorPreview = "color_preview"
        static let primary = "primary"
        static let secondary = "secondary"
        static let themeSuccess = "success"
        static let themeError = "error"
    }
    
    // MARK: - Navigation
    enum Navigation {
        static let home = "home"
        static let settings = "settings"
        static let profile = "profile"
        static let menu = "menu"
        static let search = "search"
        static let favorites = "favorites"
        static let history = "history"
        static let about = "about"
    }
    
    // MARK: - Buttons
    enum Buttons {
        static let confirm = "confirm"
        static let `continue` = "continue"
        static let submit = "submit"
        static let send = "send"
        static let retry = "retry"
        static let refresh = "refresh"
        static let download = "download"
        static let upload = "upload"
        static let share = "share"
        static let copy = "copy"
        static let cut = "cut"
        static let paste = "paste"
    }
    
    // MARK: - Forms
    enum Forms {
        static let email = "email"
        static let password = "password"
        static let username = "username"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let phone = "phone"
        static let address = "address"
        static let city = "city"
        static let country = "country"
        static let requiredField = "required_field"
        static let invalidEmail = "invalid_email"
        static let passwordTooShort = "password_too_short"
        static let confirmPassword = "confirm_password"
        static let passwordsDontMatch = "passwords_dont_match"
    }
    
    // MARK: - Messages
    enum Messages {
        static let welcome = "welcome"
        static let goodbye = "goodbye"
        static let thankYou = "thank_you"
        static let pleaseWait = "please_wait"
        static let operationCompleted = "operation_completed"
        static let operationFailed = "operation_failed"
        static let networkError = "network_error"
        static let connectionLost = "connection_lost"
        static let tryAgain = "try_again"
        static let noData = "no_data"
        static let dataSaved = "data_saved"
        static let dataDeleted = "data_deleted"
    }
}

// MARK: - Environment-aware SwiftUI Components
struct L10nText: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    let key: String
    let module: String
    
    init(_ key: String, module: String = "Common") {
        self.key = key
        self.module = module
    }
    
    var body: some View {
        Text(localizationManager.localized(key, module: module))
    }
}

// MARK: - Convenience extensions for L10n usage
extension L10nText {
    // Common
    static func appName() -> L10nText { L10nText(L10nKey.Common.appName) }
    static func ok() -> L10nText { L10nText(L10nKey.Common.ok) }
    static func cancel() -> L10nText { L10nText(L10nKey.Common.cancel) }
    static func save() -> L10nText { L10nText(L10nKey.Common.save) }
    static func delete() -> L10nText { L10nText(L10nKey.Common.delete) }
    static func edit() -> L10nText { L10nText(L10nKey.Common.edit) }
    static func close() -> L10nText { L10nText(L10nKey.Common.close) }
    static func back() -> L10nText { L10nText(L10nKey.Common.back) }
    static func next() -> L10nText { L10nText(L10nKey.Common.next) }
    static func previous() -> L10nText { L10nText(L10nKey.Common.previous) }
    static func yes() -> L10nText { L10nText(L10nKey.Common.yes) }
    static func no() -> L10nText { L10nText(L10nKey.Common.no) }
    static func loading() -> L10nText { L10nText(L10nKey.Common.loading) }
    static func error() -> L10nText { L10nText(L10nKey.Common.error) }
    static func success() -> L10nText { L10nText(L10nKey.Common.success) }
    static func warning() -> L10nText { L10nText(L10nKey.Common.warning) }
    static func info() -> L10nText { L10nText(L10nKey.Common.info) }
    
    // Theme
    static func theme() -> L10nText { L10nText(L10nKey.Theme.theme, module: "Theme") }
    static func light() -> L10nText { L10nText(L10nKey.Theme.light, module: "Theme") }
    static func dark() -> L10nText { L10nText(L10nKey.Theme.dark, module: "Theme") }
    static func auto() -> L10nText { L10nText(L10nKey.Theme.auto, module: "Theme") }
    static func themeMode() -> L10nText { L10nText(L10nKey.Theme.themeMode, module: "Theme") }
    static func appearance() -> L10nText { L10nText(L10nKey.Theme.appearance, module: "Theme") }
    static func themeSelection() -> L10nText { L10nText(L10nKey.Theme.themeSelection, module: "Theme") }
    
    // Navigation
    static func home() -> L10nText { L10nText(L10nKey.Navigation.home, module: "Navigation") }
    static func settings() -> L10nText { L10nText(L10nKey.Navigation.settings, module: "Navigation") }
    static func profile() -> L10nText { L10nText(L10nKey.Navigation.profile, module: "Navigation") }
    static func menu() -> L10nText { L10nText(L10nKey.Navigation.menu, module: "Navigation") }
}

// MARK: - SwiftUI View Modifier for Reactive Localization
struct LocalizedViewModifier: ViewModifier {
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    func body(content: Content) -> some View {
        content
            .id("localized_\(localizationManager.currentLanguage.rawValue)_\(localizationManager.uiUpdateTrigger)")
            .animation(.easeInOut(duration: 0.3), value: localizationManager.currentLanguage)
    }
}

extension View {
    func localized() -> some View {
        self.modifier(LocalizedViewModifier())
    }
    
    /// Force a complete re-render when language changes - use this on root views
    func localizedRoot() -> some View {
        LocalizedRootView {
            self
        }
    }
}

// MARK: - Force Rerender Root View
struct LocalizedRootView<Content: View>: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .id("root_\(localizationManager.currentLanguage.rawValue)_\(localizationManager.uiUpdateTrigger)")
            .transition(.asymmetric(
                insertion: .opacity.combined(with: .scale(scale: 0.8)).combined(with: .move(edge: .trailing)),
                removal: .opacity.combined(with: .scale(scale: 1.2)).combined(with: .move(edge: .leading))
            ))
            .animation(.easeInOut(duration: 0.4), value: localizationManager.currentLanguage)
    }
}