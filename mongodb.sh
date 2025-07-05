#!/bin/bash
source ./common.sh
app_name=mongodb
checkroot

cp $scriptdir/mongo.repo /etc/yum.repos.d/mongo.repo &>>$logfile
validate $? "copying mongorepo to location"

dnf install mongodb-org -y &>>$logfile
validate $? "installing mongodb"

systemctl enable mongod &>>$logfile
systemctl start mongod &>>$logfile
validate $? "starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
validate $? "edited mongodconf file"

systemctl restart mongod
validate $? "restarting mongod"

printtime