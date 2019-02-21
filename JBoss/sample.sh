#!/bin/bash

# Mysql Login credentials
USERNAME="root"
PASSWORD="root"
DBNAME="db"
TABLENAME="jboss"

# Fetching data from Mysql.
count=$(mysql -N -u $USERNAME -p$PASSWORD -D $DBNAME -e "select count(*) from $TABLENAME")
vdb_name=$(mysql -N -u $USERNAME -p$PASSWORD -D $DBNAME -e "select VDBName from $TABLENAME ")
model_name=$(mysql -N -u $USERNAME -p$PASSWORD -D $DBNAME -e "select ModelName from $TABLENAME ")
db_name=$(mysql -N -u $USERNAME -p$PASSWORD -D $DBNAME -e "select DBName from $TABLENAME ")
table_name=$(mysql -N -u $USERNAME -p$PASSWORD -D $DBNAME -e "select TableName from $TABLENAME ")
column_list=$(mysql -N -u $USERNAME -p$PASSWORD -D $DBNAME -e "select ColumnList from $TABLENAME ")
source_name=$(mysql -N -u $USERNAME -p$PASSWORD -D $DBNAME -e "select SourceName from $TABLENAME ")
source_jndi_name=$(mysql -N -u $USERNAME -p$PASSWORD -D $DBNAME -e "select sourceJndiName from $TABLENAME ")
source_translator=$(mysql -N -u $USERNAME -p$PASSWORD -D $DBNAME -e "select sourceTranslator from $TABLENAME ")
primary_key=$(mysql -N -u $USERNAME -p$PASSWORD -D $DBNAME -e "select Primary_Key from $TABLENAME ")

# Converting the data into arrays
vdb_names=($vdb_name)
model_names=($model_name)
db_names=($db_name)
table_names=($table_name)
column_lists=($column_list)
source_names=($source_name)
source_jndi_names=($source_jndi_name)
source_translators=($source_translator)
primary_keys=($primary_key)

# Printing the values
for(( i=0; i< $count; i++ )) do
    echo  ${vdb_names[$i]}
    echo  ${model_names[$i]}
done
