#!/bin/bash

# Script pour ajouter les permissions calendrier au projet Xcode

PROJECT_FILE="/Users/julientaret/Applis/Boilerplate/Boilerplate.xcodeproj/project.pbxproj"

echo "Adding calendar permissions to Xcode project..."

# Backup du fichier projet
cp "$PROJECT_FILE" "$PROJECT_FILE.backup"

# Ajouter les permissions dans le projet
# Ces modifications devront être faites manuellement dans Xcode

echo "Pour configurer les permissions manuellement dans Xcode:"
echo ""
echo "1. Ouvre le projet Boilerplate.xcodeproj dans Xcode"
echo "2. Clique sur le projet 'Boilerplate' (en haut à gauche)"
echo "3. Sélectionne le target 'Boilerplate'" 
echo "4. Va dans l'onglet 'Info'"
echo "5. Dans 'Custom iOS Target Properties', ajoute:"
echo ""
echo "   Key: NSCalendarsUsageDescription"
echo "   Type: String"
echo "   Value: Cette application utilise le calendrier pour créer et gérer vos événements"
echo ""
echo "   Key: NSCalendarsFullAccessUsageDescription" 
echo "   Type: String"
echo "   Value: Accès complet au calendrier nécessaire pour toutes les fonctionnalités"
echo ""
echo "6. Build et teste l'app"
echo ""
echo "Alternative: Reset du simulateur"
echo "Device > Erase All Content and Settings dans le simulateur"

# Instructions pour reset simulateur
echo ""
echo "IMPORTANT pour simulateur:"
echo "Si les permissions ne fonctionnent toujours pas:"
echo "1. Ferme le simulateur"
echo "2. Lance: xcrun simctl erase all"
echo "3. Redémarre Xcode"
echo "4. Relance l'app"