package web

import (
	"github.com/dgrijalva/jwt-go"
	"github.com/prijindal/journal_app_backend/databases"
	"github.com/prijindal/journal_app_backend/models"
)

/*VerifyXSRFToken ... */
func VerifyXSRFToken(xsrfToken string) bool {
	if xsrfToken == "" {
		return false
	} else {
		claims := &Claims{}
		tkn, err := jwt.ParseWithClaims(xsrfToken, claims, func(token *jwt.Token) (interface{}, error) {
			return jwtKey, nil
		})
		if err != nil {
			return false
		}
		if !tkn.Valid {
			return false
		}
		accessToken := new(models.AccessToken)
		err = databases.GetPostgresClient().Model(accessToken).Where("token = ?", claims.Token).Select()

		if err != nil {
			return false
		}

		user := new(models.User)

		err = databases.GetPostgresClient().Model(user).Where("id = ?", accessToken.UserID).Select()

		if err != nil {
			return false
		}
		return true
	}
}
