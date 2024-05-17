echo -e " \e[32m >>>>> install golang <<<<< \e[0m "
dnf install golang -y

echo -e " \e[32m >>>>> useradd app <<<<< \e[0m "
useradd roboshop

echo -e " \e[32m >>>>> downlaod app <<<<< \e[0m "
mkdir /app
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip

echo -e " \e[32m >>>>> unzip app <<<<< \e[0m "
cd /app
unzip /tmp/dispatch.zip

echo -e " \e[32m >>>>> install library <<<<< \e[0m "
cd /app
go mod init dispatch
go get
go build

echo -e " \e[32m >>>>> install systemd <<<<< \e[0m "
cp /home/centos/roboshop-72/dispatch.systemd  /etc/systemd/system/dispatch.service

echo -e " \e[32m >>>>> start  dispatch <<<<< \e[0m "
systemctl daemon-reload
systemctl enable dispatch
systemctl restart dispatch



