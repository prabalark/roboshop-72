script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysqlpassword=$1

 if [ -z "${mysqlpassword}" ]; then
    echo password is not given
    exit
 fi

func_mysql() {
print_head "disable mysql module" 
dnf module disable mysql -y &>>${log_path}
func_exit $?

print_head  "cp mysql repo<"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_path}
func_exit $?

print_head  "install mysql"  
dnf install mysql-community-server -y &>>${log_path}
func_exit $?
systemctl enable mysqld &>>${log_path}
func_exit $?
systemctl restart mysqld &>>${log_path}
func_exit $?

#RoboShop@1
print_head  "user creation mysql"  
mysql_secure_installation --set-root-pass ${mysqlpassword} &>>${log_path}
func_exit $?
}

func_mysql