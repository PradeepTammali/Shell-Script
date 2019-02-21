#!/bin/bash

USERNAME="root"
PASSWORD="root"
DBNAME="mydb"
TABLENAME="jboss"

#OUTPUT_FILE_PATH=$1
OUTPUT_FILE_PATH="/home/pradeep/Desktop/JBOSS/Jboss_automation/VDBs"

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
        
# Converting data into Arrays
vdb_names=($vdb_name)
model_names=($model_name)
db_names=($db_name)
table_names=($table_name)
column_lists=($column_list)
source_names=($source_name)
source_jndi_names=($source_jndi_name)
source_translators=($source_translator)
primary_keys=($primary_key)

for(( i=0; i< $count; i++ )) do
	if [ -f "$OUTPUT_FILE_PATH/${vdb_names[$i]}" ] ; then
	        echo "Remove the file if already exist."
		`rm -r -f $OUTPUT_FILE_PATH/${vdb_names[$i]}`
	fi
	myfun(){
		echo "# Script to reproduce DynamicVDB"
		# echo "server-undeploy-vdb ${vdb_names[$i]}"
		# echo "delete-vdb ${vdb_names[$i]}"
	   	echo "create-vdb ${vdb_names[$i]}" 
		echo "cd ${vdb_names[$i]}" 
		echo "set-property description 'Dynamic VDB creation'" 
		echo "add-model ${model_names[$i]}"  
		echo "cd ${model_names[$i]}" 
	    echo "add-table ${table_names[$i]}" 
		echo "cd ${table_names[$i]}" 
		echo "set-property NAMEINSOURCE '${db_names[$i]}.${table_names[$i]}'" 

		name=$(mysql -N -u $USERNAME -p$PASSWORD -D ${db_names[$i]} -e "select COLUMN_NAME from information_schema.columns where table_name='${table_names[$i]}'")
		names=($name)

		data_type=$(mysql -N -u $USERNAME -p$PASSWORD -D ${db_names[$i]} -e "select DATA_TYPE from information_schema.columns where table_name='${table_names[$i]}'")
		data_types=($data_type)

		length=$(mysql -N -u $USERNAME -p$PASSWORD -D ${db_names[$i]} -e "select CHARACTER_MAXIMUM_LENGTH from information_schema.columns where table_name='${table_names[$i]}'")
		sizes=($length)

		nullable=$(mysql -N -u $USERNAME -p$PASSWORD -D ${db_names[$i]} -e "select IS_NULLABLE from information_schema.columns where table_name='${table_names[$i]}'")
		nulls=($nullable)

		# Adding columns for each VDB.
		if [[ "${column_lists[$i]}" == "null" ||  "${column_lists[$i]}" == "NULL" ]]; then
			for (( j = 0 ; j < ${#names[@]} ; j++ )) do
				echo "add-column ${names[$j]}"  
				echo "cd ${names[$j]}"  
				if [[ "${data_types[$j]}" == "varchar" || "${data_types[$j]}" == "VARCHAR" ]]; then 
					echo "set-property datatypeName string" 
				elif [[ "${data_types[$j]}" == "int" || "${data_types[$j]}" == "INT" ]]; then
	                echo "set-property datatypeName integer"
				fi
				echo "set-property datatypeLength ${sizes[$j]}" 
				echo "set-property NATIVE_TYPE ${data_types[$j]}" 
				echo "set-property NAMEINSOURCE '${names[$j]}'" 
				if [[ "${nulls[$j]}" == "NO" ]]; then 
					echo "set-property nullable NO_NULLS" 
				fi
				echo "cd .."  
			done
		else
			# Reading multiple column separated by ;
			IFS=';' read -ra list <<< "${column_lists[$i]}"
			for j in "${list[@]}"; do
	        		for (( k=0; k< ${#names[@]} ; k++ )) do
	        			if [[ "${names[$k]}" == "$j" ]];then
						echo "add-column ${names[$k]}"  
          	                 		echo "cd ${names[$k]}"  
               	           			if [[ "${data_types[$k]}" == "varchar" || "${data_types[$k]}" == "VARCHAR" ]]; then
                                        		echo "set-property datatypeName string"
						elif [[ "${data_types[$k]}" == "int" || "${data_types[$k]}" == "INT" ]]; then
                                        		echo "set-property datatypeName integer"
                                		fi
                            			echo "set-property datatypeLength ${sizes[$k]}" 
                                		echo "set-property NATIVE_TYPE ${data_types[$k]}" 
                                		echo "set-property NAMEINSOURCE '${names[$k]}'" 
                                		if [[ "${nulls[$k]}" == "NO" ]]; then
                                        		echo "set-property nullable NO_NULLS" 
                                		fi
                                		echo "cd .."
					fi 
	       			done
			done
		fi
		# Adding primary Keys.
        echo "add-primary-key pk" 
        echo "cd pk" 
       	echo "add-column /workspace/${vdb_names[$i]}/${model_names[$i]}/${table_names[$i]}/${primary_keys[$i]}" 
        echo "cd ../../" 
		echo "# PartsSQLServer VdbModelSource"  
		echo "add-source ${source_names[$i]}" 
		echo "cd ${source_names[$i]}" 
		echo "set-property sourceJndiName ${source_jndi_names[$i]}" 
		echo "set-property sourceTranslator ${source_translators[$i]}" 
		echo "cd ../../../"  
		echo "server-deploy-vdb ${vdb_names[$i]}"  
	} >> $OUTPUT_FILE_PATH/${vdb_names[$i]}
	myfun
done
