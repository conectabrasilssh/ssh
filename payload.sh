#!/bin/bash
clear
##sed -i "s/mhost/'$valor1'/g" /root/skeleton.txt
##sed -i "s/mip/'$valor2'/g" /root/skeleton.txt


echo -e "\033[1;33m1 \033[1;31m
DIGITE UM HOST PARA CRIAR AS PAYLOADS GENERICAS! \033[1;33m

2 \033[1;31m
DIGITE SEM HTTP//
DIGITE APENAS A HOST"

sleep 3s
echo -e "\033[1;33m__________________________________________\033[1;32m"
rm -rf /root/skeleton.txt 
echo -e "\033[1;36mCRIADOR DE PAYLOADS"
echo -e "\033[1;33m__________________________________________\033[0m"
echo -e "\033[1;31mDIGITE O HOST\033[1;33m"
read -p ": " valor1
if [ "$valor1" = "" ]; then
echo -e "\033[1;31mNao Digitou Nada!!!"
exit
fi
echo -e "\033[1;31mDIGITE SEU IP\033[1;33m"
read -p ": " valor2
if [ "$valor2" = "" ]; then
valor2="127.0.0.1"
fi
echo -e "\033[1;31mESCOLHA O METODO DE REQUISIÇÃO...\033[1;33m
1-GET                           
2-CONNECT
3-PUT                          
4-OPTIONS
5-DELETE                     
6-HEAD
7-TRACE                      
8-PROPATCH
9-PATCH"
read -p ": " valor3
case $valor3 in
1)
req="GET"
;;
2)
req="CONNECT"
;;
3)
req="PUT"
;;
4)
req="OPTIONS"
;;
5)
req="DELETE"
;;
6)
req="HEAD"
;;
7)
req="TRACE"
;;
8)
req="PROPATCH"
;;
9)
req="PATCH"
;;
*)
req="GET"
;;
esac
echo -e "\033[1;31mE POR ULTIMO, ESCOLHA O METODO DE INJEÇÃO!\033[1;33m
1-realData
2-netData
3-raw"
read -p ": " valor4
case $valor4 in
1)
in="realData"
;;
2)
in="netData"
;;
3)
in="raw"
;;
*)
in="netData"
;;
esac
sed -e "s;realData;abc;g" /bin/esqueleton > /tmp/esq1
sed -e "s;netData;abc;g" /tmp/esq1 > /tmp/esq2
sed -e "s;raw;abc;g" /tmp/esq2 > /tmp/esq3
sed -e "s;abc;$in;g" /tmp/esq3 > /tmp/esq
sed -e "s;get;$req;g" /tmp/esq > /tmp/es
sed -e "s;mhost;$valor1;g" /tmp/es > /tmp/es1
sed -e "s;mip;$valor2;g" /tmp/es1 > /root/$valor1.txt
testt=$(cat /root/$valor1.txt |egrep -o $valor1)
if [ "$testt" = "" ]; then
echo -e ""
echo -e "\033[1;33mALGO DEU\033[1;36m ERRADO!\033[0m"
rm -rf /root/$valor1.txt
rm -rf /tmp/es
rm -rf /tmp/es1
rm -rf /tmp/esq
rm -rf /tmp/esq1
rm -rf /tmp/esq2
rm -rf /tmp/esq3
sleep 5s
else
echo -e "\033[1;33mSUCESSO, ARQUIVO COM AS PAYLOADS CRIADO NA PASTA\033[1;36m /root/$valor1.txt\033[0m"
sleep 2s
sleep 3s
rm -rf /tmp/es
rm -rf /tmp/es1
rm -rf /tmp/esq
rm -rf /tmp/esq1
rm -rf /tmp/esq2
rm -rf /tmp/esq3
fi
echo -e "\033[0m"
exit
