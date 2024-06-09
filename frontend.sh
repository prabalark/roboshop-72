source common.sh

echo -e "\e[31m >>>>>>> install nginx <<<<<<< \e[0m"
dnf install nginx -y &>>${log_path}
func_exit $?
systemctl enable nginx &>>${log_path}
systemctl start nginx &>>${log_path}
func_exit $?

echo -e "\e[31m >>>>>>> unzip frontend<<<<<<< \e[0m"
rm -rf /usr/share/nginx/html/* &>>${log_path}
func_exit $?
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_path}
func_exit $?
cd /usr/share/nginx/html &>>${log_path}
func_exit $?
unzip /tmp/frontend.zip &>>${log_path}
func_exit $?

echo -e "\e[31m >>>>>>> reverse-proxy<<<<<<< \e[0m"
cp /home/centos/roboshop-72/reverse-proxy-ver-1  /etc/nginx/default.d/roboshop.conf &>>${log_path}
func_exit $?
systemctl enable nginx &>>${log_path}
systemctl restart nginx &>>${log_path}
func_exit $?