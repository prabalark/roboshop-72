username=roboshop
log_path=/tmp/roboshop.log
rm -f ${log_path}

print_head() {
  echo -e "\e[31m >>>>>>> $1 <<<<<<< \e[0m"
  echo -e "\e[31m >>>>>>> $1 <<<<<<< \e[0m" &>>${log_path}
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

func_prereq(){
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
}

func_systemd(){
  print_head  "install systemd"
  cp $script_path/${component}.systemd /etc/systemd/system/${component}.service &>>${log_path}
  func_exit $?

  print_head  "start systemd"
  systemctl daemon-reload &>>${log_path}
  func_exit $?
  systemctl enable ${component}  &>>${log_path}
  systemctl restart ${component} &>>${log_path}
  func_exit $?
}

schema_laod_nodejs(){
  if [ "$schma_check" == "mongodb" ]; then  #double quotes compuslory
  print_head "copy mongodb repo"
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

  print_head "install mongodb client"
  dnf install mongodb-org-shell -y

  print_head "load schema"
  mongo --host mongodb.devops72bat.online </app/schema/${component}.js
  fi
}

# catalogue,user,cart
func_nodejs(){
  # dnf module list -> to see all
  print_head "install nodejs"
  dnf module disable nodejs -y &>>${log_path}
  dnf module enable nodejs:18 -y &>>${log_path}

  dnf install nodejs -y &>>${log_path}
  func_exit $?

  func_prereq &>>${log_path} # in ansible also same
  func_exit $?

  print_head "library install"
  cd /app &>>${log_path}
  npm install &>>${log_path}
  func_exit $?

  func_systemd &>>${log_path}
  func_exit $?

  schema_laod_nodejs &>>${log_path}
  func_exit $?
}