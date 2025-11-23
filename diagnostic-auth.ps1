# Script de diagnostic d'authentification Plannora
Write-Host "=== Diagnostic d'Authentification Plannora ===" -ForegroundColor Cyan
Write-Host "Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray

# Configuration
$ports = @{
    "Eureka" = 8761
    "Gateway" = 8081
    "Authentification" = 8085
    "UserService" = 8086
    "Frontend" = 4200
}

# Fonction pour tester un port
function Test-ServicePort {
    param(
        [string]$ServiceName,
        [int]$Port
    )
    
    try {
        $connection = Test-NetConnection -ComputerName localhost -Port $Port -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
        if ($connection.TcpTestSucceeded) {
            Write-Host "✅ $ServiceName (port $Port) : EN LIGNE" -ForegroundColor Green
            return $true
        } else {
            Write-Host "❌ $ServiceName (port $Port) : HORS LIGNE" -ForegroundColor Red
            return $false
        }
    } catch {
        Write-Host "❌ $ServiceName (port $Port) : HORS LIGNE" -ForegroundColor Red
        return $false
    }
}

# 1. Vérification des ports
Write-Host "`n=== 1. Vérification des Services ===" -ForegroundColor Yellow
$authServiceRunning = $false
foreach ($service in $ports.GetEnumerator()) {
    $isRunning = Test-ServicePort -ServiceName $service.Key -Port $service.Value
    if ($service.Key -eq "Authentification" -and $isRunning) {
        $authServiceRunning = $true
    }
}

if (-not $authServiceRunning) {
    Write-Host "`n⚠️  PROBLÈME IDENTIFIÉ: Le service d'authentification n'est pas démarré!" -ForegroundColor Red
    Write-Host "Solution: Démarrez le service avec la commande suivante:" -ForegroundColor Yellow
    Write-Host "  cd AuthentificationService/Authentification/authentification" -ForegroundColor White
    Write-Host "  ./mvnw spring-boot:run" -ForegroundColor White
    Write-Host "`nAppuyez sur une touche pour continuer le diagnostic..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# 2. Test de l'endpoint de debug
Write-Host "`n=== 2. Test de l'Endpoint de Debug ===" -ForegroundColor Yellow
if ($authServiceRunning) {
    try {
        $debugUrl = "http://localhost:8085/api/auth/debug/users"
        Write-Host "Test de: $debugUrl" -ForegroundColor Gray
        $response = Invoke-RestMethod -Uri $debugUrl -Method Get -TimeoutSec 5
        Write-Host "✅ Endpoint accessible" -ForegroundColor Green
        Write-Host "   Nombre d'utilisateurs: $($response.totalUsers)" -ForegroundColor Cyan
    } catch {
        Write-Host "❌ Erreur: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.Exception.Response.StatusCode -eq 404) {
            Write-Host "⚠️  L'endpoint /debug/users n'existe pas" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "⏭️  Ignoré (service non démarré)" -ForegroundColor Gray
}

# 3. Test de connexion avec les identifiants de l'image
Write-Host "`n=== 3. Test de Connexion ===" -ForegroundColor Yellow
if ($authServiceRunning) {
    $credentials = @{
        email = "admin@plannora.com"
        password = "password123"
    } | ConvertTo-Json
    
    try {
        $loginUrl = "http://localhost:8085/api/auth/login"
        Write-Host "Test de: $loginUrl" -ForegroundColor Gray
        Write-Host "Identifiants: admin@plannora.com / password123" -ForegroundColor Gray
        
        $response = Invoke-RestMethod -Uri $loginUrl -Method Post -Body $credentials -ContentType "application/json" -TimeoutSec 5
        Write-Host "✅ CONNEXION RÉUSSIE!" -ForegroundColor Green
        Write-Host "   Token: $($response.token.Substring(0, 30))..." -ForegroundColor Cyan
        Write-Host "   Utilisateur: $($response.prenom) $($response.nom)" -ForegroundColor Cyan
        Write-Host "   Rôle: $($response.role)" -ForegroundColor Cyan
        Write-Host "`n✅ PROBLÈME RÉSOLU: L'authentification fonctionne!" -ForegroundColor Green
    } catch {
        Write-Host "❌ ÉCHEC DE CONNEXION" -ForegroundColor Red
        Write-Host "   Erreur: $($_.Exception.Message)" -ForegroundColor Red
        
        if ($_.ErrorDetails.Message) {
            $errorDetail = $_.ErrorDetails.Message | ConvertFrom-Json
            Write-Host "   Message: $($errorDetail.message)" -ForegroundColor Red
        }
        
        Write-Host "`n⚠️  PROBLÈME IDENTIFIÉ: Les identifiants sont incorrects ou l'utilisateur n'existe pas" -ForegroundColor Yellow
    }
} else {
    Write-Host "⏭️  Ignoré (service non démarré)" -ForegroundColor Gray
}

# 4. Vérification de la base de données
Write-Host "`n=== 4. Vérification de la Base de Données ===" -ForegroundColor Yellow
try {
    $mysqlTest = mysql --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ MySQL est installé" -ForegroundColor Green
        
        # Test de connexion
        $dbTest = mysql -u root -proot -e "SELECT 1;" 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Connexion MySQL réussie" -ForegroundColor Green
            
            # Vérifier la base PlannoraDB
            $dbExists = mysql -u root -proot -e "SHOW DATABASES LIKE 'PlannoraDB';" 2>&1
            if ($dbExists -match "PlannoraDB") {
                Write-Host "✅ Base de données PlannoraDB existe" -ForegroundColor Green
                
                # Vérifier les utilisateurs
                $users = mysql -u root -proot -D PlannoraDB -e "SELECT email, role FROM utilisateurs;" 2>&1
                if ($users -match "admin@plannora.com") {
                    Write-Host "✅ Utilisateur admin@plannora.com existe dans la BD" -ForegroundColor Green
                } else {
                    Write-Host "❌ Utilisateur admin@plannora.com n'existe pas dans la BD" -ForegroundColor Red
                    Write-Host "⚠️  Solution: Redémarrez le service d'authentification pour créer les utilisateurs" -ForegroundColor Yellow
                }
            } else {
                Write-Host "❌ Base de données PlannoraDB n'existe pas" -ForegroundColor Red
            }
        } else {
            Write-Host "❌ Impossible de se connecter à MySQL (vérifiez user/password)" -ForegroundColor Red
        }
    }
} catch {
    Write-Host "⚠️  MySQL n'est pas accessible ou n'est pas installé" -ForegroundColor Yellow
}

