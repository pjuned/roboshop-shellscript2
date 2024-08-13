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

dnf install nginx -y &>> $LOGFILE

VALIDATE $? "Installing nginx"

systemctl enable nginx &>> $LOGFILE

VALIDATE $? "enabling Nginx"

systemctl start nginx &>> $LOGFILE

VALIDATE $? "Starting Nginx"

rm -rf /usr/share/nginx/html/* &>> $LOGFILE

VALIDATE $? "Removing default content is"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE

VALIDATE $? "Downloading frontend content"

cd /usr/share/nginx/html 

unzip -o /tmp/web.zip &>> $LOGFILE

VALIDATE $? "Unzipping web content"

cp /home/centos/roboshop-shellscript2/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $LOGFILE


VALIDATE $? "Copying roboshop.conf to local home folder"

systemctl restart nginx &>> $LOGFILE

VALIDATE $? "Restarting Nginx "