package models

/*Journal ..*/
type Journal struct {
	ID       int
	UserID   int
	SaveType string `pg:"type:journal_save_type,default:'PLAINTEXT'"`
	Content  string
	Base
}

/*
Enum user_role
CREATE TYPE journal_save_type AS ENUM('PLAINTEXT', 'ENCRYPTED')
*/
