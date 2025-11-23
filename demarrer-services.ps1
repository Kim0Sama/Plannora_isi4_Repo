# Script de démarrage des services Plannora
Write-Host "=== Démarrage des Services Plannora ===" -ForegroundColor Cyan

# Fonction pour vérifier si un port est utilisé
function Test-Port {
    param([int]$Port)
    $connection = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
    return $null -ne $connection
}

# Fonction pour attendre qu'un service soit prêt
function Wait-ForService {
    param(
        [string]$Url,
        [string]$ServiceName,
        [int]$MaxAttempts = 30
    )
    
    Write-Host "Attente du démarrage de $ServiceName..." -ForegroundColor Yellow
    $attempt = 0
    
    while ($attempt -lt $MaxAttempts) {
        try {
            $response = Invoke-WebRequest -Uri $Url -Method Get -TimeoutSec 2 -ErrorAction Stop
            Write-Host "✅ $ServiceName est prêt!" -ForegroundColor Green
            return $true
        } catch {
            $attempt++
            Write-Host "." -NoNewline -ForegroundColor Gray
            Start-Sleep -Seconds 2
        }
    }
    
    Write-Host "`n❌ $ServiceName n'a pas démarré dans le délai imparti" -ForegroundColor Red
    return $false
}

# 1. Démarrer Eureka (Service de découverte)
Write-Host "`n1. Démarrage d'Eureka Server (port 8761)..." -ForegroundColor Yellow
if (Test-Port 8761) {
    Write-Host "✅ Eureka est déjà en cours d'exécution" -ForegroundColor Green
} else {
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd EurekaService/eureka/eureka; ./mvnw spring-boot:run"
    Wait-ForService -Url "http://localhost:8761" -ServiceName "Eureka"
}

# 2. Démarrer le Service d'Authentification
Write-Host "`n2. Démarrage du Service d'Authentification (port 8082)..." -ForegroundColor Yellow
if (Test-Port 8082) {
    Write-Host "✅ Service d'Authentification est déjà en cours d'exécution" -ForegroundColor Green
} else {
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd AuthentificationService/Authentification/authentification; ./mvnw spring-boot:run"
    Start-Sleep -Seconds 10
    Wait-ForService -Url "http://localhost:8082/api/auth/debug/users" -ServiceName "Service d'Authentification"
}

# 3. Démarrer le Service Utilisateur
Write-Host "`n3. Démarrage du Service Utilisateur (port 8083)..." -ForegroundColor Yellow
if (Test-Port 8083) {
    Write-Host "✅ Service Utilisateur est déjà en cours d'exécution" -ForegroundColor Green
} else {
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd UserService/user-service; ./mvnw spring-boot:run"
    Start-Sleep -Seconds 10
}

# 4. Démarrer la Gateway
Write-Host "`n4. Démarrage de la Gateway (port 8080)..." -ForegroundColor Yellow
if (Test-Port 8080) {
    Write-Host "✅ Gateway est déjà en cours d'exécution" -ForegroundColor Green
} else {
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd GatewayService/gateway/gateway; ./mvnw spring-boot:run"
    Start-Sleep -Seconds 10
}

# 5. Démarrer le Frontend Angular
Write-Host "`n5. Démarrage du Frontend Angular (port 4200)..." -ForegroundColor Yellow
if (Test-Port 4200) {
    Write-Host "✅ Frontend est déjà en cours d'exécution" -ForegroundColor Green
} else {
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd Frontend/plannora-frontend; npm start"
    Write-Host "⏳ Le frontend démarre sur http://localhost:4200" -ForegroundColor Cyan
}

Write-Host "`n=== Résumé des Services ===" -ForegroundColor Cyan
Write-Host "Eureka Server:      http://localhost:8761" -ForegroundColor White
Write-Host "Authentification:   http://localhost:8082" -ForegroundColor White
Write-Host "Service Utilisateur: http://localhost:8083" -ForegroundColor White
Write-Host "Gateway:            http://localhost:8080" -ForegroundColor White
Write-Host "Frontend:           http://localhost:4200" -ForegroundColor White

Write-Host "`n=== Identifiants de Test ===" -ForegroundColor Cyan
Write-Host "Admin:      admin@plannora.com / password123" -ForegroundColor Green
Write-Host "Enseignant: enseignant@plannora.com / password123" -ForegroundColor Green

Write-Host "`nAppuyez sur une touche pour tester la connexion..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Test de connexion
Write-Host "`n=== Test de Connexion ===" -ForegroundColor Cyan
& ./AuthentificationService/test-login.ps1
