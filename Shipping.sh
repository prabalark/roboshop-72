script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysqlpassword=$1

if [ -z "${mysqlpassword}" ]; then
    echo password is not given
    exit
fi

component_shp=shipping

func_shipping(){
echo -e " \e[31m >>>>> install maven <<<<< \e[0m"
dnf install maven -y &>>${log_path}
func_exit $?

echo -e "\e[31m >>>>>>>create /app <<<<<< \e[0m"
useradd ${username} &>>${log_path}
func_exit $?
rm -rf /app  &>>${log_path}
func_exit $? # bcz re-run of code some time through error
mkdir /app  &>>${log_path}
func_exit $?

echo -e " \e[31m >>>>> downlaod ${component_shp} <<<<< \e[0m"
curl -L -o /tmp/${component_shp}.zip https://roboshop-artifacts.s3.amazonaws.com/${component_shp}.zip &>>${log_path}
func_exit $?
cd /app &>>${log_path}

echo -e " \e[31m >>>>> unzip ${component_shp} <<<<< \e[0m"
unzip /tmp/${component_shp}.zip &>>${log_path}
func_exit $?

echo -e " \e[31m >>>>> install library <<<<< \e[0m"
cd /app &>>${log_path}
mvn clean package &>>${log_path}
func_exit $?
mv target/shipping-1.0.jar shipping.jar &>>${log_path}
func_exit $?

echo -e " \e[31m >>>>> install mysql <<<<< \e[0m"
dnf install mysql -y &>>${log_path}
func_exit $?

#RoboShop@1 --password as input
echo -e " \e[31m >>>>> load schema mysql <<<<< \e[0m"
mysql -h mysql.devops72bat.online -uroot -p${mysqlpassword} < /app/schema/${component_shp}.sql &>>${log_path}
func_exit $?

echo -e " \e[31m >>>>> install systemd <<<<< \e[0m"
cp $script_path/${component_shp}.systemd /etc/systemd/system/${component_shp}.service &>>${log_path}
func_exit $?

echo -e " \e[31m >>>>> start mysql <<<<< \e[0m"
systemctl daemon-reload &>>${log_path}
func_exit $?
systemctl enable ${component_shp}  &>>${log_path}
systemctl restart ${component_shp} &>>${log_path}
func_exit $?
}

func_shipping