script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysqlpassword=$1

echo -e " \e[31m >>>>> install maven <<<<< \e[0m"
dnf install maven -y

echo -e "\e[31m >>>>>>>create /app <<<<<< \e[0m"
useradd ${username}
rm -rf /app # bcz re-run of code some time through error
mkdir /app

echo -e " \e[31m >>>>> downlaod shipping <<<<< \e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app

echo -e " \e[31m >>>>> unzip shipping <<<<< \e[0m"
unzip /tmp/shipping.zip

echo -e " \e[31m >>>>> install library <<<<< \e[0m"
cd /app
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e " \e[31m >>>>> install mysql <<<<< \e[0m"
dnf install mysql -y

#RoboShop@1 --password as input
echo -e " \e[31m >>>>> load schema mysql <<<<< \e[0m"
mysql -h mysql.devops72bat.online -uroot -p$mysqlpassword < /app/schema/shipping.sql

echo -e " \e[31m >>>>> install systemd <<<<< \e[0m"
cp $script_path/shipping.systemd /etc/systemd/system/shipping.service

echo -e " \e[31m >>>>> start mysql <<<<< \e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping