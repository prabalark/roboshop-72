script=$(realpath "$0")
script_path=$(dirname "$script")
source  ${script_path}/common.sh

echo   ${script_path}

exit

echo -e "\e[31m >>>>>>> install nodejs <<<<<<< \e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y

echo -e "\e[31m >>>>>>>create /app <<<<<< \e[0m"
useradd ${username}
rm -rf /app # bcz re-run of code some time through error
mkdir /app

echo -e "\e[31m >>>>>>>downlaod catalogue<<<<<<< \e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[31m >>>>>>>unzip catalogue<<<<<<< \e[0m"
unzip /tmp/catalogue.zip

echo -e "\e[32m >>>>>>>library install<<<<<<< \e[0m"
cd /app
npm install

echo -e "\e[32m >>>>>>> install systemd<<<<<<< \e[0m"
cp $script_path/catalogue.systemd  /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[32m >>>>>>> copy mongodb repo <<<<<<< \e[0m"
cp /home/centos/roboshop-72/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m >>>>>>> install mongodb client <<<<<<< \e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[32m >>>>>>> load schema <<<<<< \e[0m"
mongo --host mongodb.devops72bat.online </app/schema/catalogue.js


