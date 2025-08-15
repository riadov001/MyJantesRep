# Guide de Dépannage Codemagic - MyJantes Manager

## 🚨 Solutions aux Erreurs Courantes

### 1. Configuration Simplifiée
J'ai créé une nouvelle configuration `codemagic.yaml` simplifiée qui évite les erreurs communes :
- ✅ Suppression des dépendances de signature complexes
- ✅ Utilisation de versions stables
- ✅ Build APK sans signature pour commencer
- ✅ IPA généré sans code signing

### 2. Erreurs de Version Flutter
**Problème** : "Flutter version mismatch"
```yaml
# Solution dans codemagic.yaml
environment:
  flutter: stable  # Au lieu d'une version spécifique
```

### 3. Erreurs de Build Android
**Problème** : Gradle out of memory
```yaml
# Solution ajoutée
vars:
  JAVA_TOOL_OPTIONS: "-Xmx3g"
```

### 4. Erreurs iOS
**Problème** : Code signing errors
```bash
# Solution : Build sans signature d'abord
flutter build ios --release --no-codesign
```

## 📝 Étapes pour Configurer Codemagic

### Méthode 1 : Configuration Automatique (Recommandée)
1. **Connectez votre dépôt** :
   - Allez sur [codemagic.io](https://codemagic.io)
   - Connectez votre compte GitHub/GitLab
   - Sélectionnez votre projet MyJantes Manager

2. **Laissez Codemagic détecter** :
   - Codemagic détecte automatiquement les projets Flutter
   - Utilisez la configuration par défaut pour commencer

3. **Première Build** :
   - Lancez un build Android uniquement
   - Vérifiez que l'APK se génère correctement

### Méthode 2 : Configuration YAML (Avancée)
1. **Utilisez le fichier `codemagic.yaml`** que j'ai créé
2. **Modifiez l'email** dans la section publishing
3. **Commitez le fichier** dans votre dépôt

## 🔧 Diagnostic Étape par Étape

### Si le Build Échoue :

1. **Vérifiez les Logs** :
   ```
   Dans Codemagic → Builds → [Votre Build] → Logs
   ```

2. **Erreurs Communes et Solutions** :

   **Erreur** : `Could not find flutter`
   ```yaml
   # Solution : Spécifier la version
   environment:
     flutter: stable
   ```

   **Erreur** : `Gradle build failed`
   ```yaml
   # Solution : Nettoyer avant build
   scripts:
     - name: Clean
       script: flutter clean
   ```

   **Erreur** : `Pod install failed`
   ```yaml
   # Solution : Installer pods explicitement
   scripts:
     - name: Install pods
       script: cd ios && pod install
   ```

### Builds de Test Rapides

Pour tester rapidement, créez ce workflow minimal :

```yaml
workflows:
  quick-test:
    name: Test Build
    environment:
      flutter: stable
    scripts:
      - flutter pub get
      - flutter build apk --debug
    artifacts:
      - build/app/outputs/flutter-apk/*.apk
```

## 📱 Alternative : GitHub Actions (Plus Simple)

Si Codemagic continue à échouer, utilisez GitHub Actions :

1. **Poussez votre code sur GitHub**
2. **Le workflow `.github/workflows/flutter_build.yml`** se lance automatiquement
3. **Téléchargez les APK/IPA** depuis l'onglet Actions

## 🆘 Support Urgent

**Option 1 : Build Local avec Docker**
```bash
# Si vous avez Docker installé
docker run --rm -v $(pwd):/project cirrusci/flutter:stable sh -c "cd /project && flutter build apk"
```

**Option 2 : Utiliser Replit Deployments**
```bash
# Déployez la version web depuis Replit
# Puis partagez le lien pour tester sur mobile
```

## ✅ Check-list Avant Build

- [ ] Code poussé sur GitHub/GitLab
- [ ] `pubspec.yaml` valide
- [ ] Pas d'erreurs dans `flutter analyze`
- [ ] Build local fonctionne : `flutter build apk --debug`
- [ ] Fichier `codemagic.yaml` présent (optionnel)

## 📞 Prochaines Étapes

1. **Essayez la configuration simplifiée** que j'ai créée
2. **Si ça échoue encore**, utilisez GitHub Actions
3. **En dernier recours**, nous pouvons créer un build Docker local

Dites-moi quelle erreur spécifique vous voyez dans Codemagic, et je vous aiderai à la résoudre !