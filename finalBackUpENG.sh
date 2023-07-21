#!/bin/bash

endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#variables
date=$(date +%Y-%m-%d)


#ctrl_c
function ctrl_c(){
    echo -e "\n ${redColour}[!]${endColour}${grayColour}Exiting....${endColour}"
    tput cnorm
    exit 1
}
trap ctrl_c INT

function getBackUp() {
    if [ ! -e "$1" ]; then
        echo -e "${redColour}[!]${endColour} ${grayColour}The file \"$1\" doesn't exits.${endColour}"
        exit 1
    fi

    backup="$1"
    read -p "Write a route where you want to copy the file or directory: " ruta

    if [ ! -d "$ruta" ]; then
        echo -e "${redColour}[!]${endColour} ${grayColour}The route \"$ruta\" doesn't exists.${endColour}"
        exit 1
    fi

    echo -e "${turquoiseColour}We are doing the BackUp, please wait.${endColour}"
    sleep 1
    cp --backup --recursive "$backup" "$ruta/BackUpNuevo_$date"

    if [ $? -eq 0 ]; then
        echo -e "\n ${purpleColour}Your file or directory it is here: $ruta/BackUpNuevo_$date ${endColour}"
    else
        echo -e "\n ${redColour}Error to make the BackUp.${endColour} ${grayColour} Or you do not have enought permissions to copy the file this is your username: $(id | awk '{print $1}' | tr -d 'uid=1000()')${endColour}"
        exit 1
    fi
}

function helpPanel(){
	tput civis
    echo -e "${yellowColour}\n[+]Usage:${endColour}"
    echo -e "\t${yellowColour}b)${endColour}${grayColour} $0${endColour} ${yellowColour}-b${endColour} ${grayColour}\"File\"${endColour} ${redColour}Or${endColour} ${grayColour}\"Directory\"${endColour} ${redColour}(Without quote)${endColour}"
    echo -e "\t\n ${redColour} Note the file that you want to copy you should have permissions if not use: \"sudo su\"${endColour}"
	sleep 1.1
	tput cnorm
}

#declare -i works only for integer only numbers not strings
declare -i parameter_counter=0

while getopts "h:b:" arg; do
    case $arg in
    b) backup="$OPTARG"; let parameter_counter+=1;;
    h) ;;
    esac
done

if [ $parameter_counter -eq 1 ]; then
    getBackUp "$backup"
else
    helpPanel
fi
