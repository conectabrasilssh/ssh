#!/bin/bash
clear
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%35s%s%-20s\n' "TCP Speed" ; tput sgr0
if [[ `grep -c "^#PH56" /etc/sysctl.conf` -eq 1 ]]
then
	echo ""
	echo -e "\033[1;33mAs configurações TCP Speed já foram adicionadas!\033[1;32m"
	echo ""
	read -p "Deseja remover o TCP Speed? [s/n]: " -e -i n resposta0
	if [[ "$resposta0" = 's' ]]; then
		fun_tcpoff () {
		grep -v "^#PH56
net.ipv4.tcp_window_scaling = 1
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 16384 16777216
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_slow_start_after_idle = 0" /etc/sysctl.conf > /tmp/syscl && mv /tmp/syscl /etc/sysctl.conf
sysctl -p /etc/sysctl.conf > /dev/null
		echo ""
		echo -e "\033[1;32mO TCP Speed foi desativado com sucesso."
        }
        fun_tcpoff
	else 
		echo ""
		exit
	fi
else
	echo ""
	echo -e "\033[1;33mEste script irá alterar algumas configurações de rede"
	echo "do sistema para meçhorar a latência e a velocidade."
	echo -e "\033[1;32m\nUse por sua conta e risco!"
	echo ""
	echo -ne "\033[1;32mDESEJA ATIVAR O TCP SPEED \033[1;31m? \033[1;33m[s/n]:\033[1;37m "; read -e -i n resposta
	if [[ "$resposta" = 's' ]]; then
	echo ""
	fun_tcpon () {
	echo " " >> /etc/sysctl.conf
	echo "#PH56" >> /etc/sysctl.conf
echo "net.ipv4.tcp_window_scaling = 1
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 16384 16777216
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_slow_start_after_idle = 0" >> /etc/sysctl.conf
echo ""
sysctl -p /etc/sysctl.conf
        }
		echo ""
		echo -e "\033[1;32mTCP Speed foi ativado com sucesso."
		echo ""
	else
		echo ""
		echo -e "\033[1;31mA instalação foi cancelada pelo usuário!"
		echo ""
	fi
fi
