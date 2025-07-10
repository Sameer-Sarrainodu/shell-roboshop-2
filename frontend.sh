#!/bin/bash

source ./common.sh
checkroot

dnf module disable nginx -y &>>$logfile
validate $? "Disabling Default Nginx"

dnf module enable nginx:1.24 -y &>>$logfile
validate $? "Enabling Nginx:1.24"

dnf install nginx -y &>>$logfile
validate $? "Installing Nginx"

systemctl enable nginx  &>>$logfile
systemctl start nginx 
validate $? "Starting Nginx"

rm -rf /usr/share/nginx/html/* &>>$logfile
validate $? "Removing default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$logfile
validate $? "Downloading frontend"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$logfile
validate $? "unzipping frontend"

rm -rf /etc/nginx/nginx.conf &>>$logfile
validate $? "Remove default nginx conf"

cp $scriptdir/nginx.conf /etc/nginx/nginx.conf
validate $? "Copying nginx.conf"

systemctl restart nginx 
validate $? "Restarting nginx"

printtime


