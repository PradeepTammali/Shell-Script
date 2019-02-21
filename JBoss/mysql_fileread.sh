#!/bin/bash

USERNAME="root"
PASSWORD="root"
INPUT_FILE_PATH="/home/pradeep/Desktop/JBOSS/Jboss_automation/DynamicVDB.csv"
OUTPUT_FILE_PATH="/home/pradeep/Desktop/JBOSS/Jboss_automation/VDBs"

# Reading VDB parameters from csv file
sed 1d $INPUT_FILE_PATH | while IFS="," read VDBName ModelName DBName TableName ColumnList SourceName sourceJndiName sourceTranslator Primary_key
do
    # removing the existing VDB files from the output location.
    if [ -f "$OUTPUT_FILE_PATH/$VDBName" ] ; then
        echo "Remove the file if already exist."
        `rm -r -f $OUTPUT_FILE_PATH/$VDBName`
    fi
    myfun(){
        echo "# Script to reproduce DynamicVDB"
        # undeploying and deleting the VDB from JBoss
        echo "server-undeploy-vdb $VDBName"
        echo "delete-vdb $VDBName"
        # creating, adding model and table to JBoss
        echo "create-vdb $VDBName"
        echo "cd $VDBName"
        echo "set-property description 'Dynamic VDB creation'"
        echo "add-model $ModelName"
        echo "cd $ModelName"
        echo "add-table $TableName"
        echo "cd $TableName"
        echo "set-property NAMEINSOURCE '$DBName.$TableName'"
        
        # Get the column names from the specified table name.
        name=$(mysql -N -u $USERNAME -p$PASSWORD -D $DBName -e "select COLUMN_NAME from information_schema.columns where table_name='$TableName'")
        names=($name)
        
        # Get the data type of the column from the table.
        data_type=$(mysql -N -u $USERNAME -p$PASSWORD -D $DBName -e "select DATA_TYPE from information_schema.columns where table_name='$TableName'")
        data_types=($data_type)
        
        # Length of the column from table.
        length=$(mysql -N -u $USERNAME -p$PASSWORD -D $DBName -e "select CHARACTER_MAXIMUM_LENGTH from information_schema.columns where table_name='$TableName'")
        sizes=($length)
        
        # Checking whether the column can be null or not.
        nullable=$(mysql -N -u $USERNAME -p$PASSWORD -D $DBName -e "select IS_NULLABLE from information_schema.columns where table_name='$TableName'")
        nulls=($nullable)
        
        # If column list is null add columns to JBoss VDB.
        if [[ "${ColumnList}" == "null" ||  "${ColumnList}" == "NULL" ]]; then
            for (( i = 0 ; i < ${#names[@]} ; i++ )) do
                echo "add-column ${names[$i]}"
                echo "cd ${names[$i]}"
                if [[ "${data_types[$i]}" == "varchar" ]]; then
                    echo "set-property datatypeName string"
                fi
                echo "set-property datatypeLength ${sizes[$i]}"
                echo "set-property NATIVE_TYPE ${data_types[$i]}"
                echo "set-property NAMEINSOURCE '${names[$i]}'"
                if [[ "${nulls[$i]}" == "NO" ]]; then
                    echo "set-property nullable NO_NULLS"
                fi
                echo "cd .."
            done
        fi
        # Adding primary and Primart key Column
        echo "add-primary-key pk"
        echo "cd pk"
        echo "add-column /workspace/$VDBName/$ModelName/$TableName/$Primary_key"
        echo "cd ../../"
        echo "# PartsSQLServer VdbModelSource"
        echo "add-source $SourceName"
        echo "cd $SourceName"
        echo "set-property sourceJndiName $sourceJndiName"
        echo "set-property sourceTranslator $sourceTranslator"
        echo "cd ../../../"
        echo "server-deploy-vdb $VDBName"
    } >> $OUTPUT_FILE_PATH/$VDBName
    myfun
done
