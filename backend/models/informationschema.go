package models

/*InformationSchemaColumn ..*/
type InformationSchemaColumn struct {
	tableName     struct{} `pg:",discard_unknown_columns"`
	TableCatalog  string
	TableSchema   string
	ColumnName    string
	ColumnDefault string
	IsNullable    bool
	DataType      string
	UdtName       string
}
