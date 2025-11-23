# Dashboards Personnalisés - Plannora

## Vue d'ensemble

Le système de dashboards personnalisés permet de rediriger automatiquement les utilisateurs vers leur interface appropriée après connexion.

## Dashboards Disponibles

### 1. Dashboard Enseignant (`/enseignant-dashboard`)

**Fonctionnalités :**
- Vue d'ensemble des statistiques personnelles
  - Nombre de cours de la semaine
  - Total d'heures d'enseignement
- Planning hebdomadaire avec :
  - Nom du cours
  - Salle assignée
  - Jour et horaires
- Interface épurée et facile à consulter

**Accès :** Réservé aux utilisateurs avec le rôle `ENSEIGNANT`

### 2. Dashboard Administrateur (`/admin-dashboard`)

**Fonctionnalités :**
- Sidebar de navigation avec sections :
  - 📊 Vue d'ensemble (statistiques globales)
  - 👥 Gestion des utilisateurs
  - 👨‍🏫 Gestion des enseignants
  - 🏫 Gestion des salles
  - 📚 Gestion des cours
  - 📅 Gestion du planning
- Statistiques en temps réel :
  - Nombre total d'utilisateurs
  - Nombre d'enseignants
  - Nombre de salles
  - Nombre de cours
- Interface d'administration complète

**Accès :** Réservé aux utilisateurs avec le rôle `ADMIN`

## Architecture Technique

### Services

#### AuthService (`services/auth.service.ts`)
Service centralisé pour la gestion de l'authentification :
- `isAuthenticated()` : Vérifie si l'utilisateur est connecté
- `getCurrentUser()` : Récupère les informations de l'utilisateur
- `getUserRole()` : Récupère le rôle de l'utilisateur
- `logout()` : Déconnecte l'utilisateur
- `hasRole(role)` : Vérifie si l'utilisateur a un rôle spécifique

### Guards

#### AuthGuard (`guards/auth.guard.ts`)
Protège les routes et vérifie :
- L'authentification de l'utilisateur
- Le rôle requis pour accéder à la route

### Routing

Les routes sont protégées avec le guard et configurées avec les rôles requis :

```typescript
{
  path: 'enseignant-dashboard',
  component: EnseignantDashboardComponent,
  canActivate: [authGuard],
  data: { role: 'ENSEIGNANT' }
}
```

## Flux de Connexion

1. L'utilisateur se connecte via `/login`
2. Le backend retourne un token JWT et les informations utilisateur (incluant le rôle)
3. Les données sont stockées dans le localStorage
4. Redirection automatique selon le rôle :
   - `ADMIN` → `/admin-dashboard`
   - `ENSEIGNANT` → `/enseignant-dashboard`
   - Autres rôles → Message d'attente

## Données de Démonstration

Les dashboards utilisent actuellement des données statiques pour la démonstration :

### Enseignant
- 4 cours programmés dans la semaine
- Total de 8 heures d'enseignement
- Cours : Mathématiques et Physique

### Administrateur
- 156 utilisateurs
- 42 enseignants
- 28 salles
- 89 cours

## Prochaines Étapes

### Court terme
- [ ] Intégrer les API backend pour récupérer les vraies données
- [ ] Ajouter un dashboard pour les étudiants
- [ ] Implémenter les fonctionnalités CRUD dans le dashboard admin

### Moyen terme
- [ ] Ajouter des graphiques et visualisations
- [ ] Système de notifications en temps réel
- [ ] Export de planning en PDF
- [ ] Calendrier interactif

### Long terme
- [ ] Application mobile responsive
- [ ] Mode hors ligne
- [ ] Intégration avec des calendriers externes (Google Calendar, Outlook)

## Utilisation

### Démarrer l'application

```bash
cd Frontend/plannora-frontend
npm install
ng serve
```

L'application sera accessible sur `http://localhost:4200`

### Tester les dashboards

**Compte Enseignant :**
- Email : enseignant@test.com
- Mot de passe : (selon votre configuration)

**Compte Administrateur :**
- Email : admin@test.com
- Mot de passe : (selon votre configuration)

## Personnalisation

### Modifier les couleurs
Les couleurs principales sont définies dans les fichiers CSS de chaque composant :
- Enseignant : `enseignant-dashboard.component.css`
- Admin : `admin-dashboard.component.css`

### Ajouter une section au dashboard admin
1. Ajouter un bouton dans la sidebar (`admin-dashboard.component.html`)
2. Créer la section correspondante dans le contenu
3. Gérer l'affichage avec `activeSection`

## Support

Pour toute question ou problème, consultez la documentation principale du projet.
