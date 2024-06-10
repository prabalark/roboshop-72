script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component_dis=dispatch

func_discp(){

print_head   "install golang"   
dnf install golang -y &>>${log_path}
func_exit $?

print_head   "useradd app"   
useradd ${username} &>>${log_path}
func_exit $?

print_head   "downlaod app"   
mkdir /app &>>${log_path}
func_exit $?
curl -L -o /tmp/$component_dis.zip https://roboshop-artifacts.s3.amazonaws.com/$component_dis.zip &>>${log_path}
func_exit $?

print_head   "unzip app"   
cd /app &>>${log_path}
unzip /tmp/$component_dis.zip &>>${log_path}
func_exit $?

print_head   "install library"   
cd /app &>>${log_path}
go mod init dispatch &>>${log_path}
func_exit $?
go get &>>${log_path}
func_exit $?
go build &>>${log_path}
func_exit $?

print_head   "install systemd"   
cp ${script_path}/$component_dis.systemd  /etc/systemd/system/$component_dis.service &>>${log_path}
func_exit $?

print_head   "start  $component_dis"   
systemctl daemon-reload &>>${log_path}
func_exit $?
systemctl enable $component_dis &>>${log_path}
systemctl restart $component_dis &>>${log_path}
func_exit $?
}

func_discp


