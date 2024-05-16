echo -e " \e[31m >>>>> install maven <<<<< \e[0m"
dnf install maven -y

echo -e " \e[31m >>>>> downlaod maven <<<<< \e[0m"
useradd roboshop
mkdir /app
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

echo -e " \e[31m >>>>> unzip shipping <<<<< \e[0m"
cd /app
unzip /tmp/shipping.zip

echo -e " \e[31m >>>>> install library <<<<< \e[0m"
cd /app
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e " \e[31m >>>>> install systemd <<<<< \e[0m"
cp /home/centos/roboshop-72/shipping.systemd /etc/systemd/system/shipping.service
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping

echo -e " \e[31m >>>>> install mysql <<<<< \e[0m"
dnf install mysql -y
mysql -h mysql.devops72bat.online -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e " \e[31m >>>>> start mysql <<<<< \e[0m"
systemctl restart shipping