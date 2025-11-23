# Script de vérification de la base de données
Write-Host "=== Vérification de la Base de Données Plannora ===" -ForegroundColor Cyan

$dbUser = "root"
$dbPassword = "root"
$dbName = "PlannoraDB"

Write-Host "`n1. Vérification de la connexion MySQL..." -ForegroundColor Yellow
try {
    $testConnection = mysql -u $dbUser -p$dbPassword -e "SELECT 1;" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Connexion MySQL réussie" -ForegroundColor Green
    } else {
        Write-Host "❌ Erreur de connexion MySQL" -ForegroundColor Red
        exit
    }
} catch {
    Write-Host "❌ MySQL n'est pas accessible" -ForegroundColor Red
    exit
}

Write-Host "`n2. Vérification de la base de données PlannoraDB..." -ForegroundColor Yellow
$dbExists = mysql -u $dbUser -p$dbPassword -e "SHOW DATABASES LIKE '$dbName';" 2>&1
if ($dbExists -match $dbName) {
    Write-Host "✅ Base de données '$dbName' existe" -ForegroundColor Green
} else {
    Write-Host "❌ Base de données '$dbName' n'existe pas" -ForegroundColor Red
    Write-Host "Création de la base de données..." -ForegroundColor Yellow
    mysql -u $dbUser -p$dbPassword -e "CREATE DATABASE $dbName;"
}

Write-Host "`n3. Liste des tables dans PlannoraDB..." -ForegroundColor Yellow
mysql -u $dbUser -p$dbPassword -D $dbName -e "SHOW TABLES;"

Write-Host "`n4. Vérification de la table utilisateurs..." -ForegroundColor Yellow
$tableExists = mysql -u $dbUser -p$dbPassword -D $dbName -e "SHOW TABLES LIKE 'utilisateurs';" 2>&1
if ($tableExists -match "utilisateurs") {
    Write-Host "✅ Table 'utilisateurs' existe" -ForegroundColor Green
    
    Write-Host "`n5. Contenu de la table utilisateurs..." -ForegroundColor Yellow
    mysql -u $dbUser -p$dbPassword -D $dbName -e "SELECT id, email, nom, prenom, role FROM utilisateurs;"
    
    Write-Host "`n6. Nombre d'utilisateurs par rôle..." -ForegroundColor Yellow
    mysql -u $dbUser -p$dbPassword -D $dbName -e "SELECT role, COUNT(*) as nombre FROM utilisateurs GROUP BY role;"
    
    Write-Host "`n7. Vérification des utilisateurs de test..." -ForegroundColor Yellow
    $adminExists = mysql -u $dbUser -p$dbPassword -D $dbName -e "SELECT email FROM utilisateurs WHERE email='admin@plannora.com';" 2>&1
    if ($adminExists -match "admin@plannora.com") {
        Write-Host "✅ Utilisateur admin@plannora.com existe" -ForegroundColor Green
    } else {
        Write-Host "❌ Utilisateur admin@plannora.com n'existe pas" -ForegroundColor Red
    }
    
    $enseignantExists = mysql -u $dbUser -p$dbPassword -D $dbName -e "SELECT email FROM utilisateurs WHERE email='enseignant@plannora.com';" 2>&1
    if ($enseignantExists -match "enseignant@plannora.com") {
        Write-Host "✅ Utilisateur enseignant@plannora.com existe" -ForegroundColor Green
    } else {
        Write-Host "❌ Utilisateur enseignant@plannora.com n'existe pas" -ForegroundColor Red
    }
    
} else {
    Write-Host "❌ Table 'utilisateurs' n'existe pas" -ForegroundColor Red
    Write-Host "⚠️  Démarrez le service d'authentification pour créer la table automatiquement" -ForegroundColor Yellow
}

Write-Host "`n=== Résumé ===" -ForegroundColor Cyan
Write-Host "Base de données: $dbName" -ForegroundColor White
Write-Host "Utilisateur MySQL: $dbUser" -ForegroundColor White
Write-Host "`nSi les utilisateurs n'existent pas, redémarrez le service d'authentification (port 8085)" -ForegroundColor Yellow
