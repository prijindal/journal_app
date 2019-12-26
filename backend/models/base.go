package models

import (
	"time"

	"github.com/go-pg/pg/v9/orm"
)

/*Base ..*/
type Base struct {
	CreatedAt time.Time `pg:"default:now()"`
	UpdatedAt time.Time `pg:"default:now()"`
}

/*BeforeInsert ..*/
func (b *Base) BeforeInsert(db orm.DB) error {
	if b.CreatedAt.IsZero() {
		b.CreatedAt = time.Now()
	}
	return nil
}

/*BeforeUpdate ..*/
func (b *Base) BeforeUpdate(db orm.DB) error {
	if b.UpdatedAt.IsZero() {
		b.UpdatedAt = time.Now()
	}
	return nil
}
