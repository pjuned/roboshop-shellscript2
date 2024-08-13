#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
echo "Script started executing at $TIMESTAMP" &>> LOGFILE

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

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> LOGFILE

VALIDATE $? "Copied Mongodb repo"

dnf install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installing MongoDB" &>> $LOGFILE

systemctl enable mongod &>> LOGFILE

VALIDATE $? "Enabling Mongodb"

systemctl start mongod &>> LOGFILE

VALIDATE $? "Starting Mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> LOGFILE

VALIDATE $? "Remote access to mongodb" 

systemctl restart mongod &>> LOGFILE

VALIDATE $? "Restarting Mongodb"