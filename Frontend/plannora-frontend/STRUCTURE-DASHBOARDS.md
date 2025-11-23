# Structure des Dashboards - Vue d'Ensemble

## 📁 Arborescence des Fichiers

```
Frontend/plannora-frontend/src/app/
│
├── login/
│   ├── login.component.ts          ✅ Modifié (redirection selon rôle)
│   ├── login.component.html
│   └── login.component.css
│
├── enseignant-dashboard/           ✨ NOUVEAU
│   ├── enseignant-dashboard.component.ts
│   ├── enseignant-dashboard.component.html
│   └── enseignant-dashboard.component.css
│
├── admin-dashboard/                ✨ NOUVEAU
│   ├── admin-dashboard.component.ts
│   ├── admin-dashboard.component.html
│   └── admin-dashboard.component.css
│
├── services/                       ✨ NOUVEAU
│   └── auth.service.ts
│
├── guards/                         ✨ NOUVEAU
│   └── auth.guard.ts
│
├── app.routes.ts                   ✅ Modifié (nouvelles routes + guards)
├── app.config.ts
├── app.ts
└── app.html
```

## 🎯 Architecture des Composants

```
┌────────────────────