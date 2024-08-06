script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysqlpassword=$1

 if [ -z "${mysqlpassword}" ]; then
    echo password is not given
    exit
 fi

component=shipping

func_shipping(){
print_head  "install maven" 
dnf install maven -y &>>${log_path}
func_exit $?

print_head "create /app"
id ${username} &>>${log_path}
if [ $? -ne 0 ]; then
 useradd ${username} &>>${log_path}
fi
func_exit $?

rm -rf /app  &>>${log_path}
func_exit $? # bcz re-run of code some time through error
mkdir /app  &>>${log_path}
func_exit $?

print_head  "downlaod ${component}" 
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_path}
func_exit $?
cd /app &>>${log_path}

print_head  "unzip ${component}" 
unzip /tmp/${component}.zip &>>${log_path}
func_exit $?

print_head  "install library" 
cd /app &>>${log_path}
mvn clean package &>>${log_path}
func_exit $?
mv target/shipping-1.0.jar shipping.jar &>>${log_path}
func_exit $?

print_head  "install mysql" 
dnf install mysql -y &>>${log_path}
func_exit $?

#RoboShop@1 --password as input
print_head  "load schema mysql" 
mysql -h mysql.devops72bat.online -uroot -p${mysqlpassword} < /app/schema/${component}.sql &>>${log_path}
func_exit $?

func_systemd &>>${log_path}
func_exit $?
}

func_shipping