#!/bin/bash
clear
echo -e "\033[1;30m------------------------------------------------------------\033[0m"
echo -e "\033[42;30m Usuario               Senha               Data E.          Logins\033[0m"
echo -e "\033[1;30m------------------------------------------------------------\033[0m"
touch /bin/usrrrrrrrrrr
for users in `awk -F : '$3 > 900 { print $1 }' /etc/passwd |grep -v "nobody" |grep -vi polkitd |grep -vi system-`
do
if [[ -e /etc/VpsPackdir/limite/$users ]]; then
limitecs=$(cat /etc/VpsPackdir/limite/$users)
else
limitecs="Nada"
fi
if [[ -e /etc/VpsPackdir/senha/$users ]]; then
senha=$(cat /etc/VpsPackdir/senha/$users)
else
senha="Nada"
fi
data=$(chage -l $users |grep -i co |awk -F : '{print $2}')
if [ "$data" = "never" ]; then
data="Nunca"
fi
detalhesdata=$(printf '%-18s' "$data")
detalheslimit=$(printf '%-10s' "$limitecs")
detalhes=$(printf ' %-21s' "$users")
detalhespass=$(printf '%-18s' "$senha")
echo -e "$limitecs" > /tmp/dp
ovc=$(cat /tmp/dp | egrep -o OPENVPN)
if [ "$ovc" = "" ]
then
echo -e "\033[1;33m$detalhes $detalhespass $detalhesdata $detalheslimit\033[0m"
else
echo -e "\033[1;31m$detalhes $detalhespass $detalhesdata $detalheslimit\033[0m"
fi
rm -rf /tmp/dp
echo "users" >> /bin/usrrrrrrrrrr
echo -e "\033[1;30m------------------------------------------------------------\033[0m"
done
#teste
echo -e "\033[1;30m------------------------------------------------------------\033[0m"
echo -e "\033[42;30m QUANTIDADE     DE      CONTAS       CRIADAS     NO      SERVIDOR \033[0m"
echo -e "\033[1;30m------------------------------------------------------------\033[0m"
CONTAS=`cat /bin/usrrrrrrrrrr | wc -l`
echo
echo -e '\033[01;32mVOCE TEM UM TOTAL
DE:\033[00;37m' $CONTAS
echo -e '\033[01;32mUSUARIOS EM SEU SERVIDOR!\033[00;37m'
rm -rf /bin/usrrrrrrrrrr
echo -e "\033[1;31mPARA VOLTAR PRESSIONE ENTER\033[0m"
read -p " "
sleep 1s
exit

