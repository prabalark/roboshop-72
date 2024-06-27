script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitm1_lg_password=$1

if [ -z "${rabbitm1_lg_password}" ]; then
    echo password is not given
    exit
fi

func_rabbitmq() {
print_head "download rabbitmq" 
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log_path}
func_exit $?
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log_path}
func_exit $?

print_head "install rabbitmq" 
dnf install rabbitmq-server -y &>>${log_path}
func_exit $?

print_head "start rabbitmq" 
systemctl enable rabbitmq-server &>>${log_path}
systemctl restart rabbitmq-server &>>${log_path}
func_exit $?

#roboshop123
print_head "adduser rabbitmq" 
rabbitmqctl add_user roboshop ${rabbitm1_lg_password} &>>${log_path}
func_exit $?
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_path}
func_exit $?

 }

func_rabbitmq

#print_head "Add Application User"
 # #rabbitmqctl list_users | grep roboshop &>>${LOG}
 # #if [ $? -ne 0 ]; then
 # #  rabbitmqctl add_user roboshop ${roboshop_rabbitmq_password}  &>>${LOG}
 # #fi
 # #status_check