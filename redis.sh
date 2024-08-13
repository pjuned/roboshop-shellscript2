ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
#mongodb_host=mongodb.devopsju.online

TIMESTAMP=$(date +%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
#exec &>LOGFILE
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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE

VALIDATE $? "installing redis repo"

dnf module enable redis:remi-6.2 -y &>> $LOGFILE

VALIDATE $? "Enabling redis"

dnf install redis -y &>> $LOGFILE

VALIDATE $? "installing redis"

sed -i 's/127.0.0.0/0.0.0.0/g' /etc/redis.conf &>> $LOGFILE

VALIDATE $? "Allowing remote connections"

systemctl enable redis &>> $LOGFILE

VALIDATE $? "Enabling redis service"

systemctl start redis &>> $LOGFILE

VALIDATE $? "Starting redis"