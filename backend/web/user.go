package web

import (
	"net/http"

	"github.com/dgrijalva/jwt-go"
	"github.com/go-pg/pg/v9"
	"github.com/golang/protobuf/proto"
	"github.com/prijindal/journal_app_backend/databases"
	"github.com/prijindal/journal_app_backend/models"
	"github.com/prijindal/journal_app_backend/protobufs"
	"golang.org/x/crypto/bcrypt"
)

// Create the JWT key used to create the signature
var jwtKey = []byte("my_secret_key")

/*Claims ..*/
// Create a struct that will be encoded to a JWT.
// We add jwt.StandardClaims as an embedded type, to provide fields like expiry time
type Claims struct {
	Token string
	jwt.StandardClaims
}

/*UserForm ..*/
type UserForm struct {
	Email    string
	Password string
}

/*LoginPageData ..*/
type LoginPageData struct {
	Error string
}

/*RegisterHandler ..*/
func RegisterHandler(w http.ResponseWriter, r *http.Request) {
	user, _, _ := ParseJwtToken(r)
	if user == nil {
		if r.Method == "GET" {
			HandleTemplate(w, "register", LoginPageData{})
		} else if r.Method == "POST" {
			r.ParseForm()
			userForm := &UserForm{}
			userForm.Email = r.FormValue("email")
			userForm.Password = r.FormValue("password")
			confirmPassword := r.FormValue("confirm_password")
			if confirmPassword != userForm.Password {
				HandleTemplate(w, "register", LoginPageData{
					Error: "Password do not match",
				})
			}
			user := new(models.User)
			err := databases.GetPostgresClient().Model(user).Where("email = ?", userForm.Email).Select()
			if err != pg.ErrNoRows {
				HandleTemplate(w, "register", LoginPageData{
					Error: "Email already exists",
				})
			} else {
				hashedPassword, err := bcrypt.GenerateFromPassword([]byte(userForm.Password), 10)
				if err != nil {
					HandleTemplate(w, "register", LoginPageData{
						Error: err.Error(),
					})
				} else {
					user = new(models.User)
					user.Email = userForm.Email
					user.Password = string(hashedPassword)
					_, err := databases.GetPostgresClient().Model(user).Insert(user)
					if err != nil {
						HandleTemplate(w, "register", LoginPageData{
							Error: err.Error(),
						})
					} else {
						SetJwtToken(w, user)
						http.Redirect(w, r, "/app/", 302)
					}
				}
			}
		}
	} else {
		http.Redirect(w, r, "/app/", 302)
	}
}

/*LoginHandler ..*/
func LoginHandler(w http.ResponseWriter, r *http.Request) {
	user, _, _ := ParseJwtToken(r)
	if user == nil {
		if r.Method == "GET" {
			HandleTemplate(w, "login", LoginPageData{})
		} else if r.Method == "POST" {
			r.ParseForm()
			userForm := &UserForm{}
			userForm.Email = r.FormValue("email")
			userForm.Password = r.FormValue("password")
			user := new(models.User)
			err := databases.GetPostgresClient().Model(user).Where("email = ?", userForm.Email).Select()
			if err == pg.ErrNoRows {
				HandleTemplate(w, "login", LoginPageData{
					Error: "Username or password is invalid",
				})
			} else {
				err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(userForm.Password))
				if err != nil {
					HandleTemplate(w, "login", LoginPageData{
						Error: "Username or password is invalid",
					})
				} else {
					SetJwtToken(w, user)
					http.Redirect(w, r, "/app/", 302)
				}
			}
		}
	} else {
		http.Redirect(w, r, "/app/", 302)
	}
}

/*LogoutHandler ..*/
func LogoutHandler(w http.ResponseWriter, r *http.Request) {
	_, accessToken, err := ParseJwtToken(r)
	if err != nil {
		http.Redirect(w, r, "/login", 302)
	} else {
		if r.Method == "GET" {
			UnSetJwtToken(w, accessToken)
			http.Redirect(w, r, "/login", 302)
		}
	}
}

/*UserInfoHandler ..*/
func UserInfoHandler(w http.ResponseWriter, r *http.Request) {
	user, _, err := ParseJwtToken(r)
	if err != nil {
		w.WriteHeader(403)
	} else {
		if r.Method == "GET" {
			userResponse := &protobufs.User{
				Id:        int64(user.ID),
				Email:     user.Email,
				FirstName: user.FirstName,
				LastName:  user.LastName,
				CreatedAt: user.CreatedAt.Unix(),
				UpdatedAt: user.UpdatedAt.Unix(),
			}
			res, err := proto.Marshal(userResponse)
			if err != nil {
				w.WriteHeader(500)
			} else {
				w.Write(res)
			}
		}
	}
}
