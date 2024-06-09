script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component_dis=dispatch

func_discp(){

echo -e " \e[32m >>>>> install golang <<<<< \e[0m "
dnf install golang -y &>>${log_path}
func_exit $?

echo -e " \e[32m >>>>> useradd app <<<<< \e[0m "
useradd ${username} &>>${log_path}
func_exit $?

echo -e " \e[32m >>>>> downlaod app <<<<< \e[0m "
mkdir /app &>>${log_path}
func_exit $?
curl -L -o /tmp/$component_dis.zip https://roboshop-artifacts.s3.amazonaws.com/$component_dis.zip &>>${log_path}
func_exit $?

echo -e " \e[32m >>>>> unzip app <<<<< \e[0m "
cd /app &>>${log_path}
unzip /tmp/$component_dis.zip &>>${log_path}
func_exit $?

echo -e " \e[32m >>>>> install library <<<<< \e[0m "
cd /app &>>${log_path}
go mod init dispatch &>>${log_path}
func_exit $?
go get &>>${log_path}
func_exit $?
go build &>>${log_path}
func_exit $?

echo -e " \e[32m >>>>> install systemd <<<<< \e[0m "
cp ${script_path}/$component_dis.systemd  /etc/systemd/system/$component_dis.service &>>${log_path}
func_exit $?

echo -e " \e[32m >>>>> start  $component_dis <<<<< \e[0m "
systemctl daemon-reload &>>${log_path}
func_exit $?
systemctl enable $component_dis &>>${log_path}
systemctl restart $component_dis &>>${log_path}
func_exit $?
}

func_discp


