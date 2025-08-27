# Boilerplate iOS

Un projet boilerplate iOS utilisant Swift et SwiftUI avec une architecture par services, incluant un système de localisation complet, une UI Library modulaire et un gestionnaire de thème avancé.

## 📱 Configuration

- **iOS**: Version minimale iOS 18.5
- **Swift**: Dernière version (Swift 5.9+)
- **Framework**: SwiftUI
- **Architecture**: Modulaire avec séparation Screens/Services

## 🏗️ Architecture

Le projet suit une architecture modulaire où les écrans et services sont séparés :

```
Screens/
  ├── [ScreenName]/
  │   ├── View/          # Vues SwiftUI
  │   ├── Model/         # Modèles de données et logique métier
  │   └── Component/     # Composants réutilisables
  └── ...

UILibrary/
  ├── Theme/            # Gestionnaire de thème
  ├── Components/       # Composants UI réutilisables
  └── ...

Core/
  ├── Utils/            # Utilitaires partagés
  ├── Extensions/       # Extensions Swift
  ├── Constants/        # Constantes de l'application
  ├── Localization/     # Système de localisation
  └── Navigation/       # Gestion de la navigation
```

## 🌍 Système de Localisation

### Architecture
Le système de localisation est basé sur une architecture modulaire et réactive :

```
Core/Localization/
├── LocalizationManager.swift    # Gestionnaire principal
├── LocalizedString.swift        # Protocoles et implémentations
└── Resources/Localizations/     # Fichiers JSON par langue
    ├── Common_en.json          # Anglais
    ├── Common_fr.json          # Français
    ├── Common_es.json          # Espagnol
    └── [Module]_[Lang].json    # Autres modules
```

### Fonctionnalités
- **Support multi-langues** : Anglais, Français, Espagnol
- **Modules séparés** : Common, Theme, Navigation, Buttons, Forms, Messages
- **Mise à jour dynamique** : Changement de langue en temps réel
- **Gestion des arguments** : Support des chaînes formatées
- **SwiftUI natif** : Composants `LocalizedText` et `L10nText`

### Utilisation

```swift
// Texte simple
LocalizedText("app_name", module: "Common")

// Avec L10nText (plus expressif)
L10nText.appName()

// Extension String
"welcome_message".localized(module: "Messages")

// Avec arguments
"hello_user".localizedFormatted(module: "Messages", "John")
```

### Composants SwiftUI
- `LocalizedText` : Composant de base pour la localisation
- `L10nText` : Composants pré-configurés par module
- `LocalizedViewModifier` : Modificateur pour la réactivité
- `LocalizedRootView` : Vue racine avec transitions

## 🎨 UI Library

### Architecture Modulaire
La UI Library est organisée en composants réutilisables et modulaires :

```
UILibrary/
├── Components/           # Composants UI
│   ├── Button/          # Boutons personnalisés
│   ├── Card/            # Cartes et conteneurs
│   ├── Input/           # Champs de saisie
│   ├── Modal/           # Modales et overlays
│   ├── Badge/           # Badges et étiquettes
│   ├── Loading/         # Indicateurs de chargement
│   ├── ThemeToggle/     # Sélecteurs de thème
│   └── Language/        # Sélecteurs de langue
├── Theme/               # Système de thème
├── Extensions/          # Extensions SwiftUI
└── Utilities/           # Utilitaires UI
```

### Composants Principaux

#### UIButton
- **Styles** : Primary, Secondary, Outline, Ghost
- **Tailles** : Small, Medium, Large
- **États** : Normal, Disabled, Loading
- **Personnalisation** : Icônes, badges, animations

#### UICard
- **Variantes** : Default, Elevated, Outlined
- **Contenu** : Header, Body, Footer
- **Interactions** : Tap, Long press, Swipe
- **Responsive** : Adaptation automatique au contenu

#### UIModal
- **Styles** : Center, Sheet, Fullscreen
- **Animations** : Transitions fluides et personnalisables
- **Tailles** : Small, Medium, Large, Custom
- **Gestion** : Présentation/dismiss automatique

