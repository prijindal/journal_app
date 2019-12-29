import { Injectable, EventEmitter } from '@angular/core';
import { MatSidenav } from '@angular/material';

@Injectable({
  providedIn: 'root'
})
export class SidebarService {
  private _myNav: MatSidenav;
  constructor() { }

  get myNav() {
    return this._myNav;
  }

  set myNav(myNav: MatSidenav) {
    this._myNav = myNav;
  }
}
