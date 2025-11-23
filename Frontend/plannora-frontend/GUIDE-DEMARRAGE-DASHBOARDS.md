# Guide de Démarrage - Dashboards Plannora

## 🚀 Démarrage Rapide

### 1. Installation

```bash
cd Frontend/plannora-frontend
npm install
```

### 2. Lancer l'application

```bash
ng serve
```

Accédez à `http://localhost:4200`

### 3. Tester les dashboards

#### Option A : Avec un compte Enseignant
1. Allez sur la page de connexion
2. Connectez-vous avec un compte ayant le rôle `ENSEIGNANT`
3. Vous serez automatiquement redirigé vers `/enseignant-dashboard`

#### Option B : Avec un compte Administrateur
1. Allez sur la page de connexion
2. Connectez-vous avec un compte ayant le rôle `ADMIN`
3. Vous serez automatiquement redirigé vers `/admin-dashboard`

## 📋 Fonctionnalités par Dashboard

### Dashboard Enseignant

**Ce que vous verrez :**
- 📊 Statistiques : Nombre de cours et heures totales
- 📅 Planning hebdomadaire avec tous vos cours
- 🏫 Détails : Salle, horaires, jour

**Navigation :**
- Bouton de déconnexion en haut à droite

### Dashboard Administrateur

**Ce que vous verrez :**
- 📊 Vue d'ensemble avec statistiques globales
- 🎯 Menu latéral avec 6 sections :
  - Vue d'ensemble
  - Utilisateurs
  - Enseignants
  - Salles
  - Cours
  - Planning

**Navigation :**
- Cliquez sur les sections du menu pour naviguer
- Bouton de déconnexion en haut à droite

## 🔒 Sécurité

### Protection des routes
- Toutes les routes de dashboard sont protégées par `authGuard`
- Vérification automatique du token JWT
- Vérification du rôle utilisateur
- Redirection vers `/login` si non autorisé

### Stockage des données
- Token JWT stocké dans `localStorage`
- Informations utilisateur stockées dans `localStorage`
- Nettoyage automatique à la déconnexion

## 🎨 Personnalisation

### Modifier les données de démonstration

**Pour le dashboard Enseignant :**
Éditez `enseignant-dashboard.component.ts` :

```typescript
this.plannings = [
  { 
    id: 1, 
    cours: 'Votre Cours', 
    salle: 'A101', 
    jour: 'Lundi', 
    heureDebut: '08:00', 
    heureFin: '10:00' 
  },
  // Ajoutez d'autres cours...
];
```

**Pour le dashboard Admin :**
Éditez `admin-dashboard.component.ts` :

```typescript
this.stats = [
  { title: 'Utilisateurs', value: 156, icon: '👥', color: '#667eea' },
  // Modifiez les valeurs...
];
```

### Modifier les couleurs

**Dashboard Enseignant :**
Éditez `enseignant-dashboard.component.css` :

```css
.dashboard-container {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  /* Changez les couleurs du gradient */
}
```

**Dashboard Admin :**
Éditez `admin-dashboard.component.css` :

```css
.sidebar {
  background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
  /* Changez les couleurs du gradient */
}
```

## 🔌 Intégration avec le Backend

### Prochaine étape : Connecter aux API

Pour remplacer les données de démonstration par de vraies données :

1. **Créer un service pour chaque entité**

```typescript
// planning.service.ts
@Injectable({ providedIn: 'root' })
export class PlanningService {
  private apiUrl = 'http://localhost:8082/api/planning';
  
  constructor(private http: HttpClient) {}
  
  getPlanningEnseignant(enseignantId: number): Observable<Planning[]> {
    return this.http.get<Planning[]>(`${this.apiUrl}/enseignant/${enseignantId}`);
  }
}
```

2. **Utiliser le service dans le composant**

```typescript
ngOnInit(): void {
  this.userInfo = this.authService.getCurrentUser();
  
  if (this.userInfo) {
    this.planningService.getPlanningEnseignant(this.userInfo.userId)
      .subscribe(plannings => {
        this.plannings = plannings;
        this.calculerTotalHeures();
      });
  }
}
```

## 🐛 Dépannage

### Problème : Redirection infinie vers /login
**Solution :** Vérifiez que le token est bien stocké dans localStorage après connexion

### Problème : Dashboard vide
**Solution :** Vérifiez que les données utilisateur sont correctement récupérées dans `ngOnInit()`

### Problème : Erreur de compilation
**Solution :** 
```bash
rm -rf node_modules
npm install
ng serve
```

## 📱 Responsive Design

Les dashboards sont conçus pour être responsive :
- Desktop : Affichage complet avec toutes les fonctionnalités
- Tablet : Adaptation automatique de la grille
- Mobile : À venir dans une prochaine version

## 🎯 Prochaines Fonctionnalités

- [ ] Intégration API backend
- [ ] Dashboard étudiant
- [ ] Notifications en temps réel
- [ ] Export PDF du planning
- [ ] Mode sombre
- [ ] Recherche et filtres avancés

## 💡 Conseils

1. **Développement** : Utilisez les données de démonstration pour tester l'interface
2. **Production** : Remplacez par les appels API réels
3. **Tests** : Créez des comptes de test pour chaque rôle
4. **Sécurité** : Ne stockez jamais de données sensibles en clair dans localStorage

## 📞 Support

Pour toute question, consultez :
- `DASHBOARDS.md` : Documentation complète
- `README.md` : Documentation générale du projet
