//
//  AuthenticationManager.swift
//  Boilerplate
//
//  Created by Julien TARET on 27/08/2025.
//

import Foundation
import SwiftUI

@MainActor
class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    
    @Published var authenticationState: AuthenticationState = .loading
    @Published var currentUser: AuthUser?
    @Published var currentSession: AuthSession?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let appWriteService = AppWriteService.shared
    private let userDefaults = UserDefaults.standard
    
    private init() {
        Task {
            await checkAuthenticationStatus()
        }
    }
    
    // MARK: - Authentication Status
    
    var isAuthenticated: Bool {
        switch authenticationState {
        case .authenticated:
            return true
        default:
            return false
        }
    }
    
    var isEmailVerified: Bool {
        return currentUser?.emailVerification ?? false
    }
    
    // MARK: - Authentication Methods
    
    func register(email: String, password: String, name: String) async {
        setLoading(true)
        clearError()
        
        do {
            let user = try await appWriteService.register(email: email, password: password, name: name)
            
            currentUser = user
            authenticationState = .authenticated(user)
            
            await getCurrentSession()
            
        } catch {
            handleError(error)
        }
        
        setLoading(false)
    }
    
    func login(email: String, password: String) async {
        setLoading(true)
        clearError()
        
        do {
            let session = try await appWriteService.login(email: email, password: password)
            let user = try await appWriteService.getCurrentUser()
            
            currentSession = session
            currentUser = user
            authenticationState = .authenticated(user ?? AuthUser(
                id: "",
                email: email,
                name: "",
                emailVerification: false,
                registration: Date(),
                status: true,
                passwordUpdate: Date(),
                prefs: nil
            ))
            
            saveAuthenticationData()
            
        } catch {
            handleError(error)
        }
        
        setLoading(false)
    }
    
    func logout() async {
        setLoading(true)
        
        do {
            try await appWriteService.logout()
            await clearAuthenticationData()
            
        } catch {
            // Even if logout fails on server, clear local data
            await clearAuthenticationData()
            print("Logout error: \(error.localizedDescription)")
        }
        
        setLoading(false)
    }
    
    func logoutFromAllDevices() async {
        setLoading(true)
        
        do {
            try await appWriteService.logoutFromAllDevices()
            await clearAuthenticationData()
            
        } catch {
            await clearAuthenticationData()
            handleError(error)
        }
        
        setLoading(false)
    }
    
    // MARK: - Password Recovery
    
    func sendPasswordRecovery(email: String) async {
        setLoading(true)
        clearError()
        
        do {
            try await appWriteService.sendPasswordRecovery(email: email)
            
        } catch {
            handleError(error)
        }
        
        setLoading(false)
    }
    
    func completePasswordRecovery(userId: String, secret: String, password: String) async {
        setLoading(true)
        clearError()
        
        do {
            try await appWriteService.completePasswordRecovery(userId: userId, secret: secret, password: password)
            
        } catch {
            handleError(error)
        }
        
        setLoading(false)
    }
    
    // MARK: - Email Verification
    
    func sendEmailVerification() async {
        setLoading(true)
        clearError()
        
        do {
            try await appWriteService.sendEmailVerification()
            
        } catch {
            handleError(error)
        }
        
        setLoading(false)
    }
    
    func verifyEmail(userId: String, secret: String) async {
        setLoading(true)
        clearError()
        
        do {
            try await appWriteService.verifyEmail(userId: userId, secret: secret)
            
            // Refresh user data to get updated verification status
            await refreshUserData()
            
        } catch {
            handleError(error)
        }
        
        setLoading(false)
    }
    
    // MARK: - Profile Management
    
    func updateProfile(name: String) async {
        setLoading(true)
        clearError()
        
        do {
            let updatedUser = try await appWriteService.updateProfile(name: name)
            currentUser = updatedUser
            authenticationState = .authenticated(updatedUser)
            
            saveAuthenticationData()
            
        } catch {
            handleError(error)
        }
        
        setLoading(false)
    }
    
    func updateEmail(email: String, password: String) async {
        setLoading(true)
        clearError()
        
        do {
            let updatedUser = try await appWriteService.updateEmail(email: email, password: password)
            currentUser = updatedUser
            authenticationState = .authenticated(updatedUser)
            
            saveAuthenticationData()
            
        } catch {
            handleError(error)
        }
        
        setLoading(false)
    }
    
    func updatePassword(oldPassword: String, newPassword: String) async {
        setLoading(true)
        clearError()
        
        do {
            let updatedUser = try await appWriteService.updatePassword(oldPassword: oldPassword, newPassword: newPassword)
            currentUser = updatedUser
            
        } catch {
            handleError(error)
        }
        
        setLoading(false)
    }
    
    // MARK: - OAuth Authentication
    
    func loginWithOAuth(provider: OAuthProvider) async {
        setLoading(true)
        clearError()
        
        do {
            let session = try await appWriteService.loginWithOAuth(provider: provider)
            let user = try await appWriteService.getCurrentUser()
            
            currentSession = session
            currentUser = user
            authenticationState = .authenticated(user ?? AuthUser(
                id: "",
                email: "",
                name: "",
                emailVerification: false,
                registration: Date(),
                status: true,
                passwordUpdate: Date(),
                prefs: nil
            ))
            
            saveAuthenticationData()
            
        } catch {
            handleError(error)
        }
        
        setLoading(false)
    }
    
    // MARK: - Private Methods
    
    private func checkAuthenticationStatus() async {
        setLoading(true)
        
        do {
            let user = try await appWriteService.getCurrentUser()
            let session = try await appWriteService.getCurrentSession()
            
            if let user = user {
                currentUser = user
                currentSession = session
                authenticationState = .authenticated(user)
            } else {
                authenticationState = .unauthenticated
            }
            
        } catch {
            authenticationState = .unauthenticated
            await clearAuthenticationData()
        }
        
        setLoading(false)
    }
    
    private func getCurrentSession() async {
        do {
            let session = try await appWriteService.getCurrentSession()
            currentSession = session
        } catch {
            print("Failed to get current session: \(error.localizedDescription)")
        }
    }
    
    private func refreshUserData() async {
        do {
            let user = try await appWriteService.getCurrentUser()
            if let user = user {
                currentUser = user
                authenticationState = .authenticated(user)
                saveAuthenticationData()
            }
        } catch {
            print("Failed to refresh user data: \(error.localizedDescription)")
        }
    }
    
    private func saveAuthenticationData() {
        guard let user = currentUser else { return }
        
        if let userData = try? JSONEncoder().encode(user) {
            userDefaults.set(userData, forKey: "current_user")
        }
        
        if let session = currentSession,
           let sessionData = try? JSONEncoder().encode(session) {
            userDefaults.set(sessionData, forKey: "current_session")
        }
    }
    
    private func clearAuthenticationData() async {
        currentUser = nil
        currentSession = nil
        authenticationState = .unauthenticated
        
        userDefaults.removeObject(forKey: "current_user")
        userDefaults.removeObject(forKey: "current_session")
    }
    
    private func setLoading(_ loading: Bool) {
        isLoading = loading
    }
    
    private func clearError() {
        errorMessage = nil
    }
    
    private func handleError(_ error: Error) {
        if let appWriteError = error as? AppWriteError {
            errorMessage = appWriteError.localizedDescription
            authenticationState = .error(appWriteError)
        } else {
            errorMessage = error.localizedDescription
            authenticationState = .error(.unknownError)
        }
    }
}

