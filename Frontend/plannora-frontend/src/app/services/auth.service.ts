import { Injectable } from '@angular/core';
import { Router } from '@angular/router';

interface UserInfo {
  token: string;
  type: string;
  userId: number;
  email: string;
  nom: string;
  prenom: string;
  role: string;
}

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  constructor(private router: Router) {}

  isAuthenticated(): boolean {
    const token = localStorage.getItem('token');
    return !!token;
  }

  getCurrentUser(): UserInfo | null {
    const userStr = localStorage.getItem('currentUser');
    return userStr ? JSON.parse(userStr) : null;
  }

  getUserRole(): string | null {
    const user = this.getCurrentUser();
    return user ? user.role : null;
  }

  logout(): void {
    localStorage.removeItem('currentUser');
    localStorage.removeItem('token');
    this.router.navigate(['/login']);
  }

  hasRole(role: string): boolean {
    const userRole = this.getUserRole();
    return userRole === role;
  }
}
