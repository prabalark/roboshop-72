script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=user
schma_check=mongodb
func_nodejs
