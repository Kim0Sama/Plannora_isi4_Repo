# 🌐 Configuration des Ports et Services - Plannora

## 📊 Vue d'Ensemble

```
┌─────────────────────────────────────────────────────────────┐
│                    PLANNORA ARCHITECTURE                     │
└─────────────────────────────────────────────────────────────┘

┌──────────────┐
│   Frontend   │  http://localhost:4200
│   Angular    │  ⭐ Point d'entrée utilisateur
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Gateway    │  http://localhost:8081
│   Port 8081  │  🌐 Point d'entrée API
└──────┬───────┘
       │
       ├─────────────────────────────────────┐
       │                                     │
       ▼                                     ▼
┌──────────────┐                    ┌──────────────┐
│    Auth      │                    │     User     │
│  Port 8085   │                    │  Port 8086   │
│  🔐 JWT      │                    │  👥 CRUD     │
└──────────────┘                    └──────────────┘
       │                                     │
       └─────────────┬───────────────────────┘
                     ▼
              ┌──────────────┐
              │    Eureka    │
              │  Port 8761   │
              │  📡 Discovery│
              └──────────────┘
                     │
                     ▼
              ┌──────────────┐
              │    MySQL     │
              │  Port 3306   │
              │  💾 PlannoraDB│
              └──────────────┘
```

## 🔌 Ports des Services

| Service | Port | URL | Statut |
|---------|------|-----|--------|
| **Frontend** | 4200 | http://localhost:4200 | ✅ Implémenté |
| **Gateway** | 8081 | http://localhost:8081 | ✅ Opérationnel |
| **Authentification** | 8085 | http://localhost:8085/api/auth | ✅ Implémenté |
| **UserService** | 8086 | http://localhost:8086/api/utilisateurs | ✅ Implémenté |
| **Eureka** | 8761 | http://localhost:8761 | ✅ Opérationnel |
| **MySQL** | 3306 | localhost:3306 | ✅ Requis |

## 🔑 Endpoints Principaux

### Authentification (Port 8085)

```
POST   /api/auth/login          - Connexion
POST   /api/auth/register       - Inscription
GET    /api/auth/debug/users    - Debug (nombre d'utilisateurs)
```

### UserService (Port 8086)

```
GET    /api/utilisateurs                    - Liste tous les utilisateurs
GET    /api/utilisateurs/{id}               - Détails d'un utilisateur
POST   /api/utilisateurs/administrateur     - Créer un admin
POST   /api/utilisateurs/enseignant         - Créer un enseignant
PUT    /api/utilisateurs/{id}               - Modifier un utilisateur
DELETE /api/utilisateurs/{id}               - Supprimer un utilisateur
```

### Frontend (Port 4200)

```
/login                - Page de connexion
/admin-dashboard      - Dashboard administrateur
/enseignant-dashboard - Dashboard enseignant
```

## 🔐 Authentification

### Identifiants de Test

| Rôle | Email | Mot de passe | Dashboard |
|------|-------|--------------|-----------|
| **Admin** | admin@plannora.com | password123 | /admin-dashboard |
| **Enseignant** | enseignant@plannora.com | password123 | /enseignant-dashboard |

### Flow d'Authentification

```
1. Frontend (4200) → POST /api/auth/login → Auth Service (8085)
2. Auth Service vérifie les identifiants dans MySQL
3. Auth Service génère un JWT token
4. Frontend stocke le token dans localStorage
5. Frontend redirige vers le dashboard approprié
6. Toutes les requêtes suivantes incluent le token JWT
```

## 💾 Base de Données

### Configuration MySQL

```properties
URL      : jdbc:mysql://localhost:3306/PlannoraDB
Database : PlannoraDB
User     : root
Password : root
```

### Tables Principales

```
utilisateurs
├── id (VARCHAR)
├── email (VARCHAR) UNIQUE
├── password (VARCHAR) - BCrypt
├── nom (VARCHAR)
├── prenom (VARCHAR)
├── telephone (VARCHAR)
├── role (ENUM: ADMIN, ENSEIGNANT)
└── dtype (VARCHAR) - Discriminator
```

## 🚀 Ordre de Démarrage

```
1. MySQL          (Port 3306)  - Base de données
   ↓
2. Eureka         (Port 8761)  - Service de découverte
   ↓
3. Auth Service   (Port 8085)  - Crée les utilisateurs de test
   ↓
4. User Service   (Port 8086)  - Gestion des utilisateurs
   ↓
5. Gateway        (Port 8081)  - Routage des requêtes
   ↓
6. Frontend       (Port 4200)  - Interface utilisateur
```

## 🧪 Tests de Connectivité

### Test PowerShell

```powershell
# Test rapide
./test-rapide.ps1

# Diagnostic complet
./diagnostic-auth.ps1

# Vérifier la base de données
./verifier-bd.ps1
```

### Test Manuel

```powershell
# Test Auth Service
Invoke-RestMethod -Uri "http://localhost:8085/api/auth/debug/users"

# Test de connexion
$body = @{email="admin@plannora.com";password="password123"} | ConvertTo-Json
Invoke-RestMethod -Uri "http://localhost:8085/api/auth/login" -Method Post -Body $body -ContentType "application/json"
```

## 🔧 Configuration des Fichiers

### Frontend - login.component.ts
```typescript
private apiUrl = 'http://localhost:8085/api/auth';
```

### Auth Service - application.properties
```properties
server.port=8085
spring.datasource.url=jdbc:mysql://localhost:3306/PlannoraDB
```

### User Service - application.properties
```properties
server.port=8086
spring.datasource.url=jdbc:mysql://localhost:3306/PlannoraDB
```

### Gateway - application.properties
```properties
server.port=8081
```

### Eureka - application.properties
```properties
server.port=8761
```

## ⚠️ Changements de Ports

### Ancienne Configuration
- Gateway: 8080 → **8081** ✅
- Auth: 8082 → **8085** ✅
- User: 8083 → **8086** ✅

### Impact
- ✅ Frontend mis à jour (8085)
- ✅ Scripts de test mis à jour
- ✅ Documentation mise à jour

## 📝 Notes Importantes

1. **MySQL doit être démarré en premier** avec les identifiants root/root
2. **Eureka doit démarrer avant les autres services** pour l'enregistrement
3. **Auth Service crée automatiquement les utilisateurs de test** au démarrage
4. **Le Frontend utilise directement le port 8085** (pas de passage par la Gateway pour l'auth)
5. **Tous les services utilisent la même base de données** PlannoraDB

## 🆘 Dépannage Rapide

| Problème | Solution |
|----------|----------|
| Port déjà utilisé | Vérifier avec `Get-NetTCPConnection -LocalPort XXXX` |
| Service ne démarre pas | Vérifier les logs dans la console |
| Connexion refusée | Service non démarré, lancer `./demarrer-plannora.ps1` |
| Auth échoue | Vérifier que Auth Service (8085) est démarré |
| MySQL inaccessible | Démarrer MySQL et vérifier root/root |

## 📚 Documentation Complète

- [Démarrage Rapide](DEMARRAGE-RAPIDE.md)
- [Solution Problème Auth](SOLUTION-PROBLEME-AUTH.md)
- [Guide de Dépannage](AuthentificationService/GUIDE-DEPANNAGE-LOGIN.md)
- [README Principal](README.md)
