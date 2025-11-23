import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AuthService } from '../services/auth.service';

interface UserInfo {
  nom: string;
  prenom: string;
  email: string;
  role: string;
}

interface Planning {
  id: number;
  cours: string;
  salle: string;
  jour: string;
  heureDebut: string;
  heureFin: string;
}

@Component({
  selector: 'app-enseignant-dashboard',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './enseignant-dashboard.component.html',
  styleUrls: ['./enseignant-dashboard.component.css']
})
export class EnseignantDashboardComponent implements OnInit {
  userInfo: UserInfo | null = null;
  plannings: Planning[] = [];
  totalHeures: number = 0;
  activeSection: string = 'overview';

  constructor(private authService: AuthService) {}

  ngOnInit(): void {
    this.userInfo = this.authService.getCurrentUser();

    // Données de démonstration
    this.plannings = [
      { id: 1, cours: 'Mathématiques', salle: 'A101', jour: 'Lundi', heureDebut: '08:00', heureFin: '10:00' },
      { id: 2, cours: 'Physique', salle: 'B205', jour: 'Mardi', heureDebut: '10:00', heureFin: '12:00' },
      { id: 3, cours: 'Mathématiques', salle: 'A101', jour: 'Mercredi', heureDebut: '14:00', heureFin: '16:00' },
      { id: 4, cours: 'Physique', salle: 'B205', jour: 'Jeudi', heureDebut: '08:00', heureFin: '10:00' }
    ];

    this.calculerTotalHeures();
  }

  setActiveSection(section: string): void {
    this.activeSection = section;
  }

  getSectionTitle(): string {
    const titles: { [key: string]: string } = {
      'overview': 'Dashboard Enseignant',
      'planning': 'Mon Planning',
      'courses': 'Mes Cours',
      'reservations': 'Réservations de Salles',
      'students': 'Mes Étudiants',
      'notifications': 'Notifications'
    };
    return titles[this.activeSection] || 'Dashboard Enseignant';
  }

  calculerTotalHeures(): void {
    this.totalHeures = this.plannings.reduce((total, planning) => {
      const debut = this.convertirHeureEnMinutes(planning.heureDebut);
      const fin = this.convertirHeureEnMinutes(planning.heureFin);
      return total + (fin - debut) / 60;
    }, 0);
  }

  convertirHeureEnMinutes(heure: string): number {
    const [h, m] = heure.split(':').map(Number);
    return h * 60 + m;
  }

  logout(): void {
    this.authService.logout();
  }
}
