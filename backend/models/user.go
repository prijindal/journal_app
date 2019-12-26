package models

/*User ..*/
type User struct {
	ID        int
	FirstName string
	LastName  string
	Email     string
	Password  string
	Role      string `pg:"type:user_role,default:'GUEST'"`
	Base
}

/*
Enum user_role
CREATE TYPE user_role AS ENUM('ADMIN', 'GUEST')
*/

/*AccessToken ..*/
type AccessToken struct {
	ID     int
	UserID int
	Token  string
	Base
}
