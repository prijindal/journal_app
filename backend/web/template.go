package web

import (
	"fmt"
	"html/template"
	"net/http"
)

/*HandleTemplate ..*/
func HandleTemplate(w http.ResponseWriter, page string, data interface{}) {
	templatePath := fmt.Sprintf("templates/%s.html", page)
	t, err := template.ParseFiles("templates/base.html", templatePath)
	if err != nil {
		fmt.Fprint(w, "Some error occurred")
	}
	err = t.ExecuteTemplate(w, "base", data)
	if err != nil {
		fmt.Fprint(w, "Some error occurred")
	}
}
