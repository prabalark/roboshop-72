script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysqlpassword=$1

 if [ -z "${mysqlpassword}" ]; then
    echo password is not given
    exit
 fi

echo -e "\e[32m >>>>>>>disable mysql module<<<<<<<<< \e[0m"
dnf module disable mysql -y &>>${log_path}
func_exit $?

echo -e "\e[32m >>>>>>>cp mysql repo<<<<<<<<< \e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_path}
func_exit $?

echo -e "\e[32m >>>>>>>install mysql <<<<<<<<< \e[0m"
dnf install mysql-community-server -y &>>${log_path}
func_exit $?
systemctl enable mysqld &>>${log_path}
func_exit $?
systemctl restart mysqld &>>${log_path}
func_exit $?

#RoboShop@1
echo -e "\e[32m >>>>>>>user creation mysql <<<<<<<<< \e[0m"
mysql_secure_installation --set-root-pass ${mysqlpassword} &>>${log_path}
func_exit $?