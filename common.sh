username=roboshop
log_path=/tmp/roboshop.log
rm -f ${log_path}

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

func_exit(){
  if [ $1 -eq 0 ]; then
     echo -e "\e[32m >>>>>>>>>> success <<<<<<<<<<<< \e[0m"
  else
     echo -e "\e[31m >>>>>>>>>> failure <<<<<<<<<<<< \e[0m"
     exit
     echo -e "\e[31m >>>>>>>>>> refer the log file '/tmp/roboshop.log' <<<<<<<<<<<< \e[0m"
  fi
}

print_head() {
  echo -e "\e[31m >>>>>>> $1 <<<<<<< \e[0m"
  echo -e "\e[31m >>>>>>> $1 <<<<<<< \e[0m" &>>${log_path}
              }

func_nodejs(){
  # dnf module list -> to see all
print_head "install nodejs"
dnf module disable nodejs -y &>>${log_path}
dnf module enable nodejs:18 -y &>>${log_path}

dnf install nodejs -y &>>${log_path}
func_exit $?

print_head "create /app"
id ${username} &>>${log_path}
if [ $? -ne 0 ]; then
 useradd ${username} &>>${log_path}
fi
func_exit $?

rm -rf /app # bcz re-run of code some time through error
mkdir /app &>>${log_path}
func_exit $?

print_head "downlaod ${component}"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_path}
func_exit $?
print_head "unzip ${component}"
cd /app &>>${log_path}
unzip /tmp/${component}.zip &>>${log_path}
func_exit $?

print_head "library install"
cd /app &>>${log_path}
npm install &>>${log_path}
func_exit $?


print_head "install systemd"
cp $script_path/${component}.systemd  /etc/systemd/system/${component}.service &>>${log_path}
func_exit $?

systemctl daemon-reload &>>${log_path}
systemctl enable ${component} &>>${log_path}
systemctl restart ${component} &>>${log_path}
func_exit $?

schema_laod_nodejs &>>${log_path}
func_exit $?
}