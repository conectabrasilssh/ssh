#!/bin/bash
if readlink /proc/$$/exe | grep -qs "dash"; then
	echo "This script needs to be run with bash, not sh"
	exit 1
fi

if [[ "$EUID" -ne 0 ]]; then
	echo "Sorry, you need to run this as root"
	exit 2
fi

if [[ ! -e /dev/net/tun ]]; then
if [ -z "$(command grep '^tun$' '/etc/modules')" ]; then
  command echo '# Needed by OpenVPN
tun' >> '/etc/modules'
fi
if [ ! -e '/dev/net/tun' ]; then
  command mkdir --parent '/dev/net'
  command mknod '/dev/net/tun' c 10 200
fi
	echo "TUN is not available"
	exit 3
fi

if grep -qs "CentOS release 5" "/etc/redhat-release"; then
	echo "CentOS 5 is too old and not supported"
	exit 4
fi
if [[ -e /etc/debian_version ]]; then
	OS=debian
	GROUPNAME=nogroup
	RCLOCAL='/etc/rc.local'
elif [[ -e /etc/centos-release || -e /etc/redhat-release ]]; then
	OS=centos
	GROUPNAME=nobody
	RCLOCAL='/etc/rc.d/rc.local'
else
	echo "Looks like you aren't running this installer on a Debian, Ubuntu or CentOS system"
	exit 5
fi

newclient () {
	# Generates the custom client.ovpn
	cp /etc/openvpn/client-common.txt ~/$1.ovpn
	echo "<ca>" >> ~/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/ca.crt >> ~/$1.ovpn
	echo "</ca>" >> ~/$1.ovpn
	echo "<cert>" >> ~/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/issued/$1.crt >> ~/$1.ovpn
	echo "</cert>" >> ~/$1.ovpn
	echo "<key>" >> ~/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/private/$1.key >> ~/$1.ovpn
	echo "</key>" >> ~/$1.ovpn
	echo "<tls-auth>" >> ~/$1.ovpn
	cat /etc/openvpn/ta.key >> ~/$1.ovpn
	echo "</tls-auth>" >> ~/$1.ovpn
}

# Try to get our IP from the system and fallback to the Internet.
# I do this to make the script compatible with NATed servers (lowendspirit.com)
# and to avoid getting an IPv6.
IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)

if [[ -e /etc/openvpn/server.conf ]]; then
	while :
	do
	clear
if [ $(id -u) -eq 0 ]
then
	clear
else
	if echo $(id) |grep sudo > /dev/null
	then
	clear
	echo "Voce não é root"
	echo "Seu usuario esta no grupo sudo"
	echo -e "Para virar root execute \033[1;31msudo su\033[0m"
	exit
	else
	clear
	echo -e "Vc nao esta como usuario root, nem com seus direitos (sudo)\nPara virar root execute \033[1;31msu\033[0m e digite sua senha root"
	exit
	fi
fi

