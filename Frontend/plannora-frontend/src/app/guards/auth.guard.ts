import { inject } from '@angular/core';
import { Router, CanActivateFn } from '@angular/router';
import { AuthService } from '../services/auth.service';

export const authGuard: CanActivateFn = (route, state) => {
  const authService = inject(AuthService);
  const router = inject(Router);

  if (!authService.isAuthenticated()) {
    router.navigate(['/login']);
    return false;
  }

  // Vérifier le rôle si spécifié dans les données de la route
  const requiredRole = route.data['role'];
  if (requiredRole) {
    const userRole = authService.getUserRole();
    if (userRole !== requiredRole) {
      router.navigate(['/login']);
      return false;
    }
  }

  return true;
};
