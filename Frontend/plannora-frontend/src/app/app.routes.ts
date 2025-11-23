import { Routes } from '@angular/router';
import { LoginComponent } from './login/login.component';
import { EnseignantDashboardComponent } from './enseignant-dashboard/enseignant-dashboard.component';
import { AdminDashboardComponent } from './admin-dashboard/admin-dashboard.component';
import { authGuard } from './guards/auth.guard';

export const routes: Routes = [
  { path: '', redirectTo: '/login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  { 
    path: 'enseignant-dashboard', 
    component: EnseignantDashboardComponent,
    canActivate: [authGuard],
    data: { role: 'ENSEIGNANT' }
  },
  { 
    path: 'admin-dashboard', 
    component: AdminDashboardComponent,
    canActivate: [authGuard],
    data: { role: 'ADMIN' }
  }
];
