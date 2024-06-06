username=roboshop

schema_laod_nodejs(){
  if [ "$schma_check" == "mongodb" ]; then  #double quotes compuslory
echo -e "\e[32m >>>>>>> copy mongodb repo <<<<<<< \e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m >>>>>>> install mongodb client <<<<<<< \e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[32m >>>>>>> load schema <<<<<< \e[0m"
mongo --host mongodb.devops72bat.online </app/schema/${component}.js
fi
}

print_head() {
  echo -e "\e[31m >>>>>>> $1 <<<<<<< \e[0m"
              }

func_nodejs(){
print_head "install nodejs"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
if [ $? -eq 0 ]; then
   echo -e "\e[32m >>>>>>>>>> success <<<<<<<<<<<< \e[0m"
else
   echo -e "\e[31m >>>>>>>>>> failure <<<<<<<<<<<< \e[0m"
  exit
fi

print_head "create /app"
useradd ${username}
if [ $? -eq 0 ]; then
   echo -e "\e[32m >>>>>>>>>> success <<<<<<<<<<<< \e[0m"
else
   echo -e "\e[31m >>>>>>>>>> failure <<<<<<<<<<<< \e[0m"
  exit
fi
rm -rf /app # bcz re-run of code some time through error
mkdir /app
if [ $? -eq 0 ]; then
   echo -e "\e[32m >>>>>>>>>> success <<<<<<<<<<<< \e[0m"
else
   echo -e "\e[31m >>>>>>>>>> failure <<<<<<<<<<<< \e[0m"
   exit
fi
print_head "downlaod ${component}"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

print_head "unzip ${component}"
cd /app
unzip /tmp/${component}.zip

print_head "library install"
cd /app
npm install

print_head "install systemd"
cp $script_path/${component}.systemd  /etc/systemd/system/${component}.service
systemctl daemon-reload
systemctl enable ${component}
systemctl restart ${component}
schema_laod_nodejs
}