

echo $0
echo dirname
echo dirname "$0"
echo dirname$0

realpath "$0"

script=$(realpath "$0")
script_path=$(dirname "$script")
source  ${script_path}/common.sh
echo   ${script_path}

exit


a =10
 a1=10
 a2='10'
 b =rk
 b1=rk
 c='rk'
 d="rk"
 e=2024-05-29
 f='2024-05-29'
 f1=$(date +%F)

 #echo x is 10
 echo a is $a
#echo x is 10
echo a1 is "$a1"
 #echo x is 10
echo a2 = $a2
 #echo x is rk
 echo b is $b
 #echo x is rk
 echo b1 is "$b1"
 #echo x is rk
 echo c is ${c}
 #echo x is rk
 echo d is ${d}
 #echo x is rk
 echo e is ${e}
 #echo x is rk
 echo f is ${f}
 #echo x is rk
 echo f1 is ${f1}


echo argument $0
echo argument $1
echo argument $2
echo argument $*
echo argument $#
echo argument $?
