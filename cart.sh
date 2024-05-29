script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[31m >>>>>>> install nodejs <<<<<<< \e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y

echo -e "\e[31m >>>>>>>create /app <<<<<< \e[0m"
useradd ${username}
rm -rf /app # bcz re-run of code some time through error
mkdir /app

echo -e "\e[31m >>>>>>>downlaod catalogue<<<<<<< \e[0m"
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app

echo -e "\e[31m >>>>>>>unzip catalogue<<<<<<< \e[0m"
unzip /tmp/cart.zip

echo -e "\e[32m >>>>>>>library install<<<<<<< \e[0m"
cd /app
npm install

echo -e "\e[32m >>>>>>> install systemd<<<<<<< \e[0m"
cp $script_path/cart.systemd  /etc/systemd/system/cart.service
systemctl daemon-reload
systemctl enable cart
systemctl restart cart



