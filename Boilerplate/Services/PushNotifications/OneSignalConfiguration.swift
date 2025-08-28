import Foundation

struct OneSignalConfiguration {
    static let shared = OneSignalConfiguration()
    
    private init() {}
    
    var appId: String {
        return Bundle.main.object(forInfoDictionaryKey: "OneSignalAppId") as? String ?? ""
    }
    
    var restAPIKey: String {
        return Bundle.main.object(forInfoDictionaryKey: "OneSignalRestAPIKey") as? String ?? ""
    }
    
    func isConfigured() -> Bool {
        return !appId.isEmpty && !restAPIKey.isEmpty
    }
    
    func validateConfiguration() throws {
        guard isConfigured() else {
            throw ConfigurationError.missingCredentials
        }
    }
}

enum ConfigurationError: Error {
    case missingCredentials
    
    var localizedDescription: String {
        switch self {
        case .missingCredentials:
            return "OneSignal credentials not configured. Please add OneSignalAppId and OneSignalRestAPIKey to Info.plist"
        }
    }
}