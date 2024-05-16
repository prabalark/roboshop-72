echo -e "\e[32m  >>>>>>>>>> install python <<<<<<<<< \e[0m"
dnf install python36 gcc python3-devel -y

echo -e "\e[32m  >>>>>>>>>> download app <<<<<<<< \e[0m"
useradd roboshop
mkdir /app
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip

echo -e "\e[32m  >>>>>>>>>> unzip app <<<<<<<< \e[0m"
cd /app
unzip /tmp/payment.zip

echo -e "\e[32m  >>>>>>>>>> install library <<<<<<<< \e[0m"
cd /app
pip3.6 install -r requirements.txt

echo -e "\e[32m  >>>>>>>>>> install systemd <<<<<<<< \e[0m"
cp /home/centos/roboshop-72/payment.systemd  /etc/systemd/system/payment.service
systemctl daemon-reload
systemctl enable payment
systemctl restart payment
