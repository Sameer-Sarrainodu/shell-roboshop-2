#!/bin/bash
starttime=$(date +%s)
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
nc="\e[0m"
logsdir="/var/log/shellscript-logs"
scriptname=$(basename "$0" | cut -d "." -f1)
logfile="$logsdir/$scriptname.log"
scriptdir=$PWD

mkdir -p $logsdir
echo "script executed at $(date)"|tee -a $logfile

nodejs_setup(){
dnf module disable nodejs -y &>>$logfile
validate $? "disabling nodejs"

dnf module enable nodejs:20 -y &>>$logfile
validate $? "enabling nodejs"

dnf install nodejs -y &>>$logfile
validate $? "installing nodejs"

npm install &>>$logfile
validate $? "installing resources"
}

system_setup(){
cp $scriptdir/$app_name.service /etc/systemd/system/$app_name.service &>>$logfile
validate $? "copying $app_name service"

systemctl daemon-reload &>>$logfile
systemctl enable $app_name  &>>$logfile
systemctl start $app_name
validate $? "Starting $app_name"
}




app_setup(){
id roboshop &>>$logfile
if [ $? -ne 0 ]
then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$logfile
    validate $? "Creating roboshop system user"
else
    echo -e "System user roboshop already created ... $yellow SKIPPING $nc"
fi

mkdir -p /app &>>$logfile
validate $? "making /app dir"
rm -rf /app/*
curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$logfile
validate $? "Downloading $app_name"

cd /app 
unzip /tmp/$app_name.zip &>>$logfile
validate $? "unzipping $app_name"
}




checkroot(){
userid=$(id -u)
if [ $userid -ne 0 ]
then
    echo -e "$red Error:you are not a sudo $nc"|tee -a $logfile
    sudo -i
    exit 1
else
    echo -e "$green success$nc: you are sudo"|tee -a $logfile
fi
}



validate(){
    if [ $1 -ne 0 ]
    then
        echo -e "$red error:$2 is not installed $nc" |tee -a $logfile
        exit 1
    else
        echo -e "$green success:$nc installed $2 successfully"|tee -a $logfile
    fi

}



printtime(){
endtime=$(date +%s)
totaltime=$((endtime-starttime))
echo -e "script executed successfully,$yellow time taken: $totaltime seconds $nc"
}
