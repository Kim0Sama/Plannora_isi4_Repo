# Solution au Problème d'Authentification

## Problème Identifié

Vous ne pouvez pas vous connecter avec `admin@plannora.com` / `password123` car :

1. ❌ Le service d'authentification n'est pas démarré
2. ❌ Les services utilisent de nouveaux ports
3. ✅ Le frontend a été mis à jour pour utiliser le bon port (8085)

## Configuration des Ports

| Service | Port |
|---------|------|
| Eureka | 8761 |
| Gateway | 8081 |
| **Authentification** | **8085** ⭐ |
| UserService | 8086 |
| Frontend | 4200 |

## Solution Rapide (3 étapes)

### Étape 1 : Démarrer MySQL

Assurez-vous que MySQL est démarré avec les identifiants :
- Utilisateur : `root`
- Mot de passe : `root`

### Étape 2 : Démarrer tous les services

```powershell
./demarrer-plannora.ps1
```

Ce script va :
- Vérifier MySQL
- Créer la base de données PlannoraDB si nécessaire
- Démarrer tous les services dans le bon ordre
- Afficher les URLs et identifiants

### Étape 3 : Attendre et tester

Attendez 2-3 minutes que tous les services démarrent, puis :

```powershell
./diagnostic-auth.ps1
```

## Démarrage Manuel (si nécessaire)

Si vous préférez démarrer les services manuellement :

### 1. Eureka (Terminal 1)
```powershell
cd EurekaService/eureka/eureka
./mvnw spring-boot:run
```

### 2. Service d'Authentification (Terminal 2)
```powershell
cd AuthentificationService/Authentification/authentification
./mvnw spring-boot:run
```

**Attendez de voir :**
```
✅ Utilisateurs de test créés avec succès!
📧 admin@plannora.com / password123
📧 enseignant@plannora.com / password123
```

### 3. Service Utilisateur (Terminal 3)
```powershell
cd UserService/user-service
./mvnw spring-boot:run
```

### 4. Gateway (Terminal 4)
```powershell
cd GatewayService/gateway/gateway
./mvnw spring-boot:run
```

### 5. Frontend (Terminal 5)
```powershell
cd Frontend/plannora-frontend
npm start
```

## Vérification

Une fois tous les services démarrés :

1. Ouvrez http://localhost:4200
2. Connectez-vous avec :
   - Email : `admin@plannora.com`
   - Mot de passe : `password123`

## Test de l'API directement

Pour tester l'API d'authentification directement :

```powershell
# Test avec PowerShell
$body = @{
    email = "admin@plannora.com"
    password = "password123"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8085/api/auth/login" -Method Post -Body $body -ContentType "application/json"
```

Ou avec curl :

```bash
curl -X POST http://localhost:8085/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@plannora.com","password":"password123"}'
```

## Identifiants de Test

Les utilisateurs suivants sont créés automatiquement au démarrage du service d'authentification :

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| Admin | admin@plannora.com | password123 |
| Enseignant | enseignant@plannora.com | password123 |

## Dépannage

### Erreur : "Email ou mot de passe incorrect"

**Causes possibles :**
1. Le service d'authentification n'a pas créé les utilisateurs
2. La base de données n'est pas accessible
3. Les mots de passe ne correspondent pas

**Solution :**
```powershell
# Vérifier la base de données
./verifier-bd.ps1

# Redémarrer le service d'authentification
cd AuthentificationService/Authentification/authentification
./mvnw spring-boot:run
```

### Erreur : "Connection refused" ou "Network error"

**Cause :** Le service d'authentification n'est pas démarré

**Solution :**
```powershell
# Vérifier les services
./diagnostic-auth.ps1

# Démarrer les services
./demarrer-plannora.ps1
```

### Le service démarre mais les utilisateurs ne sont pas créés

**Solution :**
1. Vérifiez les logs du service d'authentification
2. Vérifiez que MySQL est accessible
3. Supprimez et recréez la base de données :

```sql
DROP DATABASE IF EXISTS PlannoraDB;
CREATE DATABASE PlannoraDB;
```

4. Redémarrez le service d'authentification

## Modifications Effectuées

### Frontend (login.component.ts)
```typescript
// Avant
private apiUrl = 'http://localhost:8082/api/auth';

// Après
private apiUrl = 'http://localhost:8085/api/auth';
```

### Backend (DataInitializer.java)
```java
// Les utilisateurs sont maintenant recréés à chaque démarrage
// avec le mot de passe "password123" pour admin et enseignant
```

## Scripts Utiles

| Script | Description |
|--------|-------------|
| `demarrer-plannora.ps1` | Démarre tous les services |
| `diagnostic-auth.ps1` | Diagnostique les problèmes d'authentification |
| `verifier-bd.ps1` | Vérifie la base de données |
| `AuthentificationService/test-login.ps1` | Teste la connexion |

## Support

Si le problème persiste après avoir suivi ces étapes :

1. Exécutez `./diagnostic-auth.ps1` et partagez les résultats
2. Vérifiez les logs du service d'authentification
3. Vérifiez que MySQL est bien démarré et accessible