clear
echo -e "\033[36;37m PAINEL DE GERENCIAMENTO DA VPS, OS ARQUIVOS SERAO SALVOS NA PASTA ROOT\033[0m"
echo -e "\033[0;35m------------------------------------------------------------\033[0m"
echo -e "\033[1;36m[\033[1;31m1\033[1;36m] CRIAR USUARIO \033[1;30m(CRIA USUARIOS)\033[1;36m
[\033[1;31m2\033[1;36m] REMOVER USUARIO \033[1;30m(REMOVE USUARIOS)\033[1;36m
[\033[1;31m3\033[1;36m] REMOVER TODOS USUARIOS \033[1;30m(REMOVE USUARIOS)\033[1;36m
[\033[1;31m4\033[1;36m] REMOVER OPENVPN \033[1;30m(remoçao do ovpn)\033[1;36m
[\033[1;31m5\033[1;36m] ELIMINAR VENCIDOS \033[1;30m(remoçao de vencidos)\033[1;36m
[\033[1;31m6\033[1;36m] MUDAR DATA USUARIOS \033[1;30m(Mudar a data U.Ovpn)\033[1;36m
[\033[1;31m7\033[1;36m] EDITAR CLIENTE GENERICO \033[1;30m(mudar config do cliente gerado)\033[1;36m
[\033[1;31m8\033[1;36m] MONITOR DE USUARIOS OPENVPN \033[1;30m(Monitor!)\033[1;36m
[\033[1;31m9\033[1;36m] RECARREGAR SERVIÇOS OVPN\033[1;30m(reiniciar serviços)\033[1;36m
[\033[1;31m0\033[1;36m] VOLTAR \033[1;30m(Menu Adm)\033[0m"
echo -e "\033[0;35m------------------------------------------------------------\033[0m"
echo -e "\033[1;36mQUAL E A SUA OPÇAO?\033[0m"
read -p ": " opcao

case $opcao in
  1) 
echo -e "\033[1;33m"
echo "NOME DO NOVO USUARIO?"
echo -e "\033[1;31mUse somente o nome sem caracteres especiais | Este usuario tambem pode ser Usado Para SSH!\033[0m"
read -p "Nome do usuário: " CLIENT
awk -F : ' { print $1 }' /etc/passwd > /tmp/users
if grep -Fxq "$CLIENT" /tmp/users
then
echo -e "\033[1;31mUsuário ja existente em seu servidor!\033[0m"
sleep 5s
ovpn
exit
fi
rm -rf /tmp/users
echo -e "\033[1;31mDIGITE A SENHA\033[0m"
read -p "senha: " senha
cd /etc/openvpn/easy-rsa/
./easyrsa build-client-full $CLIENT nopass
newclient "$CLIENT"
echo ""
echo "Client $CLIENT KEY DISPONÍVEL" ~/"$CLIENT.ovpn"
#####Sistema datagem
echo -e "\033[1;31mDefinir data? 
[s/n]\033[0m"
read -p ": " simounao
if [ "$simounao" = "s" ]
then
echo -e "\033[1;32mQuantos dias usuario $CLIENT deve durar:\033[0;37m"
read -p " " daysrnf
echo -e "\033[0m"
valid=$(date '+%C%y-%m-%d' -d " +$daysrnf days")
datexp=$(date "+%d/%m/%Y" -d "+ $daysrnf days")
useradd -M -s /bin/false -d /home/ovpn/ $CLIENT -e $valid
usermod -p $(openssl passwd -1 $senha) $CLIENT
touch /etc/VpsPackdir/senha/$CLIENT
touch /etc/VpsPackdir/limite/$CLIENT
echo -e "$senha" > /etc/VpsPackdir/senha/$CLIENT
echo -e "OPENVPN" > /etc/VpsPackdir/limite/$CLIENT
echo -e "\033[1;36mCRIADO COM SUCESSO \033[0m"
sleep 4s
ovpn
exit
  else
useradd -M -s /bin/false -d /home/ovpn/ $CLIENT
usermod -p $(openssl passwd -1 $senha) $CLIENT
touch /etc/VpsPackdir/senha/$CLIENT
touch /etc/VpsPackdir/limite/$CLIENT
echo -e "$senha" > /etc/VpsPackdir/senha/$CLIENT
echo -e "OPENVPN" > /etc/VpsPackdir/limite/$CLIENT
echo -e "\033[1;36mCRIADO COM SUCESSO \033[0m"
ovpn
exit
fi
;;
  2)
echo -e "\033[1;33m"
NUMBEROFCLIENTS=$(tail -n +2 /etc/openvpn/easy-rsa/pki/index.txt | grep -c "^V")
if [[ "$NUMBEROFCLIENTS" = '0' ]]; then
echo ""
echo "NAO HA USUARIOS AINDA"
echo -e "\033[0m"
ovpn
exit
	fi
echo -e "\033[1;36m"
echo "Selecione um usuario para remover"
tail -n +2 /etc/openvpn/easy-rsa/pki/index.txt | grep "^V" | cut -d '=' -f 2 | nl -s ') '
if [[ "$NUMBEROFCLIENTS" = '1' ]]; then
read -p "Selecione um usuario [1]: " CLIENTNUMBER
else
read -p "Selecione um usuario [1-$NUMBEROFCLIENTS]: " CLIENTNUMBER
fi
if [ "$CLIENTNUMBER" = "" ]
then
echo -e "\033[1;31m"
echo "NENHUM USUARIO FOI SELECIONADO"
echo -e "\033[0m"
sleep 4s
ovpn
exit
fi
CLIENT=$(tail -n +2 /etc/openvpn/easy-rsa/pki/index.txt | grep "^V" | cut -d '=' -f 2 | sed -n "$CLIENTNUMBER"p)
cd /etc/openvpn/easy-rsa/
./easyrsa --batch revoke $CLIENT
./easyrsa gen-crl
rm -rf pki/reqs/$CLIENT.req
rm -rf pki/private/$CLIENT.key
rm -rf pki/issued/$CLIENT.crt
rm -rf /etc/openvpn/crl.pem
cp /etc/openvpn/easy-rsa/pki/crl.pem /etc/openvpn/crl.pem
chown nobody:$GROUPNAME /etc/openvpn/crl.pem
echo ""
userdel --force $CLIENT
rm -rf /etc/VpsPackdir/senha/$CLIENT
rm -rf /etc/VpsPackdir/limite/$CLIENT
echo -e "\033[1;31m"
echo "REMOVIDO"
echo -e "\033[0m"
sleep 6s
ovpn
exit;;
  3)
echo -e "\033[1;33m"
touch /tmp/ovpn
touch /tmp/ovpn2
cat /etc/passwd |grep ovpn > /tmp/ovpn
awk -F: '{print $1}' /tmp/ovpn > /tmp/ovpn2
for userss in $(cat /tmp/ovpn2)
do
echo -e "\033[1;31m------------------------------------------------------------\033[0m"
sleep 2s
cd /etc/openvpn/easy-rsa/
./easyrsa --batch revoke $userss
./easyrsa gen-crl
rm -rf pki/reqs/$userss.req
rm -rf pki/private/$userss.key
rm -rf pki/issued/$userss.crt
rm -rf /etc/openvpn/crl.pem
cp /etc/openvpn/easy-rsa/pki/crl.pem /etc/openvpn/crl.pem
chown nobody:$GROUPNAME /etc/openvpn/crl.pem
echo ""
userdel --force $userss
rm -rf /etc/VpsPackdir/senha/$userss
rm -rf /etc/VpsPackdir/limite/$userss
done
echo -e "\033[1;31m------------------------------------------------------------\033[0m"
echo "REMOVIDOS"
rm -rf /tmp/ovpn
rm -rf > /tmp/ovpn2
sleep 4s
echo -e "\033[0m"
ovpn
exit;;
  4) 
			echo ""
read -p "Você deseja remover OpenVPN? [y/n]: " -e -i n REMOVE
if [[ "$REMOVE" = 'y' ]]; then
PORT=$(grep '^port ' /etc/openvpn/server.conf | cut -d " " -f 2)
PROTOCOL=$(grep '^proto ' /etc/openvpn/server.conf | cut -d " " -f 2)
IP=$(grep 'iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j SNAT --to ' $RCLOCAL | cut -d " " -f 11)
if pgrep firewalld; then
					# Using both permanent and not permanent rules to avoid a firewalld reload.
firewall-cmd --zone=public --remove-port=$PORT/$PROTOCOL
firewall-cmd --zone=trusted --remove-source=10.8.0.0/24
firewall-cmd --permanent --zone=public --remove-port=$PORT/$PROTOCOL
firewall-cmd --permanent --zone=trusted --remove-source=10.8.0.0/24
fi
if iptables -L -n | grep -qE 'REJECT|DROP|ACCEPT'; then
iptables -D INPUT -p $PROTOCOL --dport $PORT -j ACCEPT
iptables -D FORWARD -s 10.8.0.0/24 -j ACCEPT
iptables -D FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
sed -i "/iptables -I INPUT -p $PROTOCOL --dport $PORT -j ACCEPT/d" $RCLOCAL
sed -i "/iptables -I FORWARD -s 10.8.0.0\/24 -j ACCEPT/d" $RCLOCAL
sed -i "/iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT/d" $RCLOCAL
fi
iptables -t nat -D POSTROUTING -s 10.8.0.0/24 -j SNAT --to $IP
sed -i '/iptables -t nat -A POSTROUTING -s 10.8.0.0\/24 -j SNAT --to /d' $RCLOCAL
if hash sestatus 2>/dev/null; then
if sestatus | grep "Current mode" | grep -qs "enforcing"; then
if [[ "$PORT" != '1194' || "$PROTOCOL" = 'tcp' ]]; then
semanage port -d -t openvpn_port_t -p $PROTOCOL $PORT
	fi
 fi
fi
if [[ "$OS" = 'debian' ]]; then
apt-get remove --purge -y openvpn openvpn-blacklist
else
yum remove openvpn -y
fi
rm -rf /etc/openvpn
rm -rf /usr/share/doc/openvpn*
echo ""
echo "OpenVPN removido!"
adm
exit
else
echo ""
echo "Remoção abordada!"
fi
adm
exit;;
 0)
adm
exit;;
 5)
cat /etc/passwd |grep ovpn > /tmp/ovpn
datenow=$(date +%s)
tput setaf 7 ; tput setab 2 ; tput bold ; printf '%45s%-10s%-5s\n' "Removedor de contas expiradas" ""
printf '%-20s%-25s%-20s\n' "Usuário" "Data de expiração" "Estado/Ação" ; echo "" ; tput sgr0
for user in $(awk -F: '{print $1}' /tmp/ovpn); do
	expdate=$(chage -l $user|awk -F: '/Account expires/{print $2}')
	echo $expdate|grep -q never && continue
	datanormal=$(date -d"$expdate" '+%d/%m/%Y')
	tput setaf 3 ; tput bold ; printf '%-20s%-21s%s' $user $datanormal ; tput sgr0
	expsec=$(date +%s --date="$expdate")
	diff=$(echo $datenow - $expsec|bc -l)
	tput setaf 2 ; tput bold
	echo $diff|grep -q ^\- && echo "Ativo (Não removido)" && continue
	tput setaf 1 ; tput bold
echo "Expirado (Removido)"
cd /etc/openvpn/easy-rsa/
./easyrsa --batch revoke $user
./easyrsa gen-crl
rm -rf pki/reqs/$user.req
rm -rf pki/private/$user.key
rm -rf pki/issued/$user.crt
rm -rf /etc/openvpn/crl.pem
cp /etc/openvpn/easy-rsa/pki/crl.pem /etc/openvpn/crl.pem
chown nobody:$GROUPNAME /etc/openvpn/crl.pem
userdel --force $user
rm -rf /etc/VpsPackdir/senha/$user
rm -rf /etc/VpsPackdir/limite/$user
sleep 1s
done 
tput sgr0 
sleep 2s
cd /root/
rm  -rf /tmp/ovpn
ovpn
exit
;;
6)
cat /etc/passwd |grep ovpn > /tmp/ovpn
echo -e "\033[1;33mUSUARIOS"
SDK=$(awk -F: '{print $1}' /tmp/ovpn)
if [ "$SDK" = "" ]
then
echo -e "\033[1;31mVOCE NAO TEM USUARIOS PARA MUDAR A DATA!\033[0m"
ovpn
exit
 else
echo -e "\033[1;31m_____________________________"
awk -F: '{print $1}' /tmp/ovpn
echo -e "\033[1;31m_____________________________"
echo -e "\033[1;36mNOME DO USUARIO\033[0m"
read -p ": " namer
echo -e "\033[1;36mDIGITE A NOVA DATA EM NUMEROS\033[0m"
echo -e "\033[1;36mDIA?\033[0m"
read -p ": " dia
echo -e "\033[1;36mMES?\033[0m"
read -p ": " mes
echo -e "\033[1;36mANO?\033[0m"
read -p ": " ano
date="$ano/$mes/$dia"
chage -E $date $namer 2> /dev/null
echo -e "\033[1;31mUsuario $namer Date: $date\033[0m"
sleep 1s
ovpn
exit
fi
;;
7)
clear
echo -e "\033[1;33m
1 \033[1;31mDigite o valor a ser alterado, ele tem que estar igual ao do arquivo.\033[1;33m

2 \033[1;31mDigite o novo valor."
sleep 6s
echo -e "\033[1;33m__________________________________________\033[1;32m"
cat /etc/openvpn/client-common.txt
echo -e "\033[1;33m__________________________________________\033[0m"
echo -e "\033[1;33mVALOR A ALTERAR!"
read -p ": " valor1
if [ "$valor1" = "" ]; then
echo -e "\033[1;31mNao Digitou Nada!!!"
ovpn
exit
fi
echo -e "\033[1;33mNOVO VALOR!"
read -p ": " valor2
sed -i "s/$valor1/$valor2/g" /etc/openvpn/client-common.txt
testt=$(cat /etc/openvpn/client-common.txt |egrep -o $valor2)
if [ "$testt" = "" ]; then
echo -e "\033[1;31mNAO ALTERADO VOCE DIGITOU ERRADO O VALOR A ALTERAR!"
sleep 5s
else
echo -e "\033[1;36mSUCESSO, VALOR ALTERADO!"
sleep 3s
fi
ovpn
exit
;;
8)
echo -e "\033[1;33m"
touch /tmp/ovpn
touch /tmp/ovpn2
usuario=$(printf '%-18s' "USUARIO")
conexao=$(printf '%-10s' "ONLINE")
echo -e "\033[01;32m-------------------------"
echo -e "\033[01;31m$usuario $conexao\033[00;37m"
echo -e "\033[01;32m-------------------------"
cat /etc/passwd |grep ovpn > /tmp/ovpn
awk -F: '{print $1}' /tmp/ovpn > /tmp/ovpn2
for us1 in $(cat /tmp/ovpn2)
do
us=$(cat /etc/openvpn/openvpn-status.log |grep $
