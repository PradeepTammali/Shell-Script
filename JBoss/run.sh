#!/bin/bash

OUTPUT_DIR="/home/pradeep/Desktop/JBOSS/Jboss_automation/VDBs"

# The executable script to create VDBs in JBoss dynamically
bash /home/pradeep/Desktop/JBOSS/Jboss_automation/mysql.sh

# Creating VDBs using JBoss script for multiple tables.
for i in `ls $OUTPUT_DIR`
do
    bash /home/pradeep/Desktop/JBOSS/VDBBuilder/vdbbuilder-console-0.0.4-20160908/vdbbuilder.sh -f $OUTPUT_DIR/$i
done
