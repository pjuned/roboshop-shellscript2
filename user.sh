#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
mongodb_host=mongodb.devopsju.online

TIMESTAMP=$(date +%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
echo "Script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){

if [ $1 -ne 0 ]
then 
    echo -e "$2  is $R failed $N"
    exit 1
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

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "disable default nodejs"

dnf module enable nodejs:18 -y

VALIDATE $? "enabling nodejs:18"

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Installing NOdejs"

id roboshop
if [$? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "Roboshop user already exists $Y skipping $N"
fi

useradd roboshop &>> $LOGFILE

mkdir -p /app

VALIDATE $? "creating App directory"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip

VALIDATE $? "Downloading user App"

cd /app 

unzip -o /tmp/user.zip &>> $LOGFILE

VALIDATE $? "Unzipping "


npm install  &>> $LOGFILE

VALIDATE $? "Installing dependencies"

cp /home/centos/roboshop-shellscript2/user.service /etc/systemd/system/user.service

VALIDATE $? "Copying user.service"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "User daemon"


systemctl enable user &>> $LOGFILE

VALIDATE $? "Enabling User.service"


systemctl start user &>> $LOGFILE

VALIDATE $? "Starting user.service"

cp /home/centos/roboshop-shellscript2/mongo.repo /etc/yum.repos.d/mongo.repo


dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "installing mongodb client"

mongo --host $mongodb_host </app/schema/user.js &>> $LOGFILE

VALIDATE $? "Loading user data into Mongodb"

