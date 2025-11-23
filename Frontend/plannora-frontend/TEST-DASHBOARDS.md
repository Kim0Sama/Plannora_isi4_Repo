# Tests des Dashboards - Plannora

## 🧪 Plan de Test

### Prérequis
- Backend démarré sur `http://localhost:8082`
- Base de données initialisée avec des utilisateurs de test
- Frontend démarré sur `http://localhost:4200`

## Test 1 : Connexion et Redirection Enseignant

### Étapes
1. Ouvrir `http://localhost:4200`
2. Vérifier la redirection automatique vers `/login`
3. Se connecter avec un compte ENSEIGNANT
4. Vérifier la redirection automatique vers `/enseignant-dashboard`

### Résultat Attendu
✅ Redirection automatique vers le dashboard enseignant
✅ Affichage du nom de l'enseignant dans le header
✅ Affichage des statistiques (nombre de cours, heures totales)
✅ Affichage du planning avec les cours

### Données de Test
```
Email: enseignant@test.com
Mot de passe: [votre mot de passe]
Rôle attendu: ENSEIGNANT
```

## Test 2 : Connexion et Redirection Administrateur

### Étapes
1. Se déconnecter si connecté
2. Se connecter avec un compte ADMIN
3. Vérifier la redirection automatique vers `/admin-dashboard`

### Résultat Attendu
✅ Redirection automatique vers le dashboard admin
✅ Affichage du nom de l'admin dans le header
✅ Affichage de la sidebar avec toutes les sections
✅ Affichage des statistiques globales
✅ Navigation entre les sections fonctionnelle

### Données de Test
```
Email: admin@test.com
Mot de passe: [votre mot de passe]
Rôle attendu: ADMIN
```

## Test 3 : Protection des Routes

### Test 3.1 : Accès Direct Sans Authentification
**Étapes :**
1. Se déconnecter
2. Essayer d'accéder directement à `/enseignant-dashboard`
3. Essayer d'accéder directement à `/admin-dashboard`

**Résultat Attendu :**
✅ Redirection automatique vers `/login` dans les deux cas

### Test 3.2 : Accès avec Mauvais Rôle
**Étapes :**
1. Se connecter en tant qu'ENSEIGNANT
2. Essayer d'accéder à `/admin-dashboard` via l'URL

**Résultat Attendu :**
✅ Redirection vers `/login` (accès refusé)

## Test 4 : Déconnexion

### Étapes
1. Se connecter avec n'importe quel compte
2. Cliquer sur le bouton "Déconnexion"

### Résultat Attendu
✅ Redirection vers `/login`
✅ Token supprimé du localStorage
✅ Données utilisateur supprimées du localStorage
✅ Impossible d'accéder aux dashboards sans se reconnecter

## Test 5 : Interface Dashboard Enseignant

### Test 5.1 : Affichage des Statistiques
**Vérifier :**
- ✅ Carte "Cours cette semaine" avec le bon nombre
- ✅ Carte "Heures totales" avec le calcul correct
- ✅ Icônes affichées correctement

### Test 5.2 : Affichage du Planning
**Vérifier :**
- ✅ Toutes les cartes de cours affichées
- ✅ Nom du cours visible
- ✅ Badge avec le jour de la semaine
- ✅ Icône de salle avec le numéro
- ✅ Icône d'horloge avec les horaires
- ✅ Effet hover sur les cartes

## Test 6 : Interface Dashboard Admin

### Test 6.1 : Navigation Sidebar
**Vérifier :**
- ✅ Toutes les sections du menu visibles
- ✅ Section active mise en évidence
- ✅ Changement de contenu au clic
- ✅ Icônes affichées correctement

### Test 6.2 : Vue d'Ensemble
**Vérifier :**
- ✅ 4 cartes de statistiques affichées
- ✅ Icônes et couleurs correctes
- ✅ Valeurs numériques visibles
- ✅ Effet hover sur les cartes

### Test 6.3 : Sections de Gestion
**Vérifier pour chaque section :**
- ✅ Titre de section correct
- ✅ Bouton "Ajouter" présent
- ✅ Message placeholder affiché

## Test 7 : Responsive Design

### Test 7.1 : Desktop (1920x1080)
**Vérifier :**
- ✅ Layout complet affiché
- ✅ Grilles en plusieurs colonnes
- ✅ Sidebar complète (admin)

### Test 7.2 : Tablet (768x1024)
**Vérifier :**
- ✅ Adaptation automatique des grilles
- ✅ Lisibilité maintenue
- ✅ Navigation fonctionnelle

### Test 7.3 : Mobile (375x667)
**Vérifier :**
- ✅ Grilles en une colonne
- ✅ Texte lisible
- ✅ Boutons accessibles

## Test 8 : Persistance de Session

### Étapes
1. Se connecter
2. Rafraîchir la page (F5)
3. Naviguer vers une autre route puis revenir

### Résultat Attendu
✅ Session maintenue après rafraîchissement
✅ Pas de redirection vers login
✅ Données utilisateur toujours affichées

## Test 9 : Gestion des Erreurs

### Test 9.1 : Token Expiré
**Simulation :**
1. Se connecter
2. Supprimer le token du localStorage manuellement
3. Essayer de naviguer

**Résultat Attendu :**
✅ Redirection vers `/login`

### Test 9.2 : Données Utilisateur Corrompues
**Simulation :**
1. Se connecter
2. Modifier les données dans localStorage
3. Rafraîchir la page

**Résultat Attendu :**
✅ Gestion gracieuse de l'erreur
✅ Pas de crash de l'application

## Test 10 : Performance

### Métriques à Vérifier
- ✅ Temps de chargement initial < 2s
- ✅ Temps de navigation entre sections < 100ms
- ✅ Pas de lag lors du hover
- ✅ Animations fluides

## 📊 Checklist Complète

### Fonctionnalités Essentielles
- [ ] Connexion enseignant
- [ ] Connexion administrateur
- [ ] Redirection automatique selon rôle
- [ ] Protection des routes
- [ ] Déconnexion
- [ ] Affichage des données utilisateur

### Dashboard Enseignant
- [ ] Statistiques affichées
- [ ] Planning affiché
- [ ] Calcul des heures correct
- [ ] Interface responsive

### Dashboard Admin
- [ ] Sidebar fonctionnelle
- [ ] Navigation entre sections
- [ ] Statistiques globales
- [ ] Toutes les sections accessibles

### Sécurité
- [ ] Routes protégées
- [ ] Vérification des rôles
- [ ] Token JWT validé
- [ ] Déconnexion sécurisée

### UX/UI
- [ ] Design cohérent
- [ ] Animations fluides
- [ ] Responsive design
- [ ] Accessibilité

## 🐛 Bugs Connus

Aucun bug connu pour le moment.

## 📝 Notes de Test

### Environnement de Test
- OS: Windows
- Navigateur: Chrome/Firefox/Edge
- Version Angular: [votre version]
- Version Node: [votre version]

### Résultats
Date: ___________
Testeur: ___________
Statut: ⬜ Réussi / ⬜ Échoué

### Commentaires
_____________________________________
_____________________________________
_____________________________________
