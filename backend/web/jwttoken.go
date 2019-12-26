package web

import (
	"fmt"
	"net/http"
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/prijindal/journal_app_backend/databases"
	"github.com/prijindal/journal_app_backend/models"
	uuid "github.com/satori/go.uuid"
)

/*ParseJwtToken ..*/
func ParseJwtToken(r *http.Request) (*models.User, *models.AccessToken, error) {
	// We can obtain the session token from the requests cookies, which come with every request
	c, err := r.Cookie("token")
	if err != nil {
		return nil, nil, err
	}

	// Get the JWT string from the cookie
	tknStr := c.Value

	// Initialize a new instance of `Claims`
	claims := &Claims{}

	// Parse the JWT string and store the result in `claims`.
	// Note that we are passing the key in this method as well. This method will return an error
	// if the token is invalid (if it has expired according to the expiry time we set on sign in),
	// or if the signature does not match
	tkn, err := jwt.ParseWithClaims(tknStr, claims, func(token *jwt.Token) (interface{}, error) {
		return jwtKey, nil
	})
	if err != nil {
		return nil, nil, err
	}
	if !tkn.Valid {
		return nil, nil, jwt.NewValidationError("Token invalid", 1)
	}

	accessToken := new(models.AccessToken)
	databases.GetPostgresClient().Model(accessToken).Where("token = ?", claims.Token).Select()

	user := new(models.User)

	databases.GetPostgresClient().Model(user).Where("id = ?", accessToken.UserID).Select()

	return user, accessToken, nil
}

/*RefreshToken ..*/
func RefreshToken(w http.ResponseWriter, r *http.Request, accessToken *models.AccessToken) error {
	// (BEGIN) The code uptil this point is the same as the first part of the `Welcome` route
	c, err := r.Cookie("token")
	if err != nil {
		if err == http.ErrNoCookie {
			w.WriteHeader(http.StatusUnauthorized)
			return err
		}
		w.WriteHeader(http.StatusBadRequest)
		return err
	}
	tknStr := c.Value
	claims := &Claims{}
	tkn, err := jwt.ParseWithClaims(tknStr, claims, func(token *jwt.Token) (interface{}, error) {
		return jwtKey, nil
	})
	if err != nil {
		if err == jwt.ErrSignatureInvalid {
			w.WriteHeader(http.StatusUnauthorized)
			return err
		}
		w.WriteHeader(http.StatusBadRequest)
		return err
	}
	if !tkn.Valid {
		w.WriteHeader(http.StatusUnauthorized)
		return jwt.NewValidationError("Invalid token", 1)
	}
	// (END) The code up-till this point is the same as the first part of the `Welcome` route

	// We ensure that a new token is not issued until enough time has elapsed
	// In this case, a new token will only be issued if the old token is within
	// 30 seconds of expiry. Otherwise, return a bad request status
	if time.Now().Sub(accessToken.UpdatedAt) > 24*time.Hour {
		w.WriteHeader(http.StatusUnauthorized)
		return jwt.NewValidationError("Expired token", 1)
	}

	// Now, create a new token for the current use, with a renewed expiration time
	expirationTime := time.Now().Add(24 * time.Hour)
	claims.ExpiresAt = expirationTime.Unix()
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(jwtKey)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return err
	}

	accessToken.UpdatedAt = time.Now()
	databases.GetPostgresClient().Model(accessToken).WherePK().Update()

	// Set the new token as the users `token` cookie
	http.SetCookie(w, &http.Cookie{
		Name:    "token",
		Path:    "/",
		Value:   tokenString,
		Expires: expirationTime,
	})
	return nil
}

/*SetJwtToken ..*/
func SetJwtToken(w http.ResponseWriter, user *models.User) {
	// Declare the expiration time of the token
	// here, we have kept it as 5 minutes
	expirationTime := time.Now().Add(24 * time.Hour)
	accessTokenString := uuid.NewV1().String()
	accessTokenModel := new(models.AccessToken)
	accessTokenModel.Token = accessTokenString
	accessTokenModel.UserID = user.ID
	databases.GetPostgresClient().Model(accessTokenModel).Insert()

	// Create the JWT claims, which includes the username and expiry time
	claims := &Claims{
		Token: accessTokenString,
		StandardClaims: jwt.StandardClaims{
			// In JWT, the expiry time is expressed as unix milliseconds
			ExpiresAt: expirationTime.Unix(),
		},
	}

	// Declare the token with the algorithm used for signing, and the claims
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	// Create the JWT string
	tokenString, err := token.SignedString(jwtKey)
	if err != nil {
		// If there is an error in creating the JWT return an internal server error
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	fmt.Println("Token set")
	// Finally, we set the client cookie for "token" as the JWT we just generated
	// we also set an expiry time which is the same as the token itself
	http.SetCookie(w, &http.Cookie{
		Name:    "token",
		Path:    "/",
		Value:   tokenString,
		Expires: expirationTime,
	})
}

/*UnSetJwtToken ..*/
func UnSetJwtToken(w http.ResponseWriter, accessToken *models.AccessToken) {
	// Set the new token as the users `token` cookie
	databases.GetPostgresClient().Model(accessToken).WherePK().Delete()
	http.SetCookie(w, &http.Cookie{
		Name:    "token",
		Path:    "/",
		Value:   "",
		Expires: time.Unix(0, 0),
	})
}
