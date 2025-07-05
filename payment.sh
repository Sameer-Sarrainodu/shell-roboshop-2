#!/bin/bash
source ./common.sh
app_name=payment
checkroot
app_setup

dnf install python3 gcc python3-devel -y &>>$logfile
validate $? "python3 installation"

pip3 install -r requirements.txt &>>$logfile
validate $? "installing req"

system_setup
printtime