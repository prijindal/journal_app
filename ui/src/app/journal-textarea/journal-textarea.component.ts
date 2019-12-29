import { Component, EventEmitter, forwardRef, Input, Output } from '@angular/core';
import {BreakpointObserver, Breakpoints} from '@angular/cdk/layout';

@Component({
  selector: 'app-journal-textarea',
  templateUrl: './journal-textarea.component.html',
  styleUrls: ['./journal-textarea.component.scss']
})
export class JournalTextareaComponent {
  public isHandset: boolean;
  public btnColor = 'primary';
  @Input() public content = '';
  @Output() public save = new EventEmitter<string>();
  constructor(
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

  onSubmit(e) {
    e.preventDefault();
    this.save.emit(this.content);
  }

}
