#!/bin/bash

USERNAME="root"
PASSWORD="root"
DBNAME="mydb"
TABLENAME="jboss"

# Output file path  where all theJBoss vdbs has to stored.
#OUTPUT_FILE_PATH=$1
OUTPUT_FILE_PATH="/home/pradeep/Desktop/JBOSS/Jboss_automation/VDBs"

# count number of VDB tables in mysql
count=$(mysql -N -u $USERNAME -p$PASSWORD -D $DBNAME -e "select count(*) from $TABLENAME")

# list of VDB names
vdb_name=$(mysql -N -u $USERNAME -p$PASSWORD -D $DBNAME -e "select VDBName from $TABLENAME ")

# Converting to array
vdb_names=($vdb_name)
for(( i=0; i< $count; i++ )) do
    # Check if the file already exist and remove it
    if [ -f "$OUTPUT_FILE_PATH/deploy_${vdb_names[$i]}" ] ; then
        echo "Removing the file if already exist."
        `rm -r -f $OUTPUT_FILE_PATH/deploy_${vdb_names[$i]}`
    fi
    echo "# Script to reproduce DynamicVDB" >> "$OUTPUT_FILE_PATH/deploy_${vdb_names[$i]}"
	# Wrinting the 'undeploying the vdb  from the JBoss' command to a file .
    echo "server-undeploy-vdb ${vdb_names[$i]}" >> "$OUTPUT_FILE_PATH/deploy_${vdb_names[$i]}"
	# Writing the 'deleting the vdb from JBoss' command to file.
    echo "delete-vdb ${vdb_names[$i]}"  >> "$OUTPUT_FILE_PATH/deploy_${vdb_names[$i]}"
done
