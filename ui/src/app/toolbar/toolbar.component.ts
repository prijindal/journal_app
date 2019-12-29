import { Component, OnInit } from '@angular/core';
import {BreakpointObserver, Breakpoints} from '@angular/cdk/layout';

import {protobufs} from '../../protobufs';

import { UserService } from '../user.service';
import { SidebarService } from '../sidebar.service';

@Component({
  selector: 'app-toolbar',
  templateUrl: './toolbar.component.html',
  styleUrls: ['./toolbar.component.scss']
})
export class ToolbarComponent implements OnInit {
  public isHandset: boolean;
  public user: protobufs.User;
  constructor(
    private sidebarService: SidebarService,
    private userService: UserService,
    breakpointObserver: BreakpointObserver,
  ) {
    const layoutChanges = breakpointObserver.observe([
      Breakpoints.HandsetLandscape,
      Breakpoints.HandsetPortrait
    ]);
    layoutChanges.subscribe(result => {
      this.isHandset = result.matches;
    });
  }

  ngOnInit() {
    this.userService.getUser()
    .then((user) => {
      this.user = user;
    });
  }

  toggleSidebar() {
    this.sidebarService.myNav.toggle();
  }
}
