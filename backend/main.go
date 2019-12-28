package main

import (
	"fmt"
	"os"
	"os/signal"

	"github.com/prijindal/journal_app_backend/databases"
	"github.com/prijindal/journal_app_backend/web"
)

func main() {

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	databases.InitPostgreSQL()
	go func() {
		<-c
		fmt.Println("Cleaning up")
		databases.CleanUpPostgreSQL()
		os.Exit(1)
	}()
	quit := make(chan struct{})
	go web.ListenHTTP()
	<-quit // hang until an error
}
