#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
mongodb_host  mongodb.devopsju.online

TIMESTAMP=$(date +%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
echo "Script started executing at $TIMESTAMP" &>> LOGFILE

VALIDATE(){

if [ $1 -ne 0 ]
then 
    echo -e "$2  is $R failed $N"
else
    echo -e "$2  is $G success $N"
fi

}

if [ $ID -ne 0 ]

then
 echo "you are not root user"
 exit 1
else
    echo " you are root user"
fi

dnf module disable nodejs -y &>> LOGFILE

VALIDATE $? "disable default nodejs"

dnf module enable nodejs:18 -y

VALIDATE $? "enabling nodejs:18"

dnf install nodejs -y &>> LOGFILE

VALIDATE $? "Installing NOdejs"

useradd roboshop &>> LOGFILE

mkdir /app

VALIDATE $? "creating App directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

VALIDATE $? "Downloading catalogue App"

cd /app

unzip /tmp/catalogue.zip

VALIDATE $? "Unzipping catalogue App"

npm install 

VALIDATE $? "Installing depenencies" 

cp /home/centos/roboshop-shellscript2/catalogue.service /etc/systemd/system/catalogue.service &>> LOGFILE

VALIDATE $? "Copying catalogue.service file"

systemctl daemon-reload

VALIDATE $? "daemon reloaded"

systemctl enable catalogue

VALIDATE $? "enabling catalogue"

systemctl start catalogue

VALIDATE $? "Starting catlaogue"

cp /home/centos/roboshop-shellscript2/mongo.repo /etc/yum.repos.d/mongo.repo &>> LOGFILE

VALIDATE $? "Copying Mongo repo"

dnf install mongodb-org-shell -y &>> LOGFILE

VALIDATE $? "installing mongodb client"

mongo --host $mongodb_host </app/schema/catalogue.js

VALIDATE $? "loading catalogue data into mongodb"
