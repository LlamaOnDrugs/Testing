#/bin/bash
clear

read -p "How many installs?" VAR

installs="$VAR"

dupmn iplist

read -p "Starting IP?: " IPVAR

startip="$IPVAR"

function conf_set_value() {
	# <$1 = conf_file> | <$2 = key> | <$3 = value> | [$4 = force_create]
	#[[ $(grep -ws "^$2" "$1" | cut -d "=" -f1) == "$2" ]] && sed -i "/^$2=/s/=.*/=$3/" "$1" || ([[ "$4" == "1" ]] && echo -e "$2=$3" >> $1)
	local key_line=$(grep -ws "^$2" "$1")
	[[ "$(echo $key_line | cut -d '=' -f1)" =~ "$2" ]] && sed -i "/^$2/c $(echo $key_line | grep -oP '^[\s\S]{0,}=[\s]{0,}')$3" $1 || $([[ "$4" == "1" ]] && echo -e "$2=$3" >> $1)
}
function conf_get_value() {
	# <$1 = conf_file> | <$2 = key> | [$3 = limit]
	[[ "$3" == "0" ]] && grep -ws "^$2" "$1" | cut -d "=" -f2 || grep -ws "^$2" "$1" | cut -d "=" -f2 | head $([[ ! $3 ]] && echo "-1" || echo "-$3")
}


counter=1
while [ $counter -le $installs ]
do
  $(conf_set_value "/root/.quantisnetcore$counter/quantisnet.conf" "externalip" "[$startip$counter]:9801" 1)
  ((counter++))
done
