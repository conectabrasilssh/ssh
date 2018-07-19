clear
echo -e "\E[44;1;37m             Gerenciador De Backups              \E[0m"
echo ""
echo -e "              \033[1;32mO que deseja fazer?\033[0m"
echo ""
echo -e "\033[1;33m[\033[1;31m1\033[1;33m] \033[1;37m- \033[1;33mCRIAR BACKUP"
echo -e "\033[1;33m[\033[1;31m2\033[1;33m] \033[1;37m- \033[1;33mRESTAURAR BACKUP"
echo -e "\033[1;33m[\033[1;31m3\033[1;33m] \033[1;37m- \033[1;33mVOLTAR\033[1;37m"
echo ""

read -p "Opção: " -e -i 3 opcao

if [[ "$opcao" = '1' ]]; then
	if [ -f "/root/usuarios.db" ]
	then
		echo ""
		echo -e "\033[1;32mCriando backup...\033[0m"
		echo ""
		tar cvf /root/backup.vps /root/usuarios.db /etc/shadow /etc/passwd /etc/group /etc/gshadow 1>/dev/null 2>/dev/null
       sleep 2
		echo ""
		echo -e "\033[1;33mO Arquivo \033[1;32mbackup.vps"
       echo -e "\033[1;33mfoi criado com sucesso no diretório \033[1;31m/root\033[0m"
		echo ""
	else
		echo ""
		echo -e "\033[1;32mCriando backup...\033[0m"
		echo ""
		tar cvf /root/backup.vps /etc/shadow /etc/passwd /etc/group /etc/gshadow 1>/dev/null 2>/dev/null
       sleep 2s
		echo ""
		echo -e "\033[1;33mO Arquivo \033[1;32mbackup.vps"
       echo -e "\033[1;33mfoi criado com sucesso no diretório \033[1;31m/root\033[0m"
		echo ""
	fi
fi
if [[ "$opcao" = '2' ]]; then
	if [ -f "/root/backup.vps" ]
	then
		echo ""
		echo -e "\033[1;36mRestaurando backup..."
		echo ""
		sleep 2s
		cp /root/backup.vps /backup.vps
		cd /
		tar -xvf backup.vps
		rm /backup.vps
		echo ""
		echo -e "\033[1;36mUsuários \033[1;33me\033[1;36m \033[1;33msenhas importados com sucesso.\033[0m"
		echo ""
		exit
	else
		echo ""
		echo -e "\033[1;33mO arquivo /root/\033[1;32mbackup.vps \033[1;33mnão foi encontrado!"
		echo -e "\033[1;33mCeritifique-se que ele esteja localizado no diretório /root/ com o nome \033[1;32mbackup.vps\033[0m"
		echo ""
		exit
	fi
fi
if [[ "$opcao" = '3' ]]; then
menu
fi
