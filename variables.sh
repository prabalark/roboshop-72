

echo $0
dirname
echo dirname
echo dirname "$0"
echo dirname$0

script=$(realpath "$0")
script_path=$(dirname "$script")
source  ${script_path}/common.sh

echo   ${script_path}

exit