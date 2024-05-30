username=roboshop

func_nodejs(){
echo -e "\e[31m >>>>>>> install nodejs <<<<<<< \e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y

echo -e "\e[31m >>>>>>>create /app <<<<<< \e[0m"
useradd ${username}
rm -rf /app # bcz re-run of code some time through error
mkdir /app

echo -e "\e[31m >>>>>>>downlaod catalogue<<<<<<< \e[0m"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[31m >>>>>>>unzip catalogue<<<<<<< \e[0m"
unzip /tmp/${component}.zip

echo -e "\e[32m >>>>>>>library install<<<<<<< \e[0m"
cd /app
npm install

echo -e "\e[32m >>>>>>> install systemd<<<<<<< \e[0m"
cp $script_path/${component}.systemd  /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
}