#!/bin/bash
source ./common.sh
app_name=mysql
checkroot
dnf install mysql-server -y &>>$logfile
validate $? "installing mysql"

systemctl enable mysqld
systemctl start mysqld &>>$logfile
validate $? "starting mysql"

mysql_secure_installation --set-root-pass RoboShop@1
validate $? "setting root passwd"


printtime