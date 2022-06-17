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
KEYFILE=intermediate/private/intermediate.key.pem
CSRFILE=intermediate/csr/intermediate.csr.pem
CERTFILE=intermediate/certs/intermediate.cert.pem

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


echo -e "${blue}Génération du CSR${reset}"

openssl req -config intermediate/ca-intermediate.cnf \
      -key ${KEYFILE} \
      -new -sha256 \
      -passin pass:${PASSWORD} \
      -out ${CSRFILE}

# openssl x509 -noout -text -in ${CSRFILE} | less

echo -e "${blue}Signature du CSR${reset}"
openssl ca -config ca.cnf \
      -extensions v3_intermediate_ca \
      -passin pass:${PASSWORD} \
      -days 3650 -notext -md sha256 -batch \
      -in ${CSRFILE} \
      -out ${CERTFILE}
