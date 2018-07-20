#!/bin/bash
#
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%30s%s%-15s\n' "Detalhes Servidor 1.0" ; tput sgr0
echo ""
echo ""
tput setaf 7 ; tput setab 1 ; printf '  %-30s%s\n' "--------------------------------------------------------------------" ; echo "" ; tput sgr0
echo ""
tput setaf 2 ; tput bold ; echo "	HOSTNAME : " ; tput sgr0
echo ""
hostname
echo ""
tput setaf 2 ; tput bold ; echo "	TEMPO ATIVO : " ; tput sgr0
echo ""
uptime | sed 's/.*up \([^,]*\), .*/\1/'
echo ""
tput setaf 2 ; tput bold ; echo "	MEMORIA RAM TOTAL : " ; tput sgr0
echo ""
free | grep Mem | awk '{ print $2 }'
echo ""
tput setaf 2 ; tput bold ; echo "	MEMORIA RAM USADA : " ; tput sgr0
echo ""
free | grep Mem | awk '{ print $3 }'
echo ""
tput setaf 2 ; tput bold ; echo "	MEMORIA RAM LIVRE : " ; tput sgr0
echo ""
free | grep Mem | awk '{ print $4 }'
echo ""
tput setaf 2 ; tput bold ; echo "	DETALHES DA MEMÓRIA : " ; tput sgr0
echo ""
free | awk '/^Mem:/ { print "used: " 100*$3/$2 "%  free: " 100*$4/$2 "%";}'
echo ""
tput setaf 2 ; tput bold ; echo "	 DETALHES DA CPU : " ; tput sgr0
echo ""
inxi -C
echo ""
echo ""
tput setaf 7 ; tput setab 1 ; printf '  %-30s%s\n' "--------------------------------------------------------------------" ; echo "" ; tput sgr0
echo ""
