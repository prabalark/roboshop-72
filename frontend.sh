echo -e "\e[31m >>>>>>> install nginx <<<<<<< \e[0m"
dnf install nginx -y
systemctl enable nginx
systemctl start nginx

echo -e "\e[31m >>>>>>> unzip frontend<<<<<<< \e[0m"
rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[31m >>>>>>> reverse-proxy<<<<<<< \e[0m"
cp /home/centos/roboshop-72/reverse-proxy-ver-1  /etc/nginx/default.d/roboshop.conf
systemctl enable nginx
systemctl restart nginx