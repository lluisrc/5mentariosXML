#!/bin/bash

echo " _____                      _             _           __   _____  ___ _     "
echo "|  ___|                    | |           (_)          \ \ / /|  \/  || |    "
echo "|___ \ _ __ ___   ___ _ __ | |_ __ _ _ __ _  ___  ___  \ V / | .  . || |    "
echo "    \ \ |_   _ \ / _ \  _ \| __/ _  | ´__´ |/ _ \/ __| /   \ | |\/| || |    "
echo "/\__/ / | | | | |  __/ | | | || (_| | |  | | (_) \__ \/ /^\ \| |  | || |____"
echo "\____/|_| |_| |_|\___|_| |_|\__\__,_|_|  |_|\___/|___/\/   \/\_|  |_/\_____/"


# añadir más archivos a $FILE

FILE=""
OUTPUT=""
ABRIR=0


function usage {
	echo -e "Help!: How can I use this:"
	echo -e "Flag\tDescription \t\t\t\t\tIs required?"
	echo -e "[-f]\tSelecciona el fichero .xml a descomentar.\t(required)"
	echo -e "[-o]\tSelecciona la salida del fichero descomentado\t(not required)"
	exit 0
}


while getopts f:o:h: opt
do
	case "${opt}" in
		f) FILE=${OPTARG};;
		o) OUTPUT=${OPTARG};;
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

cp $PATH_FILE $TEMP

for i in $(seq 1 $N_LINEAS)
do
	if [ $(cat $TEMP | awk 'NR=='$i'{print $0}' | grep "<\!--" | wc -l) -ne 0 ]; then
		ABRIR=1
	fi

	if [ $(cat $TEMP | awk 'NR=='$i'{print $0}' | grep "\-->" | wc -l) -ne 0 ]; then
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
