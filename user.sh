echo -e "\e[31m >>>>>>> install nodejs <<<<<<< \e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y

echo -e "\e[31m >>>>>>>create /app <<<<<< \e[0m"
useradd roboshop
rm -rf /app # bcz re-run of code some time through error
mkdir /app

echo -e "\e[31m >>>>>>>downlaod catalogue<<<<<<< \e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app

echo -e "\e[31m >>>>>>>unzip catalogue<<<<<<< \e[0m"
unzip /tmp/user.zip

echo -e "\e[32m >>>>>>>library install<<<<<<< \e[0m"
cd /app
npm install

echo -e "\e[32m >>>>>>> install systemd<<<<<<< \e[0m"
cp /home/centos/roboshop-72/user.systemd  /etc/systemd/system/user.service
systemctl daemon-reload
systemctl enable user
systemctl restart user

echo -e "\e[32m >>>>>>> copy mongodb repo <<<<<<< \e[0m"
cp /home/centos/roboshop-72/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m >>>>>>> install mongodb client <<<<<<< \e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[32m >>>>>>> load schema <<<<<< \e[0m"
mongo --host mongodb.devops72bat.online </app/schema/user.js


