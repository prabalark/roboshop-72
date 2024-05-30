script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[32m  >>>>>>>>>> install python <<<<<<<<< \e[0m"
dnf install python36 gcc python3-devel -y

echo -e "\e[32m  >>>>>>>>>> useradd app <<<<<<<< \e[0m"
useradd ${username}

echo -e "\e[32m  >>>>>>>>>> create app <<<<<<<< \e[0m"
rm -rf /app
mkdir /app

echo -e "\e[32m  >>>>>>>>>> download payment.zip <<<<<<<< \e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip

echo -e "\e[32m  >>>>>>>>>> unzip app <<<<<<<< \e[0m"
cd /app
unzip /tmp/payment.zip

echo -e "\e[32m  >>>>>>>>>> install library <<<<<<<< \e[0m"
cd /app
pip3.6 install -r requirements.txt

echo -e "\e[32m  >>>>>>>>>> install systemd <<<<<<<< \e[0m"
cp ${script_path}/payment.systemd  /etc/systemd/system/payment.service

echo -e "\e[32m  >>>>>>>>>> start payment systemd <<<<<<<< \e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment
