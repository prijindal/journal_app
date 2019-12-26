package web

import (
	"fmt"
	"net/http"

	"github.com/golang/protobuf/proto"
	"github.com/prijindal/journal_app_backend/databases"
	"github.com/prijindal/journal_app_backend/models"
	"github.com/prijindal/journal_app_backend/protobufs"
)

/*JournalHandler ..*/
func JournalHandler(w http.ResponseWriter, r *http.Request) {
	user, _, err := ParseJwtToken(r)
	if err != nil {
		w.WriteHeader(403)
	} else {
		if r.Method == "GET" {
			var size = 20
			var journals []models.Journal
			count, err := databases.GetPostgresClient().Model(&journals).
				Where("user_id = ?", user.ID).
				Limit(size).
				Order("created_at DESC").
				SelectAndCount()
			if err != nil {
				w.WriteHeader(500)
				fmt.Fprintf(w, err.Error())
				return
			}
			var journalResponse = new(protobufs.JournalResponse)
			journalResponse.Total = int64(count)
			journalResponse.Size = int64(size)
			for _, journal := range journals {
				journalData := &protobufs.Journal{
					Id:        int64(journal.ID),
					UserId:    int64(journal.UserID),
					SaveType:  protobufs.Journal_JournalSaveType(protobufs.Journal_JournalSaveType_value[journal.SaveType]),
					Content:   journal.Content,
					CreatedAt: journal.CreatedAt.Unix(),
					UpdatedAt: journal.UpdatedAt.Unix(),
				}
				journalResponse.Journals = append(journalResponse.Journals, journalData)
			}
			res, err := proto.Marshal(journalResponse)
			if err != nil {
				w.WriteHeader(500)
				fmt.Fprintf(w, err.Error())
				return
			}
			w.Write(res)
		} else if r.Method == "POST" {
			content := r.FormValue("content")
			if content == "" {
				w.WriteHeader(500)
				fmt.Fprintf(w, err.Error())
				return
			}
			journal := new(models.Journal)
			journal.UserID = user.ID
			journal.Content = content
			_, err := databases.GetPostgresClient().Model(journal).Insert(journal)
			if err != nil {
				w.WriteHeader(500)
				fmt.Fprintf(w, err.Error())
				return
			}
			journalData := &protobufs.Journal{
				Id:        int64(journal.ID),
				UserId:    int64(journal.UserID),
				SaveType:  protobufs.Journal_JournalSaveType(protobufs.Journal_JournalSaveType_value[journal.SaveType]),
				Content:   journal.Content,
				CreatedAt: journal.CreatedAt.Unix(),
				UpdatedAt: journal.UpdatedAt.Unix(),
			}
			res, err := proto.Marshal(journalData)
			if err != nil {
				w.WriteHeader(500)
				fmt.Fprintf(w, err.Error())
				return
			}
			w.Write(res)
		}
	}
}
