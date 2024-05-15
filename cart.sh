dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
useradd roboshop
mkdir /app
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app
unzip /tmp/cart.zip
cd /app
npm install
cp cart.systemd /etc/systemd/system/cart.service
systemctl daemon-reload
systemctl enable cart
systemctl start cart
cp mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-org-shell -y
mongo --host mangodb.devops72bat.online </app/schema/cart.js
