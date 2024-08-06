script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitm1_lg_password=$1

if [ -z "${rabbitm1_lg_password}" ]; then
  echo rabbitm1_lg_password is not given
  exit
fi

component=payment

func_payment(){
print_head  "install python"   
dnf install python36 gcc python3-devel -y &>>${log_path}
func_exit $?

print_head  "useradd app"   
useradd ${username} &>>${log_path}
func_exit $?

print_head  "create app"   
rm -rf /app &>>${log_path}
mkdir /app &>>${log_path}
func_exit $?

print_head  "download ${component}.zip"   
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_path}
func_exit $?

print_head  "unzip app"   
cd /app &>>${log_path}
unzip /tmp/${component}.zip &>>${log_path}
func_exit $?

print_head  "install library"   
cd /app &>>${log_path}
pip3.6 install -r requirements.txt &>>${log_path}
func_exit $?

#roboshop123
print_head  "install systemd"   
sed -i -e "s|rabbitm1_lg_password2|${rabbitm1_lg_password}|" ${script_path}/${component}.systemd &>>${log_path}
  # only if password in systemd we have to do sed
func_exit $?
cp ${script_path}/${component}.systemd  /etc/systemd/system/${component}.service &>>${log_path}

print_head  "start ${component} systemd"   
systemctl daemon-reload  &>>${log_path}
func_exit $?
systemctl enable ${component} &>>${log_path}
systemctl restart ${component} &>>${log_path}
func_exit $?
}

func_payment