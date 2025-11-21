# Frontend Plannora - Angular

Application Angular pour le système de gestion de réservation de salles Plannora.

## Prérequis

- Node.js 18+ et npm
- Angular CLI 17+

## Installation

```bash
# Installer Angular CLI globalement
npm install -g @angular/cli

# Créer le projet Angular
ng new plannora-frontend --routing --style=css

# Copier les fichiers créés dans le projet
```

## Structure du projet

```
Frontend/
├── src/
│   ├── app/
│   │   ├── auth/
│   │   │   └── login/
│   │   │       ├── login.component.ts
│   │   │       ├── login.component.html
│   │   │       └── login.component.css
│   │   ├── services/
│   │   │   └── auth.service.ts
│   │   ├── interceptors/
│   │   │   └── auth.interceptor.ts
│   │   ├── guards/
│   │   │   └── auth.guard.ts
│   │   ├── app.module.ts
│   │   └── app-routing.module.ts
│   └── assets/
│       └── images/
│           ├── logo.png
│           └── teacher.jpg
```

## Configuration

L'API backend est configurée pour pointer vers `http://localhost:8082/api/auth`.

Si votre backend tourne sur un autre port, modifiez `apiUrl` dans `auth.service.ts`.

## Démarrage

```bash
# Développement
ng serve

# Production
ng build --prod
```

L'application sera accessible sur `http://localhost:4200`

## Fonctionnalités

- ✅ Connexion avec email/mot de passe
- ✅ Validation des formulaires
- ✅ Gestion des erreurs
- ✅ Stockage du token JWT
- ✅ Intercepteur HTTP pour ajouter le token
- ✅ Guard pour protéger les routes
- ✅ Redirection selon le rôle (ADMIN, ENSEIGNANT, ETUDIANT)
- ✅ Design responsive

## Utilisateurs de test

| Email | Mot de passe | Rôle |
|-------|--------------|------|
| admin@plannora.com | password123 | ADMIN |
| enseignant@plannora.com | password123 | ENSEIGNANT |
| etudiant@plannora.com | password123 | ETUDIANT |

## Prochaines étapes

1. Ajouter les composants pour les dashboards (admin, enseignant, étudiant)
2. Implémenter la gestion des réservations
3. Ajouter la gestion des salles
4. Créer les pages de profil utilisateur
5. Implémenter la réinitialisation du mot de passe
