package main

import (
	"os"
	"os/signal"

	"github.com/prijindal/journal_app_backend/databases"
	"github.com/prijindal/journal_app_backend/web"
)

func main() {

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	quit := make(chan struct{})
	databases.InitPostgreSQL()
	go web.ListenHTTP()
	<-quit // hang until an error
}
