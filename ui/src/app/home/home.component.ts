import { Component, OnInit } from '@angular/core';
import {BreakpointObserver, Breakpoints} from '@angular/cdk/layout';
import { Router } from '@angular/router';

import {JournalService} from '../journal.service';

enum TextAreaMode {
  EDITING,
  CREATING
}

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {
  public isHandset: boolean;
  public content = '';
  constructor(
    private journalService: JournalService,
    private router: Router,
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
  }

  addJournal(newContent: string) {
    this.journalService.addJournal(newContent)
    .then((data) => {
      this.router.navigate(['/journal', data.id]);
      this.content = '';
    });
  }
}
