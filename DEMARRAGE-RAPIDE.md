# 🚀 Démarrage Rapide - Plannora

## Problème d'Authentification ? Lisez ceci ! 👇

### ✅ Solution en 3 Étapes

#### 1️⃣ Démarrer MySQL
Assurez-vous que MySQL est démarré avec :
- User: `root`
- Password: `root`

#### 2️⃣ Démarrer tous les services
```powershell
./demarrer-plannora.ps1
```

#### 3️⃣ Attendre 2-3 minutes puis tester
```powershell
./diagnostic-auth.ps1
```

---

## 🔑 Identifiants de Connexion

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| **Admin** | admin@plannora.com | password123 |
| **Enseignant** | enseignant@plannora.com | password123 |

---

## 🌐 URLs des Services

| Service | URL | Port |
|---------|-----|------|
| **Frontend** | http://localhost:4200 | 4200 |
| Authentification | http://localhost:8085/api/auth | 8085 |
| UserService | http://localhost:8086 | 8086 |
| Gateway | http://localhost:8081 | 8081 |
| Eureka | http://localhost:8761 | 8761 |

---

## 🔧 Scripts Utiles

| Script | Description |
|--------|-------------|
| `demarrer-plannora.ps1` | 🚀 Démarre tous les services |
| `diagnostic-auth.ps1` | 🔍 Diagnostique les problèmes |
| `verifier-bd.ps1` | 💾 Vérifie la base de données |

---

## ⚠️ Problèmes Courants

### "Email ou mot de passe incorrect"
➡️ Le service d'authentification n'est pas démarré
```powershell
cd AuthentificationService/Authentification/authentification
./mvnw spring-boot:run
```

### "Connection refused"
➡️ Aucun service n'est démarré
```powershell
./demarrer-plannora.ps1
```

### "Cannot connect to MySQL"
➡️ MySQL n'est pas démarré ou les identifiants sont incorrects

---

## 📖 Documentation Complète

- [Solution Détaillée](SOLUTION-PROBLEME-AUTH.md)
- [Guide de Dépannage](AuthentificationService/GUIDE-DEPANNAGE-LOGIN.md)
- [README Principal](README.md)

---

## 🎯 Ordre de Démarrage

1. **MySQL** (doit être démarré en premier)
2. **Eureka** (service de découverte)
3. **Service d'Authentification** (crée les utilisateurs)
4. **Service Utilisateur**
5. **Gateway**
6. **Frontend Angular**

Le script `demarrer-plannora.ps1` fait tout cela automatiquement ! 🎉
