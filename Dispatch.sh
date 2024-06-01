script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component_dis=dispatch

func_discp(){

echo -e " \e[32m >>>>> install golang <<<<< \e[0m "
dnf install golang -y

echo -e " \e[32m >>>>> useradd app <<<<< \e[0m "
useradd ${username}

echo -e " \e[32m >>>>> downlaod app <<<<< \e[0m "
mkdir /app
curl -L -o /tmp/$component_dis.zip https://roboshop-artifacts.s3.amazonaws.com/$component_dis.zip

echo -e " \e[32m >>>>> unzip app <<<<< \e[0m "
cd /app
unzip /tmp/$component_dis.zip

echo -e " \e[32m >>>>> install library <<<<< \e[0m "
cd /app
go mod init dispatch
go get
go build

echo -e " \e[32m >>>>> install systemd <<<<< \e[0m "
cp ${script_path}/$component_dis.systemd  /etc/systemd/system/$component_dis.service

echo -e " \e[32m >>>>> start  $component_dis <<<<< \e[0m "
systemctl daemon-reload
systemctl enable $component_dis
systemctl restart $component_dis
}

func_discp


