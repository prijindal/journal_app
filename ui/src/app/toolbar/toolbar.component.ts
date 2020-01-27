import { Component, OnInit } from '@angular/core';
import {BreakpointObserver, Breakpoints} from '@angular/cdk/layout';

import { UserService } from '../user.service';
import { JournalService } from '../journal.service';
import { SidebarService } from '../sidebar.service';
import { protobufs } from '../../protobufs';

@Component({
  selector: 'app-toolbar',
  templateUrl: './toolbar.component.html',
  styleUrls: ['./toolbar.component.scss']
})
export class ToolbarComponent implements OnInit {
  public isHandset: boolean | undefined;
  constructor(
    private sidebarService: SidebarService,
    private userService: UserService,
    private journalService: JournalService,
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

  get user(): protobufs.User | undefined {
    return this.userService.user;
  }

  ngOnInit(): void {
    this.userService.getUser();
  }

  toggleSidebar(): void {
    if (this.sidebarService.myNav != null) {
      this.sidebarService.myNav.toggle();
    }
  }

  refresh(): void {
    this.userService.getUser();
    this.journalService.getJournals();
  }
}
