#!/bin/bash

echo " _____                      _             _           __   _____  ___ _     "
echo "|  ___|                    | |           (_)          \ \ / /|  \/  || |    "
echo "|___ \ _ __ ___   ___ _ __ | |_ __ _ _ __ _  ___  ___  \ V / | .  . || |    "
echo "    \ \ |_   _ \ / _ \  _ \| __/ _  | ´__´ |/ _ \/ __| /   \ | |\/| || |    "
echo "/\__/ / | | | | |  __/ | | | || (_| | |  | | (_) \__ \/ /^\ \| |  | || |____"
echo "\____/|_| |_| |_|\___|_| |_|\__\__,_|_|  |_|\___/|___/\/   \/\_|  |_/\_____/"

# añadir más archivos a $FILE

endColour="\e[0m"
redColour="\e[0;31m"
greenColour="\e[0;32m"
yellowColour="\e[0;33m"
blueColour="\e[0;34m"
purpleColour="\e[0;35m"
cianColour="\e[0;36m"
greyColour="\e[0;37m"

function usage {
	echo -e "\n${yellowColour}Help!: How can I use this:${endColour}"
	echo -e "\nFlag\tDescription \t\t\t\t\tIs required?"
	echo -e "${cianColour}[-f]${endColour}\tSelect tarjet xml file to uncomment.\t${greenColour}(required)${endColour}"
	echo -e "${cianColour}[-o]${endColour}\tSelect some output to save xml file.\t${yellowColour}(optional)${endColour}"
	exit 1
}

while getopts f:o:h: opt
do
	case "$opt" in
		f) FILE=$OPTARG;;
		o) OUTPUT=$OPTARG;;
		*) usage
	esac
done

if [ -z "$FILE" ]; then
        usage
fi

if [[ "$FILE" == "/"* ]]; then
	PATH_FILE="$FILE"
else
	PATH_FILE="$PWD/$FILE"
fi

if [[ "$OUTPUT" == "/"* ]]; then
        PATH_OUTPUT="$OUTPUT"
else
        PATH_OUTPUT="$PWD/$OUTPUT"
fi

N_LINEAS=$(cat $PATH_FILE | wc -l)
TEMP="$PATH_FILE.temp"
ABRIR=0

cp $PATH_FILE $TEMP

for i in $(seq 1 $N_LINEAS)
do
	if [[ "$(cat $TEMP | awk 'NR=='$i'{print $0}')" == *"<!--"* ]]; then
		ABRIR=1
	fi

	if [[ "$(cat $TEMP | awk 'NR=='$i'{print $0}')" == *"-->"* ]]; then
                sed -i $i' s/^.*$//' $TEMP
		ABRIR=0
        fi

	if [ $ABRIR -eq 1 ]; then
		sed -i $i' s/^.*$//' $TEMP
	fi

done

if [ -z "$OUTPUT" ]; then
	cat $TEMP | grep -v "^$" > $PATH_FILE
	rm -f $TEMP
else
	cat $TEMP | grep -v "^$" > $PATH_OUTPUT
	rm -f $TEMP
fi
