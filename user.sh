script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=user

func_nodejs(){
print_head "install nodejs"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y

print_head "create /app"
useradd ${username}
rm -rf /app # bcz re-run of code some time through error
mkdir /app

print_head "downlaod catalogue"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

print_head "unzip catalogue"
unzip /tmp/${component}.zip

print_head "library install"
cd /app
npm install

print_head "install systemd"
cp $script_path/${component}.systemd  /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
}

func_nodejs

echo -e "\e[32m >>>>>>> copy mongodb repo <<<<<<< \e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m >>>>>>> install mongodb client <<<<<< \e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[32m >>>>>>> load schema <<<<<< \e[0m"
mongo --host mongodb.devops72bat.online </app/schema/${component}.js


