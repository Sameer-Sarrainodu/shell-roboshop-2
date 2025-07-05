#!/bin/bash
source ./common.sh
app_name=redis

checkroot

dnf module disable redis -y &>>$logfile
validate $? "disable redis"

dnf module enable redis:7 -y &>>$logfile
validate $? "enable redis"

dnf install redis -y &>>$logfile
validate $? "installing redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$logfile
validate $? "changes in default redis conf"

systemctl enable redis &>>$logfile
systemctl start redis &>>$logfile

printtime