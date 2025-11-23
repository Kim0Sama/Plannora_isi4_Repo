# Script de démarrage simplifié pour Plannora
Write-Host "=== Démarrage de Plannora ===" -ForegroundColor Cyan

# Vérifier MySQL
Write-Host "`n1. Vérification de MySQL..." -ForegroundColor Yellow
try {
    $mysqlTest = mysql -u root -proot -e "SELECT 1;" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ MySQL est accessible" -ForegroundColor Green
    } else {
        Write-Host "❌ MySQL n'est pas accessible avec root/root" -ForegroundColor Red
        Write-Host "⚠️  Démarrez MySQL avant de continuer" -ForegroundColor Yellow
        exit
    }
} catch {
    Write-Host "❌ MySQL n'est pas installé ou n'est pas démarré" -ForegroundColor Red
    Write-Host "⚠️  Installez et démarrez MySQL avant de continuer" -ForegroundColor Yellow
    exit
}

# Créer la base de données si elle n'existe pas
Write-Host "`n2. Vérification de la base de données..." -ForegroundColor Yellow
$dbExists = mysql -u root -proot -e "SHOW DATABASES LIKE 'PlannoraDB';" 2>&1
if ($dbExists -match "PlannoraDB") {
    Write-Host "✅ Base de données PlannoraDB existe" -ForegroundColor Green
} else {
    Write-Host "⚠️  Création de la base de données PlannoraDB..." -ForegroundColor Yellow
    mysql -u root -proot -e "CREATE DATABASE PlannoraDB;"
    Write-Host "✅ Base de données créée" -ForegroundColor Green
}

Write-Host "`n3. Démarrage des services..." -ForegroundColor Yellow
Write-Host "⏳ Cela peut prendre quelques minutes..." -ForegroundColor Gray

# Démarrer Eureka
Write-Host "`n   📡 Démarrage d'Eureka (port 8761)..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd EurekaService/eureka/eureka; Write-Host '=== EUREKA SERVER ===' -ForegroundColor Cyan; ./mvnw spring-boot:run"
Start-Sleep -Seconds 3

# Démarrer le Service d'Authentification
Write-Host "   🔐 Démarrage du Service d'Authentification (port 8085)..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd AuthentificationService/Authentification/authentification; Write-Host '=== SERVICE AUTHENTIFICATION ===' -ForegroundColor Cyan; ./mvnw spring-boot:run"
Start-Sleep -Seconds 3

# Démarrer le Service Utilisateur
Write-Host "   👥 Démarrage du Service Utilisateur (port 8086)..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd UserService/user-service; Write-Host '=== SERVICE UTILISATEUR ===' -ForegroundColor Cyan; ./mvnw spring-boot:run"
Start-Sleep -Seconds 3

# Démarrer la Gateway
Write-Host "   🌐 Démarrage de la Gateway (port 8081)..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd GatewayService/gateway/gateway; Write-Host '=== GATEWAY ===' -ForegroundColor Cyan; ./mvnw spring-boot:run"
Start-Sleep -Seconds 3

# Démarrer le Frontend
Write-Host "   🎨 Démarrage du Frontend Angular (port 4200)..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd Frontend/plannora-frontend; Write-Host '=== FRONTEND ANGULAR ===' -ForegroundColor Cyan; npm start"

Write-Host "`n✅ Tous les services sont en cours de démarrage!" -ForegroundColor Green
Write-Host "`n⏳ Attendez environ 2-3 minutes que tous les services soient prêts..." -ForegroundColor Yellow

Write-Host "`n=== URLs des Services ===" -ForegroundColor Cyan
Write-Host "Eureka:           http://localhost:8761" -ForegroundColor White
Write-Host "Authentification: http://localhost:8085/api/auth" -ForegroundColor White
Write-Host "UserService:      http://localhost:8086" -ForegroundColor White
Write-Host "Gateway:          http://localhost:8081" -ForegroundColor White
Write-Host "Frontend:         http://localhost:4200" -ForegroundColor Green

Write-Host "`n=== Identifiants de Test ===" -ForegroundColor Cyan
Write-Host "Admin:      admin@plannora.com / password123" -ForegroundColor Green
Write-Host "Enseignant: enseignant@plannora.com / password123" -ForegroundColor Green

Write-Host "`n💡 Conseil: Attendez de voir dans les fenêtres de services:" -ForegroundColor Yellow
Write-Host "   - 'Started AuthentificationApplication' pour l'authentification" -ForegroundColor Gray
Write-Host "   - 'Utilisateurs de test créés avec succès!' dans les logs" -ForegroundColor Gray
Write-Host "   - 'Compiled successfully' pour le frontend" -ForegroundColor Gray

Write-Host "`n📝 Pour tester l'authentification après le démarrage:" -ForegroundColor Yellow
Write-Host "   ./diagnostic-auth.ps1" -ForegroundColor Cyan

Write-Host "`n=== Démarrage en cours... ===" -ForegroundColor Cyan
