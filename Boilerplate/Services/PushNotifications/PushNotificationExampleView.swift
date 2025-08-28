import SwiftUI

struct PushNotificationExampleView: View {
    @StateObject private var oneSignalManager = OneSignalManager()
    @State private var testUserId = "user123"
    @State private var notificationTitle = "Test Notification"
    @State private var notificationMessage = "Ceci est un message de test"
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Configuration Utilisateur") {
                    HStack {
                        Text("User ID:")
                        TextField("Enter user ID", text: $testUserId)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    Button("Définir l'utilisateur") {
                        oneSignalManager.setUser(testUserId)
                        showAlert("Utilisateur défini: \(testUserId)")
                    }
                    
                    Button("Ajouter des tags") {
                        let tags = [
                            "language": "fr",
                            "user_type": "test",
                            "subscription": "free"
                        ]
                        oneSignalManager.updateUserTags(tags)
                        showAlert("Tags ajoutés: \(tags.keys.joined(separator: ", "))")
                    }
                    
                    Button("Se déconnecter") {
                        oneSignalManager.clearUser()
                        showAlert("Utilisateur déconnecté")
                    }
                }
                
                Section("Notifications de Test") {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Titre:")
                        TextField("Titre de la notification", text: $notificationTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("Message:")
                        TextField("Message de la notification", text: $notificationMessage, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(3...6)
                    }
                    
                    Button("Envoyer notification de bienvenue") {
                        oneSignalManager.sendWelcomeNotification(to: testUserId)
                        showAlert("Notification de bienvenue envoyée à \(testUserId)")
                    }
                    
                    Button("Envoyer notification personnalisée") {
                        oneSignalManager.sendBroadcastNotification(
                            title: notificationTitle,
                            message: notificationMessage,
                            data: ["action": "custom", "timestamp": "\(Date().timeIntervalSince1970)"]
                        )
                        showAlert("Notification personnalisée envoyée à tous les utilisateurs")
                    }
                }
                
                Section("Statut") {
                    HStack {
                        Text("OneSignal initialisé:")
                        Spacer()
                        Text(OneSignalService.shared.isInitialized ? "✅" : "❌")
                    }
                    
                    HStack {
                        Text("Utilisateur actuel:")
                        Spacer()
                        Text(oneSignalManager.currentUserId ?? "Aucun")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Nombre de tags:")
                        Spacer()
                        Text("\(oneSignalManager.userTags.count)")
                    }
                    
                    if !oneSignalManager.userTags.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Tags actifs:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            ForEach(Array(oneSignalManager.userTags.keys), id: \.self) { key in
                                Text("• \(key): \(oneSignalManager.userTags[key] ?? "")")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Section("Instructions") {
                    Text("1. Définissez un User ID pour identifier l'utilisateur")
                        .font(.caption)
                    Text("2. Ajoutez des tags pour la segmentation")
                        .font(.caption)
                    Text("3. Testez les notifications")
                        .font(.caption)
                    Text("⚠️ Les notifications ne fonctionnent que sur un appareil physique")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            .navigationTitle("Push Notifications Test")
            .alert("OneSignal", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func showAlert(_ message: String) {
        alertMessage = message
        showingAlert = true
    }
}

#Preview {
    PushNotificationExampleView()
}