script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitm1_lg_password=$1

if [ -z "${rabbitm1_lg_password}" ]; then
    echo password is not given
    exit
fi

func_rabbitmq() {
echo -e "\e[32m >>>>> download rabbitmq <<<<< \e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log_path}
func_exit $?
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log_path}
func_exit $?

echo -e "\e[32m >>>>> install rabbitmq <<<<< \e[0m"
dnf install rabbitmq-server -y &>>${log_path}
func_exit $?

echo -e "\e[32m >>>>> start rabbitmq <<<<< \e[0m"
systemctl enable rabbitmq-server &>>${log_path}
systemctl restart rabbitmq-server &>>${log_path}
func_exit $?

#roboshop123
echo -e "\e[32m >>>>> adduser rabbitmq <<<<< \e[0m"
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