// MARK: - Authentication Manager Extensions

extension AuthenticationManager {
    
    func handleDeepLink(url: URL) async {
        guard url.scheme == AppWriteConfiguration.urlScheme else { return }
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        switch url.host {
        case "oauth-success":
            await handleOAuthSuccess(components: components)
        case "oauth-failure":
            handleOAuthFailure(components: components)
        case "verify-email":
            await handleEmailVerification(components: components)
        case "reset-password":
            handlePasswordReset(components: components)
        default:
            break
        }
    }
    
    private func handleOAuthSuccess(components: URLComponents?) async {
        await refreshUserData()
    }
    
    private func handleOAuthFailure(components: URLComponents?) {
        let error = components?.queryItems?.first(where: { $0.name == "error" })?.value ?? "OAuth authentication failed"
        errorMessage = error
    }
    
    private func handleEmailVerification(components: URLComponents?) async {
        guard let userId = components?.queryItems?.first(where: { $0.name == "userId" })?.value,
              let secret = components?.queryItems?.first(where: { $0.name == "secret" })?.value else {
            errorMessage = "Invalid email verification link"
            return
        }
        
        await verifyEmail(userId: userId, secret: secret)
    }
    
    private func handlePasswordReset(components: URLComponents?) {
        // Handle password reset deep link
        // This would typically navigate to a password reset screen
    }
}