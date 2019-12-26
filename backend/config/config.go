package config

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
)

/*Config ...*/
type Config struct {
	PostgresURL string `json:"POSTGRES_URL"`
	Enviroment  string `json:"ENVIRONMENT"`
	BindAddress string `json:"BIND_ADDRESS"`
}

var config *Config

/*GetConfig ...*/
func GetConfig() Config {
	if config != nil {
		return *config
	}
	jsonFile, err := os.Open("config/config.json")
	// if we os.Open returns an error then handle it
	if err != nil {
		panic(err)
	}
	byteValue, _ := ioutil.ReadAll(jsonFile)
	config = new(Config)
	err = json.Unmarshal(byteValue, config)
	if err != nil {
		panic(err)
	}
	fmt.Println("Successfully Opened config.json")
	// defer the closing of our jsonFile so that we can parse it later on
	defer jsonFile.Close()
	return *config
}
