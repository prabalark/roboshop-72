script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=user
func_nodejs

echo -e "\e[32m >>>>>>> copy mongodb repo <<<<<<< \e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m >>>>>>> install mongodb client <<<<<< \e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[32m >>>>>>> load schema <<<<<< \e[0m"
mongo --host mongodb.devops72bat.online </app/schema/${component}.js


