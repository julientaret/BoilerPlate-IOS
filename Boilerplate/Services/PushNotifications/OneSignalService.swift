import Foundation
import OneSignalFramework

class OneSignalService: ObservableObject {
    static let shared = OneSignalService()
    
    @Published var isInitialized = false
    @Published var playerId: String?
    @Published var pushToken: String?
    
    private init() {}
    
    func initialize(appId: String) {
        OneSignal.initialize(appId, withLaunchOptions: nil)
        OneSignal.Notifications.requestPermission({ accepted in
            print("User accepted notifications: \(accepted)")
        }, fallbackToSettings: true)
        
        setupNotificationHandlers()
        isInitialized = true
    }
    
    private func setupNotificationHandlers() {
        OneSignal.Notifications.addForegroundLifecycleListener(withBlock: { notificationReceivedEvent in
            let notification = notificationReceivedEvent.notification
            print("Notification received in foreground: \(notification.body ?? "")")
            
            notificationReceivedEvent.complete()
        })
        
        OneSignal.Notifications.addClickListener(withBlock: { result in
            let notification = result.notification
            print("Notification clicked: \(notification.body ?? "")")
        })
        
        OneSignal.Notifications.addPermissionObserver(withBlock: { state in
            print("Notification permission changed: \(state)")
        })
    }
    
    func setExternalUserId(_ userId: String) {
        OneSignal.User.addAlias(label: "external_id", id: userId)
    }
    
    func addTags(_ tags: [String: String]) {
        OneSignal.User.addTags(tags)
    }
    
    func removeTags(_ keys: [String]) {
        OneSignal.User.removeTags(keys)
    }
    
    func sendNotification(
        to userIds: [String],
        title: String,
        message: String,
        data: [String: Any]? = nil,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        var notification: [String: Any] = [
            "app_id": getAppId(),
            "include_external_user_ids": userIds,
            "headings": ["en": title],
            "contents": ["en": message]
        ]
        
        if let data = data {
            notification["data"] = data
        }
        
        sendNotificationRequest(notification: notification, completion: completion)
    }
    
    func sendNotificationToAll(
        title: String,
        message: String,
        data: [String: Any]? = nil,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        var notification: [String: Any] = [
            "app_id": getAppId(),
            "included_segments": ["All"],
            "headings": ["en": title],
            "contents": ["en": message]
        ]
        
        if let data = data {
            notification["data"] = data
        }
        
        sendNotificationRequest(notification: notification, completion: completion)
    }
    
    private func sendNotificationRequest(
        notification: [String: Any],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let url = URL(string: "https://onesignal.com/api/v1/notifications") else {
            completion(.failure(OneSignalError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(getRestAPIKey())", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: notification)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(.success(()))
                } else {
                    completion(.failure(OneSignalError.httpError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    private func getAppId() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "OneSignalAppId") as? String ?? ""
    }
    
    private func getRestAPIKey() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "OneSignalRestAPIKey") as? String ?? ""
    }
    
    func getPlayerId() -> String? {
        return OneSignal.User.pushSubscription.id
    }
    
    func getPushToken() -> String? {
        return OneSignal.User.pushSubscription.token
    }
    
    func logout() {
        OneSignal.User.removeAlias(label: "external_id")
        OneSignal.User.removeTags(OneSignal.User.getTags().keys.map { $0 })
    }
}

enum OneSignalError: Error {
    case invalidURL
    case httpError(Int)
    case notInitialized
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid OneSignal API URL"
        case .httpError(let code):
            return "HTTP Error: \(code)"
        case .notInitialized:
            return "OneSignal service not initialized"
        }
    }
}