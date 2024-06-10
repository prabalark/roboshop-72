source common.sh


func_mongodb() { 
print_head "Copy-repo"
cp /home/centos/roboshop-72/mongo.repo /etc/yum.repos.d/mongo.repo &>>${log_path}
func_exit $?

print_head "install mongo" 
dnf install mongodb-org -y &>>${log_path}
func_exit $?

print_head "update listen" 
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>${log_path}
func_exit $?

print_head "start mongodb" 
systemctl enable mongod &>>${log_path}
func_exit $?
systemctl restart mongod &>>${log_path}
func_exit $?

#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf
}

func_mongodb