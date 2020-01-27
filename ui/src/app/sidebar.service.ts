import { Injectable, EventEmitter } from '@angular/core';
import { MatSidenav } from '@angular/material';

@Injectable({
  providedIn: 'root'
})
export class SidebarService {
  private myNavSidebar: MatSidenav | undefined;
  constructor() { }

  get myNav(): MatSidenav | undefined {
    return this.myNavSidebar;
  }

  set myNav(myNav: MatSidenav | undefined) {
    this.myNavSidebar = myNav;
  }
}
