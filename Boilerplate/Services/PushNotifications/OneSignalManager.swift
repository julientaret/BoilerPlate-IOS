import SwiftUI

@MainActor
class OneSignalManager: ObservableObject {
    @Published var isPermissionGranted = false
    @Published var currentUserId: String?
    @Published var userTags: [String: String] = [:]
    
    private let oneSignalService = OneSignalService.shared
    
    init() {
        setupObservers()
    }
    
    private func setupObservers() {
        
    }
    
    func requestNotificationPermission() async {
        
    }
    
    func setUser(_ userId: String) {
        currentUserId = userId
        oneSignalService.setExternalUserId(userId)
    }
    
    func updateUserTags(_ tags: [String: String]) {
        userTags.merge(tags) { _, new in new }
        oneSignalService.addTags(tags)
    }
    
    func removeUserTags(_ keys: [String]) {
        for key in keys {
            userTags.removeValue(forKey: key)
        }
        oneSignalService.removeTags(keys)
    }
    
    func clearUser() {
        currentUserId = nil
        userTags.removeAll()
        oneSignalService.logout()
    }
    
    func sendWelcomeNotification(to userId: String) {
        let payload = PushNotificationPayload(
            title: "Bienvenue !",
            message: "Merci de rejoindre notre application !",
            data: ["action": "welcome", "screen": "home"]
        )
        
        oneSignalService.sendNotification(
            to: [userId],
            title: payload.title,
            message: payload.message,
            data: payload.data
        ) { result in
            switch result {
            case .success:
                print("Notification de bienvenue envoyée avec succès")
            case .failure(let error):
                print("Erreur lors de l'envoi de la notification: \(error)")
            }
        }
    }
    
    func sendBroadcastNotification(title: String, message: String, data: [String: Any]? = nil) {
        oneSignalService.sendNotificationToAll(
            title: title,
            message: message,
            data: data
        ) { result in
            switch result {
            case .success:
                print("Notification diffusée avec succès")
            case .failure(let error):
                print("Erreur lors de la diffusion: \(error)")
            }
        }
    }
}