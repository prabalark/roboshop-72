cp /home/centos/roboshop-72/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-org -y
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf
systemctl enable mongod
systemctl start mongod
#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf