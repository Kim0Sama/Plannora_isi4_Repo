"# Plannora - Système de Gestion d'Emploi du Temps

Projet tutoré 2025-2026 - ISI4

## 📋 Description

Plannora est une application de gestion d'emploi du temps pour établissements d'enseignement, développée avec une architecture microservices.

## 🏗️ Architecture

### Microservices

- **EurekaService** (port 8761) - Service de découverte
- **GatewayService** (port 8081) - API Gateway
- **AuthentificationService** (port 8085) - Authentification et JWT ✅ **IMPLÉMENTÉ**
- **UserService** (port 8086) - Gestion des utilisateurs ✅ **IMPLÉMENTÉ**
- **PlanningService** - Gestion des emplois du temps
- **ReservationService** - Gestion des réservations
- **SalleService** - Gestion des salles
- **NotificationService** - Notifications
- **ReportingService** - Rapports et statistiques
- **IntegrationService** - Intégration avec systèmes externes

### Frontend

- **Frontend** (port 4200) - Application Angular ✅ **IMPLÉMENTÉ**
  - Dashboard Administrateur
  - Dashboard Enseignant
  - Système d'authentification

## 🚀 Services Implémentés

### ✅ UserService

Service de gestion des utilisateurs (Administrateurs et Enseignants).

**Fonctionnalités** :
- CRUD complet des utilisateurs (ADMIN uniquement)
- Héritage : Utilisateur → Administrateur / Enseignant
- Authentification JWT
- Base de données unique : `plannoradb`
- Sécurité par rôle

**Documentation** :
- [README UserService](UserService/README.md)
- [Guide de Démarrage Rapide](UserService/DEMARRAGE-RAPIDE.md)
- [Guide des Tests Postman](UserService/GUIDE-TESTS-POSTMAN.md)
- [Architecture](UserService/ARCHITECTURE.md)
- [Index de la Documentation](UserService/INDEX.md)

**Démarrage** :
```bash
cd UserService/user-service
mvn spring-boot:run
```

## 🗄️ Base de Données

**Base de données unique** : `PlannoraDB` (MySQL)

Tous les services utilisent la même base de données pour assurer la cohérence des données.

### Configuration MySQL

```sql
CREATE DATABASE IF NOT EXISTS PlannoraDB;
```

Configuration dans `application.properties` :
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/PlannoraDB?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=root
```

**Note importante** : Le paramètre `allowPublicKeyRetrieval=true` est requis pour MySQL 8.0+

## 🔧 Prérequis

- Java 17+
- Maven 3.6+
- MySQL 8.0+
- Node.js 18+ (pour le frontend)
- Angular CLI (pour le frontend)

## 🚀 Démarrage Rapide

### ⚡ Méthode Automatique (Recommandée)

```powershell
# Démarrer tous les services automatiquement
./demarrer-plannora.ps1

# Tester l'authentification
./test-rapide.ps1

# Diagnostic complet
./diagnostic-auth.ps1
```

### 📖 Guide Détaillé

Consultez [DEMARRAGE-RAPIDE.md](DEMARRAGE-RAPIDE.md) pour :
- Instructions pas à pas
- Résolution des problèmes
- Identifiants de test
- URLs des services

### 🔑 Identifiants de Test

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| **Admin** | admin@plannora.com | password123 |
| **Enseignant** | enseignant@plannora.com | password123 |

### 🌐 URLs des Services

- **Frontend** : http://localhost:4200 ⭐
- Eureka : http://localhost:8761
- Gateway : http://localhost:8081
- Authentication : http://localhost:8085
- User Service : http://localhost:8086

## 🧪 Tests

### Comptes par Défaut

Deux utilisateurs sont créés automatiquement au démarrage :

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| Admin | admin@plannora.com | password123 |
| Enseignant | enseignant@plannora.com | password123 |

### Test Rapide

```powershell
# Test automatique de l'authentification
./test-rapide.ps1
```

### Test avec Postman

1. **Authentification** :
```
POST http://localhost:8085/api/auth/login
Body: {"email":"admin@plannora.com","password":"password123"}
```

2. **Créer un enseignant** :
```
POST http://localhost:8086/api/utilisateurs/enseignant
Authorization: Bearer YOUR_TOKEN
Body: {
  "email":"prof@plannora.com",
  "mdp":"password123",
  "nomUser":"Dupont",
  "prenomUser":"Jean",
  "telephone":"0612345678",
  "specialite":"Informatique",
  "departement":"Génie Logiciel"
}
```

3. **Lister les utilisateurs** :
```
GET http://localhost:8086/api/utilisateurs
Authorization: Bearer YOUR_TOKEN
```

## 📚 Documentation

### 🚀 Guides de Démarrage
- **[Démarrage Rapide](DEMARRAGE-RAPIDE.md)** ⭐ Commencez ici !
- [Solution Problème Auth](SOLUTION-PROBLEME-AUTH.md)
- [Guide de Dépannage](AuthentificationService/GUIDE-DEPANNAGE-LOGIN.md)

### 📦 Services
- [UserService](UserService/README.md) - Gestion des utilisateurs
- [Authentication Service](AuthentificationService/README.md) - Authentification JWT
- [Frontend](Frontend/README.md) - Application Angular
- [Eureka Service](EurekaService/README.md) - Service de découverte
- [Gateway Service](GatewayService/README.md) - API Gateway

### 🛠️ Scripts Utiles
- `demarrer-plannora.ps1` - Démarre tous les services
- `test-rapide.ps1` - Test rapide de l'authentification
- `diagnostic-auth.ps1` - Diagnostic complet
- `verifier-bd.ps1` - Vérification de la base de données

## 🔐 Sécurité

- **JWT** : Authentification par tokens
- **BCrypt** : Hashage des mots de passe
- **Contrôle d'accès** : Par rôle (ADMIN, ENSEIGNANT)
- **HTTPS** : À configurer en production

## 🛠️ Technologies

### Backend
- Spring Boot 3.5.7
- Spring Cloud (Eureka, Gateway)
- Spring Security
- Spring Data JPA
- MySQL
- JWT (jjwt)
- Lombok

### Frontend
- Angular
- TypeScript
- Bootstrap

## 📊 État d'Avancement

| Service | État | Documentation |
|---------|------|---------------|
| Eureka | ✅ Opérationnel | [README](EurekaService/README.md) |
| Gateway | ✅ Opérationnel | [README](GatewayService/README.md) |
| Authentication | ✅ Opérationnel | [README](AuthentificationService/README.md) |
| User Service | ✅ Opérationnel | [README](UserService/README.md) |
| Planning | 🚧 En cours | - |
| Reservation | 🚧 En cours | - |
| Salle | 🚧 En cours | - |
| Notification | 🚧 En cours | - |
| Reporting | 🚧 En cours | - |
| Integration | 🚧 En cours | - |
| Frontend | 🚧 En cours | [README](Frontend/README.md) |

## 🤝 Contribution

Ce projet est développé dans le cadre du projet tutoré ISI4 2025-2026.

## 📞 Support

Pour toute question ou problème :
1. Consultez la documentation du service concerné
2. Vérifiez les logs des services
3. Consultez la base de données MySQL

## 📝 Licence

Projet académique - ISI4 2025-2026" 
