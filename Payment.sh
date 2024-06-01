script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitm1_lg_password=$1

if [ -z "${rabbitm1_lg_password}" ]; then
  echo rabbitm1_lg_password is not given
  exit
fi

component_pay=payment

func_payment(){
echo -e "\e[32m  >>>>>>>>>> install python <<<<<<<<< \e[0m"
dnf install python36 gcc python3-devel -y

echo -e "\e[32m  >>>>>>>>>> useradd app <<<<<<<< \e[0m"
useradd ${username}

echo -e "\e[32m  >>>>>>>>>> create app <<<<<<<< \e[0m"
rm -rf /app
mkdir /app

echo -e "\e[32m  >>>>>>>>>> download ${component_pay}.zip <<<<<<<< \e[0m"
curl -L -o /tmp/${component_pay}.zip https://roboshop-artifacts.s3.amazonaws.com/${component_pay}.zip

echo -e "\e[32m  >>>>>>>>>> unzip app <<<<<<<< \e[0m"
cd /app
unzip /tmp/${component_pay}.zip

echo -e "\e[32m  >>>>>>>>>> install library <<<<<<<< \e[0m"
cd /app
pip3.6 install -r requirements.txt

#roboshop123
echo -e "\e[32m  >>>>>>>>>> install systemd <<<<<<<< \e[0m"
sed -i -e "s|rabbitm1_lg_password2|${rabbitm1_lg_password}|" ${script_path}/${component_pay}.systemd
cp ${script_path}/${component_pay}.systemd  /etc/systemd/system/${component_pay}.service

echo -e "\e[32m  >>>>>>>>>> start ${component_pay} systemd <<<<<<<< \e[0m"
systemctl daemon-reload
systemctl enable ${component_pay}
systemctl restart ${component_pay}
}