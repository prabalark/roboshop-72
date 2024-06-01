script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysqlpassword=$1

 if [-z "${mysqlpassword}" ]; then
    echo password is not given
    exit
  fi

component_shp=shipping
func_shipping(){
echo -e " \e[31m >>>>> install maven <<<<< \e[0m"
dnf install maven -y

echo -e "\e[31m >>>>>>>create /app <<<<<< \e[0m"
useradd ${username}
rm -rf /app # bcz re-run of code some time through error
mkdir /app

echo -e " \e[31m >>>>> downlaod ${component_shp} <<<<< \e[0m"
curl -L -o /tmp/${component_shp}.zip https://roboshop-artifacts.s3.amazonaws.com/${component_shp}.zip
cd /app

echo -e " \e[31m >>>>> unzip ${component_shp} <<<<< \e[0m"
unzip /tmp/${component_shp}.zip

echo -e " \e[31m >>>>> install library <<<<< \e[0m"
cd /app
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e " \e[31m >>>>> install mysql <<<<< \e[0m"
dnf install mysql -y

#RoboShop@1 --password as input
echo -e " \e[31m >>>>> load schema mysql <<<<< \e[0m"
mysql -h mysql.devops72bat.online -uroot -p${mysqlpassword} < /app/schema/${component_shp}.sql

echo -e " \e[31m >>>>> install systemd <<<<< \e[0m"
cp $script_path/${component_shp}.systemd /etc/systemd/system/${component_shp}.service

echo -e " \e[31m >>>>> start mysql <<<<< \e[0m"
systemctl daemon-reload
systemctl enable ${component_shp}
systemctl restart ${component_shp}
}

func_shipping