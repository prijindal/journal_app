package web

import (
	"fmt"
	"github.com/prijindal/journal_app_backend/config"
	"net/http"
	"net/http/httputil"
	"net/url"
)

/*ListenHTTP ..*/
func ListenHTTP() {
	http.HandleFunc("/", rootHandler)
	http.HandleFunc("/user", UserInfoHandler)
	http.HandleFunc("/login", LoginHandler)
	http.HandleFunc("/register", RegisterHandler)
	http.HandleFunc("/logout", LogoutHandler)
	http.HandleFunc("/app/", appHandler)
	http.HandleFunc("/sockjs-node/", appHandler)
	if err := http.ListenAndServe(config.GetConfig().BindAddress, nil); err != nil {
		panic(err)
	}
}

var data []byte

func rootHandler(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path == "/" {
		_, accessToken, err := ParseJwtToken(r)
		if err != nil {
			http.Redirect(w, r, "/login", 302)
		} else {
			err = RefreshToken(w, r, accessToken)
			if err != nil {
				fmt.Fprintf(w, err.Error())
			} else {
				http.Redirect(w, r, "/app/", 302)
			}
		}
	} else {
		w.WriteHeader(404)
	}
}

var prodFs = http.StripPrefix("/app/", http.FileServer(http.Dir("static")))

func appHandler(w http.ResponseWriter, r *http.Request) {
	_, accessToken, err := ParseJwtToken(r)
	if err != nil {
		http.Redirect(w, r, "/login", 302)
	} else {
		err = RefreshToken(w, r, accessToken)
		if err != nil {
			fmt.Fprintf(w, err.Error())
		} else {
			if config.GetConfig().Enviroment == "DEVELOPMENT" {
				url, _ := url.Parse("http://localhost:4200/")
				proxy := httputil.NewSingleHostReverseProxy(url)
				proxy.ServeHTTP(w, r)
			} else {
				prodFs.ServeHTTP(w, r)
			}
		}
	}
}
