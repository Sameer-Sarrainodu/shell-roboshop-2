#!/bin/bash
source ./common.sh
app_name=frontend
checkroot
dnf module disable nginx -y &>>$logfile
validate $? "disable default nginx"

dnf module enable nginx:1.24 -y &>>$logfile
validate $? "enableing nginx 1.24"

dnf install nginx -y &>>$logfile
validate $? "installing nginx"

rm -rf /usr/share/nginx/html/* &>>$logfile
validate $? "removing default"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$logfile
validate $? "downloading frontend resource"

cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$logfile
validate $? "unzipping frontend"

cp $scriptdir/nginx.conf /etc/nginx/nginx.conf
validate $? "copying nginx conf"

systemctl restart nginx
validate $? "restarting nginx"

printtime



