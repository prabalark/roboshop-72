script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysqlpassword=$1

echo -e "\e[32m >>>>>>>disable mysql module<<<<<<<<< \e[0m"
dnf module disable mysql -y

echo -e "\e[32m >>>>>>>cp mysql repo<<<<<<<<< \e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[32m >>>>>>>install mysql <<<<<<<<< \e[0m"
dnf install mysql-community-server -y
systemctl enable mysqld
systemctl restart mysqld

echo -e "\e[32m >>>>>>>user creation mysql <<<<<<<<< \e[0m"
mysql_secure_installation --set-root-pass ${mysqlpassword}