package web

import (
	"fmt"
	"net/http"
	"strconv"

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
		fmt.Fprintf(w, err.Error())
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
					Uuid:      journal.UUID,
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
			xsrfToken := r.Header.Get("X-XSRF-TOKEN")
			if VerifyXSRFToken(xsrfToken) == false {
				return
			}
			content := r.FormValue("content")
			if content == "" {
				w.WriteHeader(500)
				fmt.Fprintf(w, err.Error())
				return
			}
			saveTypeText := r.FormValue("save_type")
			var saveType protobufs.Journal_JournalSaveType
			if saveTypeText == "ENCRYPTED" {
				saveType = protobufs.Journal_ENCRYPTED
			} else {
				saveType = protobufs.Journal_PLAINTEXT
			}
			uuid := r.FormValue("uuid")
			journal := new(models.Journal)
			journal.UserID = user.ID
			journal.Content = content
			journal.SaveType = saveType.String()
			journal.UUID = uuid
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
				Uuid:      journal.UUID,
			}
			res, err := proto.Marshal(journalData)
			if err != nil {
				w.WriteHeader(500)
				fmt.Fprintf(w, err.Error())
				return
			}
			w.Write(res)
		} else if r.Method == "PUT" {
			xsrfToken := r.Header.Get("X-XSRF-TOKEN")
			if VerifyXSRFToken(xsrfToken) == false {
				return
			}
			idTxt := r.FormValue("id")
			id, err := strconv.Atoi(idTxt)
			if err != nil {
				w.WriteHeader(500)
				fmt.Fprintf(w, err.Error())
				return
			}
			content := r.FormValue("content")
			if content == "" {
				w.WriteHeader(500)
				fmt.Fprintf(w, err.Error())
				return
			}
			saveTypeText := r.FormValue("save_type")
			var saveType protobufs.Journal_JournalSaveType
			if saveTypeText == "ENCRYPTED" {
				saveType = protobufs.Journal_ENCRYPTED
			} else {
				saveType = protobufs.Journal_PLAINTEXT
			}
			var journal models.Journal
			err = databases.GetPostgresClient().Model(&journal).Where("id = ?", id).Select()
			if err != nil {
				w.WriteHeader(500)
				fmt.Fprintf(w, err.Error())
				return
			}
			journal.ID = id
			journal.Content = content
			journal.SaveType = saveType.String()
			_, err = databases.GetPostgresClient().Model(&journal).Where("id = ?", id).Update()
			if err != nil {
				w.WriteHeader(500)
				fmt.Fprintf(w, err.Error())
				return
			}
			err = databases.GetPostgresClient().Model(&journal).Where("id = ?", id).Select()
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
				Uuid:      journal.UUID,
			}
			res, err := proto.Marshal(journalData)
			if err != nil {
				w.WriteHeader(500)
				fmt.Fprintf(w, err.Error())
				return
			}
			w.Write(res)
		} else if r.Method == "DELETE" {
			xsrfToken := r.Header.Get("X-XSRF-TOKEN")
			if VerifyXSRFToken(xsrfToken) == false {
				return
			}
			idTxt := r.URL.Query().Get("id")
			id, err := strconv.Atoi(idTxt)
			if err != nil {
				w.WriteHeader(500)
				fmt.Fprintf(w, err.Error())
				return
			}
			var journal models.Journal
			err = databases.GetPostgresClient().Model(&journal).Where("id = ?", id).Select()
			if err != nil {
				w.WriteHeader(500)
				fmt.Fprintf(w, err.Error())
				return
			}
			_, err = databases.GetPostgresClient().Model(&journal).Where("id = ?", id).Delete()
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
		} else {
			w.WriteHeader(405)
		}
	}
}
