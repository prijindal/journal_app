import { Component, EventEmitter, forwardRef, Input, Output } from '@angular/core';
import {BreakpointObserver, Breakpoints} from '@angular/cdk/layout';

@Component({
  selector: 'app-journal-textarea',
  templateUrl: './journal-textarea.component.html',
  styleUrls: ['./journal-textarea.component.scss']
})
export class JournalTextareaComponent {
  public isHandset: boolean | undefined;
  public btnColor: string = 'primary';
  @Input() public content: string = '';
  @Output() public save: EventEmitter<string> = new EventEmitter<string>();
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

  onSubmit(e: any): void {
    e.preventDefault();
    this.save.emit(this.content);
  }

}
