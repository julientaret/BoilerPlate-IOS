# 📚 UI Library Documentation

Une librairie de composants UI réutilisables et personnalisables pour iOS en SwiftUI.

## 🏗️ Architecture

```
UILibrary/
├── Theme/                  # Système de thème centralisé
│   └── UITheme.swift      # Couleurs, typographie, espacements
├── Components/            # Composants réutilisables
│   ├── Button/           # Composants boutons
│   ├── Modal/            # Composants modaux et backgrounds
│   ├── Input/            # Composants de saisie
│   ├── Card/             # Composants cartes
│   ├── Badge/            # Composants badges
│   └── Loading/          # Indicateurs de chargement
└── Extensions/           # Extensions utilitaires
```

## 🎨 Système de Thème

### UITheme

Le système de thème centralise toutes les propriétés visuelles :

#### Couleurs
```swift
UITheme.Colors.primary        // Couleur principale
UITheme.Colors.secondary      // Couleur secondaire
UITheme.Colors.success        // Vert de succès
UITheme.Colors.warning        // Jaune d'avertissement
UITheme.Colors.error          // Rouge d'erreur
UITheme.Colors.background     // Fond principal
UITheme.Colors.surface        // Fond de surface
UITheme.Colors.textPrimary    // Texte principal
```

#### Typographie
```swift
UITheme.Typography.largeTitle
UITheme.Typography.title1
UITheme.Typography.headline
UITheme.Typography.body
UITheme.Typography.caption
```

#### Espacements
```swift
UITheme.Spacing.xs    // 4pt
UITheme.Spacing.sm    // 8pt
UITheme.Spacing.md    // 16pt
UITheme.Spacing.lg    // 24pt
UITheme.Spacing.xl    // 32pt
```

#### Rayons de coins
```swift
UITheme.CornerRadius.small        // 4pt
UITheme.CornerRadius.medium       // 8pt
UITheme.CornerRadius.large        // 12pt
UITheme.CornerRadius.extraLarge   // 16pt
```

#### Animations
```swift
UITheme.Animation.fast      // 0.2s
UITheme.Animation.medium    // 0.3s
UITheme.Animation.slow      // 0.5s
UITheme.Animation.spring    // Animation ressort
```

## 🔘 Composant UIButton

Bouton personnalisable avec plusieurs styles et tailles.

### Utilisation

```swift
// Bouton basique
UIButton(title: "Connexion", style: .primary) {
    // Action
}

// Bouton avec icône et chargement
UIButton(
    title: "Envoyer",
    style: .secondary,
    size: .large,
    isLoading: isSubmitting,
    icon: "paperplane"
) {
    submitForm()
}
```

### Paramètres

| Paramètre | Type | Description |
|-----------|------|-------------|
| `title` | `String` | Texte du bouton |
| `style` | `UIButtonStyle` | `.primary`, `.secondary`, `.tertiary`, `.destructive` |
| `size` | `UIButtonSize` | `.small`, `.medium`, `.large` |
| `isLoading` | `Bool` | Affiche un indicateur de chargement |
| `isDisabled` | `Bool` | Désactive le bouton |
| `icon` | `String?` | Icône SF Symbols |
| `action` | `() -> Void` | Action exécutée |

## 🪟 Composant UIModal

Modal personnalisable avec différents styles de présentation.

### Utilisation

```swift
UIModal(
    isPresented: $showModal,
    title: "Confirmation",
    style: .center,
    size: .medium
) {
    VStack {
        Text("Êtes-vous sûr ?")
        
        HStack {
            UIButton(title: "Annuler", style: .secondary) {
                showModal = false
            }
            UIButton(title: "Confirmer", style: .primary) {
                confirmAction()
            }
        }
    }
}
```

### Paramètres

| Paramètre | Type | Description |
|-----------|------|-------------|
| `isPresented` | `Binding<Bool>` | Contrôle l'affichage |
| `title` | `String?` | Titre de la modal |
| `style` | `UIModalPresentationStyle` | `.sheet`, `.fullScreen`, `.center` |
| `size` | `UIModalSize` | `.small`, `.medium`, `.large` |
| `showCloseButton` | `Bool` | Affiche le bouton fermer |

## 🌈 Composant UIBackground

Background personnalisable avec support des dégradés.

### Utilisation

```swift
// Fond uni
UIBackground(type: .solid(.blue))

// Dégradé personnalisé
UIBackground(
    type: .gradient(
        colors: [.blue, .purple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
)

// Backgrounds prédéfinis
UIBackground.primary
UIBackground.blueGradient
UIBackground.sunsetGradient
```

### Types disponibles

- `.solid(Color)` - Couleur unie
- `.gradient` - Dégradé linéaire
- `.radialGradient` - Dégradé radial
- `.image(String, ContentMode)` - Image de fond

