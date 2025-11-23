import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AuthService } from '../services/auth.service';

interface UserInfo {
  nom: string;
  prenom: string;
  email: string;
  role: string;
}

interface StatCard {
  title: string;
  value: number;
  icon: string;
  color: string;
}

@Component({
  selector: 'app-admin-dashboard',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './admin-dashboard.component.html',
  styleUrls: ['./admin-dashboard.component.css']
})
export class AdminDashboardComponent implements OnInit {
  userInfo: UserInfo | null = null;
  activeSection: string = 'overview';
  recentUsers: any[] = [];
  recentRooms: any[] = [];

  constructor(private authService: AuthService) {}

  ngOnInit(): void {
    this.userInfo = this.authService.getCurrentUser();

    // Données de démonstration
    this.recentUsers = [
      { name: 'Jesse Thomas', points: '637 Points', accuracy: '98% Correct', initials: 'JT', color: '#667eea' },
      { name: 'Thisal Mathiyazhagan', points: '637 Points', accuracy: '89% Correct', initials: 'TM', color: '#f093fb' },
      { name: 'Helen Chuang', points: '637 Points', accuracy: '88% Correct', initials: 'HC', color: '#4facfe' },
      { name: 'Lura Silverman', points: '637 Points', accuracy: '', initials: 'LS', color: '#43e97b' },
      { name: 'Winifred Groton', points: '637 Points', accuracy: '', initials: 'WG', color: '#f59e0b' }
    ];

    this.recentRooms = [
      { name: 'Salle 305 Batiment Secondaire R3', capacity: '50', type: 'Laboratoire' },
      { name: 'Salle 305 Batiment Secondaire R3', capacity: '50', type: 'Travaux Pratiques' },
      { name: 'Salle 305 Batiment Secondaire R3', capacity: '50', type: 'Transversale' },
      { name: 'Salle 305 Batiment Secondaire R3', capacity: '50', type: '' },
      { name: 'Salle 305 Batiment Secondaire R3', capacity: '50', type: '' }
    ];
  }

  setActiveSection(section: string): void {
    this.activeSection = section;
  }

  logout(): void {
    this.authService.logout();
  }
}