#### UITextField
- **Types** : Text, Email, Password, Number
- **Validation** : États d'erreur et de succès
- **Accessibilité** : Support VoiceOver complet
- **Thème** : Intégration avec le système de thème

### Extensions et Modificateurs
- **CornerRadius** : Coins arrondis personnalisables
- **Shadows** : Système d'ombres cohérent
- **Animations** : Transitions et animations fluides
- **Responsive** : Adaptation aux différentes tailles d'écran

## 🌓 Theme Manager

### Architecture
Le système de thème est basé sur une architecture réactive et extensible :

```
UILibrary/Theme/
├── ThemeManager.swift    # Gestionnaire principal
└── UITheme.swift        # Définitions des thèmes
```

### Fonctionnalités
- **Thèmes** : Light, Dark, Auto (système)
- **Réactivité** : Mise à jour automatique de l'UI
- **Persistance** : Sauvegarde des préférences utilisateur
- **Transitions** : Animations fluides entre thèmes
- **Extensibilité** : Ajout facile de nouveaux thèmes

### Système de Couleurs
```swift
UITheme.Colors.primary(for: themeManager.isDarkMode)
UITheme.Colors.background(for: themeManager.isDarkMode)
UITheme.Colors.textPrimary(for: themeManager.isDarkMode)
UITheme.Colors.surface(for: themeManager.isDarkMode)
```

### Composants de Thème
- **ThemeToggleSwitch** : Switch principal pour le thème
- **CompactThemeSelector** : Sélecteur compact
- **SimpleThemeToggle** : Toggle simple
- **ColorPreviewCard** : Aperçu des couleurs du thème

### Intégration SwiftUI
```swift
@EnvironmentObject private var themeManager: ThemeManager

// Utilisation dans les vues
.background(UITheme.Colors.background(for: themeManager.isDarkMode))
.foregroundColor(UITheme.Colors.textPrimary(for: themeManager.isDarkMode))
```

## ✨ Fonctionnalités implémentées

### 🚀 Splash Screen
- Animation fluide avec logo Swift
- Durée minimale de 2 secondes
- Transition en fade vers l'application principale
- Architecture respectée : View/Model/Component

**Fichiers :**
- `Screens/Splash/View/SplashView.swift` - Vue principale du splash
- `Screens/Splash/Model/SplashModel.swift` - Logique métier et timing
- `Screens/Splash/Component/SplashLogoComponent.swift` - Composant logo animé
- `Core/Utils/AppCoordinator.swift` - Coordination de navigation

### 🎨 Interface Utilisateur
- **Système de thème complet** avec support Light/Dark/Auto
- **Composants UI modulaires** et réutilisables
- **Localisation multi-langues** avec mise à jour dynamique
- **Animations fluides** et transitions personnalisées
- **Support de l'accessibilité** (VoiceOver, Dynamic Type)

## 🛠️ Installation et utilisation

1. Cloner le projet
2. Ouvrir `Boilerplate.xcodeproj` dans Xcode
3. Sélectionner le simulateur iPhone 16
4. Appuyer sur `Cmd + R` pour lancer

## 🧪 Tests

Le projet compile et fonctionne sur :
- iPhone 16 Simulator (iOS 18.5)
- Architecture arm64

## 📚 Documentation

- **UILibrary** : `UILibrary-Documentation.md`
- **Localisation** : `Resources/Localizations/README_Localization.md`
- **Composants** : Chaque composant est documenté avec des exemples d'utilisation

## 🔧 Développement

### Ajouter un nouveau composant
1. Créer le dossier dans `UILibrary/Components/[Nom]`
2. Implémenter le composant avec `PreviewProvider`
3. Ajouter la documentation dans le composant
4. Tester la compilation

### Ajouter une nouvelle langue
1. Créer les fichiers JSON dans `Resources/Localizations/`
2. Ajouter la langue dans `LocalizationManager`
3. Tester avec `LanguageSelector`

### Créer un nouveau thème
1. Étendre `UITheme.Colors` avec les nouvelles couleurs
2. Ajouter les variantes Light/Dark
3. Mettre à jour `ThemeManager` si nécessaire