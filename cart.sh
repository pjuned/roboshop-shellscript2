#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
#mongodb_host=mongodb.devopsju.online

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

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE

VALIDATE $? "downloading cart App"

cd /app 

unzip -o /tmp/cart.zip &>> $LOGFILE

VALIDATE $? "Unzipping the cart"

npm install &>> $LOGFILE

VALIDATE $? "Installing dependencies"

cp /home/centos/roboshop-shellscript2/cart.service /etc/systemd/system/cart.service &>> $LOGFILE

VALIDATE $? "copying cart.service in home folder"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "Daemon reload"

systemctl enable cart &>> $LOGFILE

VALIDATE $? "Enabling cart"

systemctl start cart &>> $LOGFILE

VALIDATE $? "Starting cart"




