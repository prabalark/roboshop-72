source common.sh

echo -e "\e[32m >>>>>>>>>install repo<<<<<<<<<< \e[0m"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_path}
func_exit $?
dnf module enable redis:remi-6.2 -y &>>${log_path}
func_exit $?
dnf install redis -y &>>${log_path}
func_exit $?

echo -e "\e[32m >>>>>>>>>install update listen <<<<<<<<<< \e[0m"
#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/redis.conf
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf &>>${log_path}
func_exit $?

echo -e "\e[32m >>>>>>>>>install start redis <<<<<<<<<< \e[0m"
systemctl enable redis &>>${log_path}
func_exit $?
systemctl restart redis &>>${log_path}
func_exit $?