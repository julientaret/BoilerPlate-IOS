import Foundation

struct PushNotificationPayload {
    let title: String
    let message: String
    let data: [String: Any]?
    
    init(title: String, message: String, data: [String: Any]? = nil) {
        self.title = title
        self.message = message
        self.data = data
    }
}

struct NotificationTarget {
    enum TargetType {
        case userIds([String])
        case tags([String: String])
        case segments([String])
        case all
    }
    
    let type: TargetType
    
    static func users(_ userIds: [String]) -> NotificationTarget {
        return NotificationTarget(type: .userIds(userIds))
    }
    
    static func tags(_ tags: [String: String]) -> NotificationTarget {
        return NotificationTarget(type: .tags(tags))
    }
    
    static func segments(_ segments: [String]) -> NotificationTarget {
        return NotificationTarget(type: .segments(segments))
    }
    
    static let allUsers = NotificationTarget(type: .all)
}

struct NotificationResponse: Codable {
    let id: String?
    let recipients: Int?
    let errors: [String]?
}

struct UserTag {
    let key: String
    let value: String
    
    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}

extension UserTag {
    static func language(_ language: String) -> UserTag {
        return UserTag(key: "language", value: language)
    }
    
    static func userType(_ type: String) -> UserTag {
        return UserTag(key: "user_type", value: type)
    }
    
    static func subscription(_ isSubscribed: Bool) -> UserTag {
        return UserTag(key: "subscription", value: isSubscribed ? "premium" : "free")
    }
}