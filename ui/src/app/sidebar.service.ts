import { Injectable, EventEmitter } from '@angular/core';
import { MatSidenav } from '@angular/material';

@Injectable({
  providedIn: 'root'
})
export class SidebarService {
  private myNavSidebar: MatSidenav;
  constructor() { }

  get myNav() {
    return this.myNavSidebar;
  }

  set myNav(myNav: MatSidenav) {
    this.myNavSidebar = myNav;
  }
}
