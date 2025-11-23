# Test rapide de l'authentification Plannora
Write-Host "=== Test Rapide Plannora ===" -ForegroundColor Cyan

# Test du service d'authentification
Write-Host "`nTest de connexion avec admin@plannora.com..." -ForegroundColor Yellow

$credentials = @{
    email = "admin@plannora.com"
    password = "password123"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8085/api/auth/login" -Method Post -Body $credentials -ContentType "application/json" -TimeoutSec 5
    
    Write-Host "`n✅ CONNEXION RÉUSSIE!" -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
    Write-Host "Utilisateur : $($response.prenom) $($response.nom)" -ForegroundColor Cyan
    Write-Host "Email       : $($response.email)" -ForegroundColor Cyan
    Write-Host "Rôle        : $($response.role)" -ForegroundColor Cyan
    Write-Host "Token       : $($response.token.Substring(0, 40))..." -ForegroundColor Gray
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
    
    Write-Host "`n🎉 Tout fonctionne! Vous pouvez vous connecter sur:" -ForegroundColor Green
    Write-Host "   http://localhost:4200" -ForegroundColor Cyan
    
} catch {
    Write-Host "`n❌ ÉCHEC DE CONNEXION" -ForegroundColor Red
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Red
    
    if ($_.Exception.Message -match "Unable to connect") {
        Write-Host "⚠️  Le service d'authentification n'est pas démarré" -ForegroundColor Yellow
        Write-Host "`nSolution:" -ForegroundColor White
        Write-Host "  ./demarrer-plannora.ps1" -ForegroundColor Cyan
    } else {
        Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.ErrorDetails.Message) {
            $errorDetail = $_.ErrorDetails.Message | ConvertFrom-Json
            Write-Host "Message: $($errorDetail.message)" -ForegroundColor Red
        }
    }
    
    Write-Host "`nPour plus de détails:" -ForegroundColor White
    Write-Host "  ./diagnostic-auth.ps1" -ForegroundColor Cyan
}
