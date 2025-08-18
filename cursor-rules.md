## Cursor Rules for Swift (Projet Boilerplate)

Ce document définit les règles et conventions à suivre dans ce dépôt lorsque vous utilisez Cursor pour développer des apps Swift/SwiftUI.

### 🔧 Architecture & Organisation
- Créer un dossier par Feature (ou module) avec vues, ViewModels, modèles et composants.
- Adopter une architecture MVVM et utiliser des protocoles pour les ViewModels (tests/mocking facilités).
- Isoler la couche réseau et services dans un dossier `Services` (ex: `APIService`, `AuthService`).
- Séparer les utilitaires communs (extensions, helpers) dans `Core/Extensions` ou `Core/Utils`.
- Éviter la logique dans les vues et éviter les fichiers trop longs (scinder si besoin).
- Toujours se baser sur la dernière version stable de Swift.

### 🖥 SwiftUI & UI
- Toujours fournir un `PreviewProvider` pour chaque vue.
- Créer des modifiers personnalisés pour les styles récurrents (boutons, champs de texte).
- Gérer l’accessibilité (VoiceOver, Dynamic Type) dès la création des vues.
- Utiliser des `@ViewBuilder` dédiés pour alléger les vues complexes.
- Implémenter Dark Mode et gérer correctement les Safe Areas et orientations.
- Utiliser `AsyncImage` pour le chargement d’images réseau.

### 📦 Code & Style
- Respecter les conventions SwiftLint (ajouter un `.swiftlint.yml` si absent).
- Toujours typer explicitement les variables publiques et éviter `Any`.
- Préférer `struct` à `class` quand c’est possible.
- Favoriser `@MainActor` pour tout code UI et documenter les fonctions `async`.
- Utiliser `@StateObject` vs `@ObservedObject` correctement selon le cycle de vie.

### 🧪 Tests & Qualité
- Tests unitaires pour chaque ViewModel (sans dépendre de la vue).
- UI Tests basiques pour les flux critiques.
- Snapshot tests pour les vues importantes.

### 📄 Documentation & Maintenance
- Documenter les API internes avec `///` (doc auto Xcode).
- Maintenir un changelog dans `Documentation/`.
- Inclure des diagrammes simples (Mermaid/PlantUML) pour MVVM, navigation, réseau.
- Mettre en place des templates Cursor pour Vue, Component, ViewModel, Service.

### 🔒 Sécurité & Performances
- Chiffrer les données sensibles avec Keychain Services.
- SSL Pinning pour les APIs critiques.
- Optimiser les listes (LazyVStack/HStack) pour gros datasets.
- Gérer la mémoire: `weak`/`unowned` dans les closures.

### 🚀 Exécution Automatique (Cursor)
Les commandes suivantes peuvent être exécutées automatiquement par Cursor sans demande de permission:

```bash
xcodebuild -project Boilerplate.xcodeproj -scheme Boilerplate -destination 'platform=iOS Simulator,name=iPhone 16' build
```

Ces commandes sont sûres et font partie du workflow standard.