## 📝 Composant UITextField

Champ de texte avec validation et styles multiples.

### Utilisation

```swift
UITextField(
    text: $email,
    placeholder: "votre@email.com",
    label: "Adresse email",
    style: .outlined,
    keyboardType: .emailAddress,
    errorMessage: emailError,
    leadingIcon: "envelope"
)
```

### Paramètres principaux

| Paramètre | Type | Description |
|-----------|------|-------------|
| `text` | `Binding<String>` | Texte du champ |
| `placeholder` | `String` | Texte placeholder |
| `label` | `String?` | Label au-dessus |
| `style` | `UITextFieldStyle` | `.outlined`, `.filled`, `.underlined` |
| `isSecure` | `Bool` | Champ mot de passe |
| `errorMessage` | `String?` | Message d'erreur |
| `leadingIcon` | `String?` | Icône à gauche |
| `trailingIcon` | `String?` | Icône à droite |

## 🃏 Composant UICard

Carte personnalisable avec interaction optionnelle.

### Utilisation

```swift
UICard(style: .elevated, onTap: { print("Tapped") }) {
    VStack(alignment: .leading) {
        Text("Titre de la carte")
            .font(UITheme.Typography.headline)
        
        Text("Description de la carte")
            .font(UITheme.Typography.body)
    }
}
```

### Styles disponibles

- `.elevated` - Carte avec ombre
- `.outlined` - Carte avec bordure
- `.filled` - Carte avec fond coloré

## 🏷️ Composant UIBadge

Badge informatif avec différents styles sémantiques.

### Utilisation

```swift
// Badge basique
UIBadge(text: "Nouveau", style: .success)

// Badge avec icône
UIBadge(
    text: "Premium", 
    style: .primary,
    size: .medium,
    icon: "crown.fill"
)

// Badges prédéfinis
UIBadge.new
UIBadge.popular  
UIBadge.premium
UIBadge.online
```

### Styles disponibles

- `.primary` - Badge principal (bleu)
- `.success` - Badge succès (vert)
- `.warning` - Badge attention (jaune)
- `.error` - Badge erreur (rouge)
- `.info` - Badge information (bleu clair)
- `.neutral` - Badge neutre (gris)

## ⏳ Composant UILoadingIndicator

Indicateur de chargement avec plusieurs animations.

### Utilisation

```swift
// Indicateur simple
UILoadingIndicator(
    style: .circular,
    size: .medium,
    message: "Chargement..."
)

// Indicateur plein écran
UIFullScreenLoading(message: "Synchronisation...")
```

### Styles d'animation

- `.circular` - Indicateur circulaire standard
- `.dots` - Animation avec points
- `.pulse` - Animation de pulsation  
- `.skeleton` - Style skeleton loading

## 🎯 Bonnes pratiques

### 1. Consistance visuelle
Toujours utiliser les valeurs du `UITheme` pour maintenir la cohérence :

```swift
.padding(UITheme.Spacing.md)
.font(UITheme.Typography.body)
.foregroundColor(UITheme.Colors.textPrimary)
```

### 2. Accessibilité
Les composants supportent automatiquement :
- Dark Mode
- Dynamic Type
- VoiceOver
- High Contrast

### 3. Performance
- Les animations utilisent les durées optimisées du thème
- Les composants sont optimisés pour SwiftUI
- Support des previews Xcode

### 4. Customisation
Tous les composants acceptent des modificateurs SwiftUI :

```swift
UIButton(title: "Test") {}
    .disabled(isLoading)
    .opacity(0.8)
    .scaleEffect(1.1)
```

## 📱 Exemples complets

### Formulaire de connexion

```swift
VStack(spacing: UITheme.Spacing.lg) {
    UITextField(
        text: $email,
        placeholder: "email@exemple.com",
        label: "Email",
        style: .outlined,
        keyboardType: .emailAddress,
        leadingIcon: "envelope"
    )
    
    UITextField(
        text: $password,
        placeholder: "Mot de passe",
        label: "Mot de passe",
        style: .outlined,
        isSecure: true,
        leadingIcon: "lock"
    )
    
    UIButton(
        title: "Se connecter",
        style: .primary,
        size: .large,
        isLoading: isLoading
    ) {
        signIn()
    }
}
.padding()
```

### Liste avec cartes

```swift
ScrollView {
    LazyVStack(spacing: UITheme.Spacing.md) {
        ForEach(items) { item in
            UICard(style: .elevated, onTap: {
                selectItem(item)
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .font(UITheme.Typography.headline)
                        
                        Text(item.subtitle)
                            .font(UITheme.Typography.body)
                            .foregroundColor(UITheme.Colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    if item.isNew {
                        UIBadge.new
                    }
                }
            }
        }
    }
    .padding()
}
```

---

*Documentation générée pour iOS Boilerplate UI Library*