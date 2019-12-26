import { Component, OnInit } from '@angular/core';
import * as moment from "moment";

import { protobufs } from "../../protobufs"
import {JournalService} from "../journal.service"

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {
  private journalResponse:protobufs.JournalResponse;
  private content:string = ""
  constructor(private journalService:JournalService) { }

  ngOnInit() {
    this.journalService.getJournals()
    .then((data) => {
      this.journalResponse = data
    })
  }

  addJournal(e) {
    e.preventDefault()
    this.journalService.addJournal(this.content)
    .then((data) => {
      this.journalResponse.journals.unshift(data)
    })
  }

  deleteJournal(id:number) {
    this.journalService.deleteJournal(id)
    .then((data) => {
      this.journalResponse.journals = this.journalResponse.journals.filter((a) => a.id != id)
    })
  }

  doTextareaValueChange(e) {
    this.content = e.target.value
  }

  fromNow(date) {
    return moment.unix(date).fromNow()
  }

}
