# OneSignal Push Notifications Service

This service provides a complete implementation of OneSignal push notifications for iOS applications using SwiftUI.

## Features

- OneSignal SDK integration
- Push notification permissions handling
- User identification and tagging
- Send notifications to specific users, segments, or all users
- Handle notification clicks and foreground notifications
- User logout and cleanup

## Setup

### 1. Add OneSignal SDK

Add OneSignal to your Xcode project using Swift Package Manager:

```
https://github.com/OneSignal/OneSignal-iOS-SDK
```

### 2. Configure Info.plist

Add your OneSignal credentials to your `Info.plist`:

```xml
<key>OneSignalAppId</key>
<string>YOUR_ONESIGNAL_APP_ID</string>
<key>OneSignalRestAPIKey</key>
<string>YOUR_ONESIGNAL_REST_API_KEY</string>
```

### 3. Initialize in App

In your main App file (`BoilerplateApp.swift`):

```swift
import SwiftUI

@main
struct BoilerplateApp: App {
    
    init() {
        // Initialize OneSignal
        if OneSignalConfiguration.shared.isConfigured() {
            OneSignalService.shared.initialize(appId: OneSignalConfiguration.shared.appId)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 4. Add Notification Service Extension (Optional but Recommended)

For rich media notifications and better tracking:

1. In Xcode, go to File → New → Target
2. Choose "Notification Service Extension"
3. Name it "NotificationServiceExtension"
4. Add OneSignal SDK to the extension target
5. Replace the content of `NotificationService.swift`:

```swift
import UserNotifications
import OneSignalExtension

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var receivedRequest: UNNotificationRequest!
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.receivedRequest = request
        self.contentHandler = contentHandler
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            OneSignalExtension.didReceiveNotificationExtensionRequest(self.receivedRequest, with: bestAttemptContent, withContentHandler: self.contentHandler)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            OneSignalExtension.serviceExtensionTimeWillExpireRequest(self.receivedRequest, with: self.bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }
}
```

## Usage Examples

### Basic Usage

```swift
import SwiftUI

struct ContentView: View {
    @StateObject private var oneSignal = OneSignalService.shared
    
    var body: some View {
        VStack {
            Text("OneSignal Status: \\(oneSignal.isInitialized ? "Ready" : "Not Ready")")
            
            Button("Set User ID") {
                oneSignal.setExternalUserId("user123")
            }
            
            Button("Add Tags") {
                oneSignal.addTags([
                    "user_type": "premium",
                    "language": "en"
                ])
            }
            
            Button("Send Test Notification") {
                sendTestNotification()
            }
        }
    }
    
    private func sendTestNotification() {
        oneSignal.sendNotificationToAll(
            title: "Test Notification",
            message: "This is a test message from the app!",
            data: ["screen": "home"]
        ) { result in
            switch result {
            case .success:
                print("Notification sent successfully")
            case .failure(let error):
                print("Failed to send notification: \\(error)")
            }
        }
    }
}
```

### Advanced Usage with Models

```swift
// Send to specific users
let payload = PushNotificationPayload(
    title: "Welcome!",
    message: "Thanks for joining our app!",
    data: ["action": "welcome", "user_id": "123"]
)

let target = NotificationTarget.users(["user123", "user456"])

// Send notification (you'll need to implement this method)
// oneSignal.sendNotification(payload: payload, target: target) { result in ... }

// Add user tags
let tags = [
    UserTag.language("fr"),
    UserTag.userType("premium"),
    UserTag.subscription(true)
]

let tagDict = Dictionary(uniqueKeysWithValues: tags.map { ($0.key, $0.value) })
oneSignal.addTags(tagDict)
```

## Important Notes

1. **Permissions**: The service automatically requests notification permissions on initialization.

2. **Testing**: Use OneSignal dashboard to test notifications during development.

3. **User Identification**: Always set external user IDs for users to enable targeted notifications.

4. **Error Handling**: Always handle errors in completion handlers when sending notifications.

5. **Privacy**: Be mindful of user privacy when collecting tags and user data.

## Troubleshooting

- Ensure OneSignal credentials are correctly set in Info.plist
- Check that the OneSignal SDK is properly linked
- Verify notification permissions are granted
- Test on physical devices (push notifications don't work on simulator)

## API Reference

### OneSignalService

- `initialize(appId:)`: Initialize OneSignal with app ID
- `setExternalUserId(_:)`: Set external user ID for targeting
- `addTags(_:)`: Add tags for user segmentation
- `removeTags(_:)`: Remove specific tags
- `sendNotification(to:title:message:data:completion:)`: Send to specific users
- `sendNotificationToAll(title:message:data:completion:)`: Send to all users
- `getPlayerId()`: Get OneSignal player ID
- `getPushToken()`: Get push token
- `logout()`: Clean up user data on logout