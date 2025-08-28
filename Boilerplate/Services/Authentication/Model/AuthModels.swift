//
//  AuthModels.swift
//  Boilerplate
//
//  Created by Julien TARET on 27/08/2025.
//

import Foundation

// MARK: - Auth User Model
struct AuthUser: Codable, Identifiable {
    let id: String
    let email: String
    let name: String
    let emailVerification: Bool
    let registration: Date
    let status: Bool
    let passwordUpdate: Date
    let prefs: [String: Any]?
    
    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case email
        case name
        case emailVerification
        case registration
        case status
        case passwordUpdate
        case prefs
    }
    
    // Normal initializer
    init(id: String, email: String, name: String, emailVerification: Bool, registration: Date, status: Bool, passwordUpdate: Date, prefs: [String: Any]?) {
        self.id = id
        self.email = email
        self.name = name
        self.emailVerification = emailVerification
        self.registration = registration
        self.status = status
        self.passwordUpdate = passwordUpdate
        self.prefs = prefs
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        name = try container.decode(String.self, forKey: .name)
        emailVerification = try container.decode(Bool.self, forKey: .emailVerification)
        status = try container.decode(Bool.self, forKey: .status)
        
        let registrationString = try container.decode(String.self, forKey: .registration)
        registration = ISO8601DateFormatter().date(from: registrationString) ?? Date()
        
        let passwordUpdateString = try container.decode(String.self, forKey: .passwordUpdate)
        passwordUpdate = ISO8601DateFormatter().date(from: passwordUpdateString) ?? Date()
        
        // Handle [String: Any] which is not directly Codable
        if let prefsData = try container.decodeIfPresent(Data.self, forKey: .prefs),
           let prefsDict = try? JSONSerialization.jsonObject(with: prefsData, options: []) as? [String: Any] {
            prefs = prefsDict
        } else {
            prefs = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(email, forKey: .email)
        try container.encode(name, forKey: .name)
        try container.encode(emailVerification, forKey: .emailVerification)
        try container.encode(status, forKey: .status)
        try container.encode(ISO8601DateFormatter().string(from: registration), forKey: .registration)
        try container.encode(ISO8601DateFormatter().string(from: passwordUpdate), forKey: .passwordUpdate)
        
        // Handle [String: Any] which is not directly Codable
        if let prefs = prefs {
            let prefsData = try JSONSerialization.data(withJSONObject: prefs, options: [])
            try container.encode(prefsData, forKey: .prefs)
        }
    }
    
    // Convenience initializer for AppWrite User object
    // init(from appwriteUser: User) {
    //     self.id = appwriteUser.$id
    //     self.email = appwriteUser.email
    //     self.name = appwriteUser.name
    //     self.emailVerification = appwriteUser.emailVerification
    //     self.registration = appwriteUser.registration
    //     self.status = appwriteUser.status
    //     self.passwordUpdate = appwriteUser.passwordUpdate
    //     self.prefs = appwriteUser.prefs
    // }
}

// MARK: - Auth Session Model
struct AuthSession: Codable, Identifiable {
    let id: String
    let userId: String
    let createdAt: Date
    let updatedAt: Date
    let provider: String
    let providerUid: String
    let providerAccessToken: String
    let providerAccessTokenExpiry: Date
    let providerRefreshToken: String
    let ip: String
    let osCode: String
    let osName: String
    let osVersion: String
    let clientType: String
    let clientCode: String
    let clientName: String
    let clientVersion: String
    let clientEngine: String
    let clientEngineVersion: String
    let deviceName: String
    let deviceBrand: String
    let deviceModel: String
    let countryCode: String
    let countryName: String
    let current: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case userId
        case createdAt = "$createdAt"
        case updatedAt = "$updatedAt"
        case provider
        case providerUid
        case providerAccessToken
        case providerAccessTokenExpiry
        case providerRefreshToken
        case ip
        case osCode
        case osName
        case osVersion
        case clientType
        case clientCode
        case clientName
        case clientVersion
        case clientEngine
        case clientEngineVersion
        case deviceName
        case deviceBrand
        case deviceModel
        case countryCode
        case countryName
        case current
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        userId = try container.decode(String.self, forKey: .userId)
        provider = try container.decode(String.self, forKey: .provider)
        providerUid = try container.decode(String.self, forKey: .providerUid)
        providerAccessToken = try container.decode(String.self, forKey: .providerAccessToken)
        providerRefreshToken = try container.decode(String.self, forKey: .providerRefreshToken)
        ip = try container.decode(String.self, forKey: .ip)
        osCode = try container.decode(String.self, forKey: .osCode)
        osName = try container.decode(String.self, forKey: .osName)
        osVersion = try container.decode(String.self, forKey: .osVersion)
        clientType = try container.decode(String.self, forKey: .clientType)
        clientCode = try container.decode(String.self, forKey: .clientCode)
        clientName = try container.decode(String.self, forKey: .clientName)
        clientVersion = try container.decode(String.self, forKey: .clientVersion)
        clientEngine = try container.decode(String.self, forKey: .clientEngine)
        clientEngineVersion = try container.decode(String.self, forKey: .clientEngineVersion)
        deviceName = try container.decode(String.self, forKey: .deviceName)
        deviceBrand = try container.decode(String.self, forKey: .deviceBrand)
        deviceModel = try container.decode(String.self, forKey: .deviceModel)
        countryCode = try container.decode(String.self, forKey: .countryCode)
        countryName = try container.decode(String.self, forKey: .countryName)
        current = try container.decode(Bool.self, forKey: .current)
        
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        createdAt = ISO8601DateFormatter().date(from: createdAtString) ?? Date()
        
