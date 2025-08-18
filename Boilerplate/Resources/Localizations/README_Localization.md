# 🌍 Système de Localisation - Guide d'Utilisation

## 📋 Vue d'ensemble

Ce système de localisation modulaire permet de gérer facilement plusieurs langues dans l'application avec une architecture découpée et maintenable.

## 🏗 Architecture

### Structure des fichiers
```
Resources/
└── Localizations/
    ├── Common_fr.json      // Textes communs (OK, Annuler, etc.)
    ├── Common_en.json
    ├── Common_es.json
    ├── Theme_fr.json       // Textes spécifiques au thème
    ├── Theme_en.json
    ├── Theme_es.json
    ├── Navigation_fr.json  // Textes de navigation
    ├── Navigation_en.json
    ├── Navigation_es.json
    ├── Buttons_fr.json     // Boutons spécifiques
    ├── Buttons_en.json
    ├── Buttons_es.json
    ├── Forms_fr.json       // Formulaires
    ├── Forms_en.json
    ├── Forms_es.json
    ├── Messages_fr.json    // Messages utilisateur
    ├── Messages_en.json
    └── Messages_es.json
```

### Langues supportées
- 🇫🇷 Français (fr) - Langue par défaut
- 🇬🇧 Anglais (en)
- 🇪🇸 Espagnol (es)

## 🚀 Utilisation

### 1. Utilisation simple avec L10n
```swift
Text(L10n.Common.ok.localized)
Text(L10n.Theme.themeSelection.localized)
Text(L10n.Navigation.home.localized)
```

### 2. Utilisation avec extension String
```swift
Text("ok".localized())
Text("theme".localized(module: "Theme"))
```

### 3. Utilisation avec paramètres
```swift
// Dans le fichier JSON: "welcome_user": "Bienvenue %@"
Text("welcome_user".localizedFormatted(module: "Messages", username))
```

### 4. Intégration dans les vues
```swift
struct MyView: View {
    var body: some View {
        VStack {
            Text(L10n.Common.appName.localized)
            // Autres éléments
        }
        .localized() // Pour réagir aux changements de langue
    }
}
```

## 🔧 Ajout d'une nouvelle clé de traduction

### 1. Ajouter dans les fichiers JSON
Exemple pour ajouter "new_feature" dans le module "Navigation":

**Navigation_fr.json:**
```json
{
  "home": "Accueil",
  "new_feature": "Nouvelle fonctionnalité"
}
```

**Navigation_en.json:**
```json
{
  "home": "Home",
  "new_feature": "New feature"
}
```

**Navigation_es.json:**
```json
{
  "home": "Inicio",
  "new_feature": "Nueva funcionalidad"
}
```

### 2. Ajouter dans L10n.swift
```swift
enum Navigation {
    static let home = LocalizedString("home", module: "Navigation")
    static let newFeature = LocalizedString("new_feature", module: "Navigation")
}
```

### 3. Utiliser dans le code
```swift
Text(L10n.Navigation.newFeature.localized)
```

## 📂 Ajout d'un nouveau module

### 1. Créer les fichiers JSON
```
NewModule_fr.json
NewModule_en.json
NewModule_es.json
```

### 2. Ajouter le module dans LocalizationManager.swift
```swift
let modules = [
    "Common",
    "Theme", 
    "Navigation",
    "Buttons",
    "Forms",
    "Messages",
    "NewModule"  // ← Ajouter ici
]
```

### 3. Ajouter l'enum dans L10n.swift
```swift
enum NewModule {
    static let myKey = LocalizedString("my_key", module: "NewModule")
}
```

## 🎛 Composants de sélection de langue

### LanguageSelector
Interface complète avec drapeaux et labels
```swift
LanguageSelector()
```

### CompactLanguageSelector
Version compacte avec picker segmenté
```swift
CompactLanguageSelector()
```

### SimpleLanguageToggle
Bouton simple pour basculer entre langues
```swift
SimpleLanguageToggle()
```

### LanguageMenu
Menu déroulant pour barres de navigation
```swift
LanguageMenu()
```

## 🔄 Changement de langue programmatique

```swift
@EnvironmentObject private var localizationManager: LocalizationManager

// Changer vers une langue spécifique
localizationManager.setLanguage(.english)

// Langue actuelle
let currentLanguage = localizationManager.currentLanguage
```

## 📱 Intégration dans l'app

### 1. Configuration dans App.swift
```swift
@main
struct MyApp: App {
    @StateObject private var localizationManager = LocalizationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(localizationManager)
        }
    }
}
```

### 2. Utilisation dans les vues
```swift
struct ContentView: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        VStack {
            Text(L10n.Common.appName.localized)
            LanguageSelector()
        }
        .localized() // Réagit aux changements de langue
    }
}
```

## ⚡ Bonnes pratiques

### ✅ À faire
- Utiliser des clés descriptives (`login_button` plutôt que `btn1`)
- Organiser les clés par modules logiques
- Tester toutes les langues avant publication
- Utiliser le modificateur `.localized()` sur les vues principales

### ❌ À éviter
- Mélanger les modules (mettre du contenu "Theme" dans "Common")
- Oublier de traduire dans toutes les langues
- Utiliser des clés trop génériques (`text1`, `label`)
- Oublier d'ajouter nouveaux modules dans LocalizationManager

## 🧪 Test et validation

1. **Changement de langue**: Vérifier que tous les textes se mettent à jour
2. **Clés manquantes**: Les clés non trouvées affichent la clé elle-même
3. **Persistence**: La langue sélectionnée est sauvegardée entre les sessions
4. **Détection système**: En mode "Auto", l'app suit les préférences système

---

📝 **Note**: Ce système est conçu pour être extensible. Ajoutez facilement de nouvelles langues en créant les fichiers JSON correspondants et en ajoutant la langue dans `SupportedLanguage`.