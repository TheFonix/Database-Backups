#!/bin/bash

#Variables to be completed
USER="HIDDEN"
PASSWORD="HIDDEN"
OUTPUT="HIDDEN"

#Empty out the Output directory
echo "Empty out the Output directory"
rm -rf $OUTPUT/*.gz
sleep 2

#Create the Ouput Folder if it doesnt exist
echo "Create the Ouput Folder if it doesnt exist"
mkdir -p $OUTPUT
sleep 2

#Make a directory for the current date!
mkdir $OUTPUT/`date +%Y-%m-%d`

#Init Connection and Trigger Location and Backup of Every Database
echo "Init Connection and Trigger Backup of Every Database"
databases=`mysql --user=$USER --password=$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != _* ]] ; then
        echo "Dumping database: $db"
        mysqldump --force --opt --user=$USER --password=$PASSWORD --databases $db > $OUTPUT/`date +%Y%m%d`.$db.sql
        gzip $OUTPUT/`date +%Y%m%d`.$db.sql
    fi
done

#Move all compressed files into a dated directory!
mv $OUTPUT/*.gz $OUTPUT/`date +%Y%m%d`/

#Get rid of files older than specified date
echo "Remmoving files older than a week!"
sleep 1
find $OUTPUT* -mtime +7 -exec rm -rf {} \;

echo "Done"
