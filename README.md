# Boilerplate iOS

Un projet boilerplate iOS utilisant Swift et SwiftUI avec une architecture par services.

## 📱 Configuration

- **iOS**: Version minimale iOS 18.5
- **Swift**: Dernière version (Swift 5.9+)
- **Framework**: SwiftUI
- **Architecture**: Services avec organisation Vue/Model/Component

## 🏗️ Architecture

Le projet suit une architecture par services où chaque fonctionnalité est organisée en dossiers contenant :

```
Services/
  ├── [ServiceName]/
  │   ├── View/          # Vues SwiftUI
  │   ├── Model/         # Modèles de données et logique métier
  │   └── Component/     # Composants réutilisables
  └── ...

Core/
  ├── Utils/            # Utilitaires partagés
  ├── Extensions/       # Extensions Swift
  └── Constants/        # Constantes de l'application
```

## ✨ Fonctionnalités implémentées

### 🚀 Splash Screen
- Animation fluide avec logo Swift
- Durée minimale de 2 secondes
- Transition en fade vers l'application principale
- Architecture respectée : View/Model/Component

**Fichiers :**
- `Services/Splash/View/SplashView.swift` - Vue principale du splash
- `Services/Splash/Model/SplashModel.swift` - Logique métier et timing
- `Services/Splash/Component/SplashLogoComponent.swift` - Composant logo animé
- `Core/Utils/AppCoordinator.swift` - Coordination de navigation

## 🛠️ Installation et utilisation

1. Cloner le projet
2. Ouvrir `Boilerplate.xcodeproj` dans Xcode
3. Sélectionner le simulateur iPhone 16
4. Appuyer sur `Cmd + R` pour lancer

## ✅ Tests

Le projet compile et fonctionne sur :
- iPhone 16 Simulator (iOS 18.5)
- Architecture arm64

## 🔄 Prochaines étapes

- [ ] Ajout d'autres services (Authentication, Network, etc.)
- [ ] Configuration des tests unitaires
- [ ] Implémentation de la navigation
- [ ] Ajout des constantes de style (couleurs, polices)

---

*Généré avec Swift et SwiftUI - Architecture services modulaire*