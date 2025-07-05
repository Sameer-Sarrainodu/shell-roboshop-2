#!/bin/bash
source ./common.sh
app_name=shipping

checkroot

dnf install maven -y &>>$logfile
validate $? "installing maven"

app_setup

mvn clean package &>>$logfile 
validate $? "clean mvn project" 

mv target/shipping-1.0.jar shipping.jar &>>$logfile
validate $? "mvoing shipping"

system_setup
dnf install mysql -y
validate $? "installing mysql"

mysql -h mysql.sharkdev.shop -uroot -pRoboShop@1 < /app/db/schema.sql
mysql -h mysql.sharkdev.shop -uroot -pRoboShop@1 < /app/db/app-user.sql
mysql -h mysql.sharkdev.shop -uroot -pRoboShop@1 < /app/db/master-data.sql

systemctl restart shipping
validate $? "restarting"

printtime