        let updatedAtString = try container.decode(String.self, forKey: .updatedAt)
        updatedAt = ISO8601DateFormatter().date(from: updatedAtString) ?? Date()
        
        let providerAccessTokenExpiryString = try container.decode(String.self, forKey: .providerAccessTokenExpiry)
        providerAccessTokenExpiry = ISO8601DateFormatter().date(from: providerAccessTokenExpiryString) ?? Date()
    }
    
    // Convenience initializer for AppWrite Session object
    // init(from appwriteSession: Session) {
    //     self.id = appwriteSession.$id
    //     self.userId = appwriteSession.userId
    //     self.createdAt = appwriteSession.$createdAt
    //     self.updatedAt = appwriteSession.$updatedAt
    //     self.provider = appwriteSession.provider
    //     self.providerUid = appwriteSession.providerUid
    //     self.providerAccessToken = appwriteSession.providerAccessToken
    //     self.providerAccessTokenExpiry = appwriteSession.providerAccessTokenExpiry
    //     self.providerRefreshToken = appwriteSession.providerRefreshToken
    //     self.ip = appwriteSession.ip
    //     self.osCode = appwriteSession.osCode
    //     self.osName = appwriteSession.osName
    //     self.osVersion = appwriteSession.osVersion
    //     self.clientType = appwriteSession.clientType
    //     self.clientCode = appwriteSession.clientCode
    //     self.clientName = appwriteSession.clientName
    //     self.clientVersion = appwriteSession.clientVersion
    //     self.clientEngine = appwriteSession.clientEngine
    //     self.clientEngineVersion = appwriteSession.clientEngineVersion
    //     self.deviceName = appwriteSession.deviceName
    //     self.deviceBrand = appwriteSession.deviceBrand
    //     self.deviceModel = appwriteSession.deviceModel
    //     self.countryCode = appwriteSession.countryCode
    //     self.countryName = appwriteSession.countryName
    //     self.current = appwriteSession.current
    // }
}

// MARK: - OAuth Provider Enum
enum OAuthProvider: String, CaseIterable {
    case google = "google"
    case apple = "apple"
    case facebook = "facebook"
    case github = "github"
    case discord = "discord"
    case microsoft = "microsoft"
    
    var displayName: String {
        switch self {
        case .google: return "Google"
        case .apple: return "Apple"
        case .facebook: return "Facebook"
        case .github: return "GitHub"
        case .discord: return "Discord"
        case .microsoft: return "Microsoft"
        }
    }
    
    var iconName: String {
        switch self {
        case .google: return "g.circle.fill"
        case .apple: return "applelogo"
        case .facebook: return "f.circle.fill"
        case .github: return "circle.fill"
        case .discord: return "gamecontroller.fill"
        case .microsoft: return "microsoft.logo"
        }
    }
}

// MARK: - Authentication State
enum AuthenticationState {
    case loading
    case authenticated(AuthUser)
    case unauthenticated
    case error(AppWriteError)
}

// MARK: - AppWrite Error Types
enum AppWriteError: Error, LocalizedError {
    case notImplemented
    case invalidCredentials
    case userNotFound
    case userAlreadyExists
    case emailNotVerified
    case sessionExpired
    case networkError
    case serverError(String)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .notImplemented:
            return "Cette fonctionnalité n'est pas encore implémentée"
        case .invalidCredentials:
            return "Identifiants invalides"
        case .userNotFound:
            return "Utilisateur introuvable"
        case .userAlreadyExists:
            return "Un utilisateur avec cet email existe déjà"
        case .emailNotVerified:
            return "Email non vérifié"
        case .sessionExpired:
            return "Session expirée"
        case .networkError:
            return "Erreur de réseau"
        case .serverError(let message):
            return "Erreur serveur: \(message)"
        case .unknownError:
            return "Erreur inconnue"
        }
    }
}