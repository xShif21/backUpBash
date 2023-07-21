#!/bin/bash
#Español
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
    echo -e "\n ${redColour}[!]${endColour}${grayColour}Saliendo....${endColour}"
    tput cnorm
    exit 1
}
trap ctrl_c INT

function getBackUp() {
    if [ ! -e "$1" ]; then
        echo -e "${redColour}[!]${endColour} ${grayColour}El archivo o directorio '$1' no existe.${endColour}"
        exit 1
    fi

    backup="$1"
    read -p "Escribe la ruta de donde quieras que se copie el archivo: " ruta

    if [ ! -d "$ruta" ]; then
        echo -e "${redColour}[!]${endColour} ${grayColour}La ruta '$ruta' no existe.${endColour}"
        exit 1
    fi

    echo -e "${turquoiseColour}Estamos haciendo el BackUp. Por favor, espera.${endColour}"
    sleep 1
    cp --backup --recursive "$backup" "$ruta/BackUpNuevo_$date"

    if [ $? -eq 0 ]; then
        echo -e "\n ${purpleColour}Tu archivo está aquí $ruta/BackUpNuevo_$date ${endColour}"
    else
        echo -e "\n ${redColour}Error al realizar el BackUp.${endColour} ${grayColour} Tambien puede que no tienes suficientes permisos para hacerlo\n $(id | awk '{print $1}' | tr -d 'uid=1000()')${endColour}"
        exit 1
    fi
}

function helpPanel(){
	tput civis
    echo -e "${yellowColour}\n[+]Uso:${endColour}"
    echo -e "\t${yellowColour}b)${endColour} ${grayColour}$0${endColour} ${yellowColour}-b${endColour}${grayColour} \"Archivo\" \"Directorio\"${endColour} ${redColour}(Sin las comillas)${endColour}"
    echo -e "\t\n ${redColour} Nota el archivo que deseas copiar debe de ser el mismo usuario que creó el archivo ${endColour}"
	sleep 1.1
	tput cnorm
}

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
