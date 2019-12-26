package databases

import (
	"fmt"
	"strings"

	"github.com/go-pg/pg/v9"
	"github.com/go-pg/pg/v9/orm"
	"github.com/prijindal/journal_app_backend/config"
	"github.com/prijindal/journal_app_backend/models"
)

var postgresClient *pg.DB

/*InitPostgreSQL ...*/
func InitPostgreSQL() {
	pgConfig, err := pg.ParseURL(config.GetConfig().PostgresURL)
	if err != nil {
		panic(err)
	}
	println("PostgreSQL connecting")
	postgresClient = pg.Connect(pgConfig)
	err = createSchema()
	if err != nil {
		panic(err)
	}
	println("PostgreSQL connected")
}

/*GetPostgresClient ..*/
func GetPostgresClient() *pg.DB {
	return postgresClient
}

/*CleanUpPostgreSQL ..*/
func CleanUpPostgreSQL() {
	postgresClient.Close()
}

func compareFields(dbField models.InformationSchemaColumn, structField *orm.Field) bool {
	same := dbField.DataType == structField.SQLType
	if same == false {
		if dbField.DataType == "timestamp with time zone" && structField.SQLType == "timestamptz" {
			same = true
		} else if dbField.DataType == "USER-DEFINED" {
			if dbField.UdtName == structField.SQLType {
				same = true
			}
		}
	}
	return same
}

func createSchema() error {
	schemas := []interface{}{
		(*models.User)(nil),
		(*models.AccessToken)(nil),
	}
	for _, model := range schemas {
		err := postgresClient.CreateTable(model, &orm.CreateTableOptions{
			IfNotExists: true,
		})
		if err != nil {
			return err
		}
		var informationSchemaColumns []models.InformationSchemaColumn
		// tableNameType := reflect.TypeOf(model).String()
		// res1 := strings.Split(tableNameType, "*models.")
		// tableName := res1[1] + "s"
		tableNameType := postgresClient.Model(model).TableModel().Table().FullName
		tableName := string(tableNameType)
		tableName = strings.Trim(tableName, "\"")
		query := "SELECT * FROM information_schema.columns WHERE table_name=LOWER(?)"
		_, err = postgresClient.Query(&informationSchemaColumns, query, tableName)
		if err != nil {
			panic(err)
		}
		fields := postgresClient.Model(model).TableModel().Table().Fields
		var fieldsMap = map[string]*orm.Field{}
		for _, field := range fields {
			sqlType := strings.ToLower(field.UserSQLType)
			if sqlType == "" {
				sqlType = field.SQLType
			}
			columnName := fmt.Sprintf("%s", field.Column)
			columnName = strings.Trim(columnName, "\"")
			fieldsMap[columnName] = field
		}
		var schemaFieldsMap = map[string]models.InformationSchemaColumn{}
		for _, informationSchemaColumn := range informationSchemaColumns {
			value, ok := fieldsMap[informationSchemaColumn.ColumnName]
			if !ok || !compareFields(informationSchemaColumn, value) {
				fmt.Printf("Not matched, %s: %s %s\n", informationSchemaColumn.ColumnName, informationSchemaColumn.DataType, value.SQLType)
			}
			schemaFieldsMap[informationSchemaColumn.ColumnName] = informationSchemaColumn
		}
		for columnName, sqlType := range fieldsMap {
			value, ok := schemaFieldsMap[columnName]
			if !ok || !compareFields(value, sqlType) {
				fmt.Printf("Not matched, %s: %s %s\n", columnName, sqlType.SQLType, value.DataType)
			}
		}
	}
	return nil
}
