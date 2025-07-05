#!/bin/bash
source ./common.sh
app_name=catalogue

checkroot
app_setup
nodejs_setup
system_setup

cp $scriptdir/mongo.repo /etc/yum.repos.d/mongo.repo 
dnf install mongodb-mongosh -y &>>$logfile
validate $? "Installing MongoDB Client"

STATUS=$(mongosh --host mongodb.sharkdev.shop --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ $STATUS -lt 0 ]
then
    mongosh --host mongodb.sharkdev.shop </app/db/master-data.js &>>$logfile
    VALIDATE $? "Loading data into MongoDB"
else
    echo -e "Data is already loaded ... $Y SKIPPING $N"
fi


printtime