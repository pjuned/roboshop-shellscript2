#!/bin/bash

# Variables
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGDB_HOST=mongodb.daws76s.online
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$(basename $0)-$TIMESTAMP.log"

# Logging script start
echo "Script started executing at $TIMESTAMP" &>> $LOGFILE

# Function to validate commands
VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

# Check if the script is run as root
if [ $ID -ne 0 ]; then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
else
    echo "You are root user"
fi

# Install nginx
dnf install nginx -y &>> $LOGFILE
VALIDATE $? "Installing nginx"

# Enable and start nginx
systemctl enable nginx &>> $LOGFILE
VALIDATE $? "Enable nginx"

systemctl start nginx &>> $LOGFILE
VALIDATE $? "Starting Nginx"

# Remove default website content
rm -rf /usr/share/nginx/html/* &>> $LOGFILE
VALIDATE $? "Removed default website"

# Download web application
curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE
VALIDATE $? "Downloaded web application"

# Unzip web application
cd /usr/share/nginx/html &>> $LOGFILE
VALIDATE $? "Changed directory to nginx html"

unzip -o /tmp/web.zip &>> $LOGFILE
VALIDATE $? "Unzipped web application"

# Copy nginx configuration
cp /home/centos/roboshop-shellscript2/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $LOGFILE
VALIDATE $? "Copied roboshop reverse proxy config"

# Restart nginx
systemctl restart nginx &>> $LOGFILE
VALIDATE $? "Restarted nginx"
