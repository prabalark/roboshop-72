echo  -e "\e[32m >>>>>>>>>Copy-repo<<<<<<<<<<<< \e [0m"
cp /home/centos/roboshop-72/mongo.repo /etc/yum.repos.d/mongo.repo &>>${log_path}
func_exit $?

echo  -e "\e[32m >>>>>>>>>install mongo <<<<<<<<<<<< \e [0m"
dnf install mongodb-org -y &>>${log_path}
func_exit $?

echo  -e "\e[32m >>>>>>>>>update listen <<<<<<<<<<<< \e [0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>${log_path}
func_exit $?

echo  -e "\e[32m >>>>>>>>>start mongodb <<<<<<<<<<<< \e [0m"
systemctl enable mongod &>>${log_path}
func_exit $?
systemctl restart mongod &>>${log_path}
func_exit $?
#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf