
component_shp=shipping

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

print_head  "downlaod ${component_shp}" 
curl -L -o /tmp/${component_shp}.zip https://roboshop-artifacts.s3.amazonaws.com/${component_shp}.zip &>>${log_path}
func_exit $?
cd /app &>>${log_path}

print_head  "unzip ${component_shp}" 
unzip /tmp/${component_shp}.zip &>>${log_path}
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
mysql -h mysql.devops72bat.online -uroot -p${mysqlpassword} < /app/schema/${component_shp}.sql &>>${log_path}
func_exit $?

print_head  "install systemd" 
cp $script_path/${component_shp}.systemd /etc/systemd/system/${component_shp}.service &>>${log_path}
func_exit $?

print_head  "start mysql" 
systemctl daemon-reload &>>${log_path}
func_exit $?
systemctl enable ${component_shp}  &>>${log_path}
systemctl restart ${component_shp} &>>${log_path}
func_exit $?
}

func_shipping