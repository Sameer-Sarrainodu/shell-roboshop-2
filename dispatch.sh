#!/bin/bash
source ./common.sh
app_name=dispatch

checkroot
app_setup

dnf install golang -y
validate $? "installing golang"

go mod init dispatch &>>$logfile
validate $? "go init"

go get &>>$logfile
validate $? "getting log"

go build &>>$logfile
validate $? "buildng go"

system_setup
printtime

