username=roboshop

print_head() {
  echo -e "\e[31m >>>>>>> $1 <<<<<<< \e[0m"
              }

func_nodejs(){
print_head "install nodejs"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y

print_head "create /app"
useradd ${username}
rm -rf /app # bcz re-run of code some time through error
mkdir /app

print_head "downlaod catalogue"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
cd /app

print_head "unzip catalogue"
unzip /tmp/${component}.zip

print_head "library install"
cd /app
npm install

print_head "install systemd"
cp $script_path/${component}.systemd  /etc/systemd/system/${component}.service
systemctl daemon-reload
systemctl enable ${component}
systemctl restart ${component}
}