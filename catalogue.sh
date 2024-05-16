echo -e "\e[31m >>>>>>> install nodejs <<<<<<< \e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y

echo -e "\e[31m >>>>>>>un-zip catalogue<<<<<<< \e[0m"
useradd roboshop
rm -rf /app # bcz re-run of code some time through error
mkdir /app

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip

echo -e "\e[31m >>>>>>>library install<<<<<<< \e[0m"
cd /app
npm install

echo -e "\e[31m >>>>>>> install systemd<<<<<<< \e[0m"
cp /home/centos/roboshop-72/catalogue.systemd /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[31m >>>>>>> copy mongodb repo <<<<<<< \e[0m"
cp /home/centos/roboshop-72/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m >>>>>>> install mongodb client <<<<<<< \e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[31m >>>>>>> load schema <<<<<< \e[0m"
mongo --host mangodb.devops72bat.online </app/schema/catalogue.js


