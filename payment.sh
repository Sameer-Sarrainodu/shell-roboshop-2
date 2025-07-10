#!/bin/bash

source ./common.sh
checkroot
app_setup

dnf install python3 gcc python3-devel -y &>>$logfile
mv "$scriptdir/payment.ini" . |tee -a "copying payment.ini"
pip3 install -r requirements.txt &>>$logfile
system_setup
printtime
