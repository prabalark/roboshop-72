script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitm1_lg_password=$1

echo -e "\e[32m >>>>> download rabbitmq <<<<< \e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[32m >>>>> install rabbitmq <<<<< \e[0m"
dnf install rabbitmq-server -y

echo -e "\e[32m >>>>> start rabbitmq <<<<< \e[0m"
systemctl restart rabbitmq-server

#roboshop123
echo -e "\e[32m >>>>> adduser rabbitmq <<<<< \e[0m"
rabbitmqctl add_user roboshop ${rabbitm1_lg_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

#print_head "Add Application User"
 # #rabbitmqctl list_users | grep roboshop &>>${LOG}
 # #if [ $? -ne 0 ]; then
 # #  rabbitmqctl add_user roboshop ${roboshop_rabbitmq_password}  &>>${LOG}
 # #fi
 # #status_check