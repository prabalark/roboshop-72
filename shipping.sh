script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh # source will get funtion & variable from common.sh
mysqlpassword=$1

component=shipping

 if [ -z "${mysqlpassword}" ]; then
    echo password is not given
    exit
 fi

fun_mysql(){
  print_head  "install mysql"
  dnf install mysql -y &>>${log_path}
  func_exit $?

  #RoboShop@1 --password as input
  print_head  "load schema mysql"
  mysql -h mysql.devops72bat.online -uroot -p${mysqlpassword} < /app/schema/${component}.sql &>>${log_path}
  func_exit $?
}

func_shipping(){
  print_head  "install maven"
  dnf install maven -y &>>${log_path}
  func_exit $?

  func_prereq &>>${log_path} # in ansible also same
  func_exit $?

  print_head  "install library"
  cd /app &>>${log_path}
  mvn clean package &>>${log_path}
  func_exit $?
  mv target/shipping-1.0.jar shipping.jar &>>${log_path}
  func_exit $?

  func_systemd &>>${log_path}
  func_exit $?

  fun_mysql &>>${log_path}
  &>>${log_path}
}

func_shipping