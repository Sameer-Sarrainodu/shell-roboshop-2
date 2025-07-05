#!/bin/bash
source ./common.sh
app_name=rabbitmq
checkroot

cp $scriptdir/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
validate $? "rabbitmq repo file"

dnf install rabbitmq-server -y &>>$logfile
validate $? "installing rabbitmq"

systemctl enable rabbitmq-server
systemctl start rabbitmq-server
validate $? "starting rabbitmq"

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
validate $? "permision"

printtime