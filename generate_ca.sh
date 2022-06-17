#!/usr/bin/env bash

# Ansi color code variables
red="\e[0;91m"
blue="\e[0;94m"
expand_bg="\e[K"
blue_bg="\e[0;104m${expand_bg}"
red_bg="\e[0;101m${expand_bg}"
green_bg="\e[0;102m${expand_bg}"
green="\e[0;92m"
white="\e[0;97m"
bold="\e[1m"
uline="\e[4m"
reset="\e[0m"


# Variables
KEYFILE=private/ca.key.pem
CERTFILE=certs/ca.cert.pem

if [ -r ./config.sh ];
then
      . ./config.sh
else
      echo -e "${red}Pas de fichier de configuration${reset}"
      exit 1
fi

echo -e "${blue}Génération de la clé${reset}"

if [ -r ${KEYFILE} ];
then
    echo -e "${gree}Une clé existe déjà.${reset}"
else
    openssl genrsa --passout pass:${PASSWORD} -aes256 -out ${KEYFILE} 4096
fi




openssl req -config ca.cnf \
    -key ${KEYFILE} \
    -new -x509 -days 7300 -sha256 \
    -passin pass:${PASSWORD} \
    -extensions v3_ca \
    -out ${CERTFILE}

chmod 444 ${CERTFILE}

# openssl x509 -noout -text -in ${CERTFILE}