# 5. Vérification de la configuration Frontend
Write-Host "`n=== 5. Vérification de la Configuration Frontend ===" -ForegroundColor Yellow
$loginComponentPath = "Frontend/plannora-frontend/src/app/login/login.component.ts"
if (Test-Path $loginComponentPath) {
    $content = Get-Content $loginComponentPath -Raw
    if ($content -match "apiUrl = 'http://localhost:8085/api/auth'") {
        Write-Host "✅ Frontend configuré avec le bon port (8085)" -ForegroundColor Green
    } elseif ($content -match "apiUrl = 'http://localhost:8082/api/auth'") {
        Write-Host "❌ Frontend configuré avec l'ancien port (8082)" -ForegroundColor Red
        Write-Host "⚠️  PROBLÈME IDENTIFIÉ: Le frontend utilise le mauvais port!" -ForegroundColor Yellow
        Write-Host "   Le port a été mis à jour automatiquement" -ForegroundColor Cyan
    } else {
        Write-Host "⚠️  Configuration du port non trouvée" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠️  Fichier login.component.ts non trouvé" -ForegroundColor Yellow
}

# Résumé et recommandations
Write-Host "`n=== RÉSUMÉ ET RECOMMANDATIONS ===" -ForegroundColor Cyan

Write-Host "`n📋 Configuration des Ports:" -ForegroundColor White
Write-Host "   Eureka:           8761" -ForegroundColor Gray
Write-Host "   Gateway:          8081" -ForegroundColor Gray
Write-Host "   Authentification: 8085 ⭐" -ForegroundColor Gray
Write-Host "   UserService:      8086" -ForegroundColor Gray
Write-Host "   Frontend:         4200" -ForegroundColor Gray

Write-Host "`n🔑 Identifiants de Test:" -ForegroundColor White
Write-Host "   Admin:      admin@plannora.com / password123" -ForegroundColor Gray
Write-Host "   Enseignant: enseignant@plannora.com / password123" -ForegroundColor Gray

if (-not $authServiceRunning) {
    Write-Host "`n⚠️  ACTION REQUISE:" -ForegroundColor Yellow
    Write-Host "   1. Démarrez MySQL si ce n'est pas fait" -ForegroundColor White
    Write-Host "   2. Démarrez le service d'authentification:" -ForegroundColor White
    Write-Host "      cd AuthentificationService/Authentification/authentification" -ForegroundColor Cyan
    Write-Host "      ./mvnw spring-boot:run" -ForegroundColor Cyan
    Write-Host "   3. Attendez le message: 'Utilisateurs de test créés avec succès!'" -ForegroundColor White
    Write-Host "   4. Relancez ce script pour vérifier" -ForegroundColor White
} else {
    Write-Host "`n✅ Le service d'authentification est en ligne!" -ForegroundColor Green
    Write-Host "   Vous pouvez maintenant vous connecter sur http://localhost:4200" -ForegroundColor Cyan
}

Write-Host "`n=== Fin du Diagnostic ===" -ForegroundColor Cyan
