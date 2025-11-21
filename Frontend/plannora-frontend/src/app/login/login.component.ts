import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';

interface LoginResponse {
  token: string;
  type: string;
  userId: number;
  email: string;
  nom: string;
  prenom: string;
  role: string;
}

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {
  loginForm: FormGroup;
  errorMessage: string = '';
  isLoading: boolean = false;
  showPassword: boolean = false;
  private apiUrl = 'http://localhost:8082/api/auth';

  constructor(
    private fb: FormBuilder,
    private http: HttpClient,
    private router: Router
  ) {
    this.loginForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required, Validators.minLength(6)]]
    });
  }

  onSubmit(): void {
    if (this.loginForm.valid) {
      this.isLoading = true;
      this.errorMessage = '';

      this.http.post<LoginResponse>(`${this.apiUrl}/login`, this.loginForm.value).subscribe({
        next: (response) => {
          this.isLoading = false;
          localStorage.setItem('currentUser', JSON.stringify(response));
          localStorage.setItem('token', response.token);
          
          console.log('Connexion réussie!', response);
          alert(`Bienvenue ${response.prenom} ${response.nom}!\nRôle: ${response.role}`);
          
          // Redirection selon le rôle
          if (response.role === 'ADMIN') {
            console.log('Redirection vers admin dashboard');
          } else if (response.role === 'ENSEIGNANT') {
            console.log('Redirection vers enseignant dashboard');
          } else {
            console.log('Redirection vers etudiant dashboard');
          }
        },
        error: (error) => {
          this.isLoading = false;
          console.error('Erreur de connexion:', error);
          this.errorMessage = error.error?.message || 'Email ou mot de passe incorrect';
        }
      });
    }
  }

  togglePasswordVisibility(): void {
    this.showPassword = !this.showPassword;
  }

  get email() {
    return this.loginForm.get('email');
  }

  get password() {
    return this.loginForm.get('password');
  }
}
