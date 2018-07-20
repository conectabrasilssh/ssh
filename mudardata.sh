#!/bin/bash
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%33s%s%-12s\n' "Mudar data de expiração" ; tput sgr0
echo ""
echo -e "\033[1;33m Lista de usuários e datas de expiração:\033[0m "
echo ""
tput setaf 7 ; tput bold 
awk -F : '$3 >= 500 { print $1 }' /etc/passwd | grep -v '^nobody' | while read user
  do
	expire="$(chage -l $user | grep -E "Account expires" | cut -d ' ' -f3-)"
	if [[ $expire == "never" ]]
	then
		nunca="Nunca"
		printf '  %-30s%s\n' "$user" "Nunca"
	else
		databr="$(date -d "$expire" +"%Y%m%d")"
		hoje="$(date -d today +"%Y%m%d")"
		if [ $hoje -ge $databr ]
		then
			datanormal="$(date -d"$expire" '+%d/%m/%Y')"
			printf '  %-30s%s' "$user" "$datanormal" ; tput setaf 1 ; tput bold ; echo " (Expirou)" ; tput setaf 3
			echo "exp" > /tmp/exp
		else
			datanormal="$(date -d"$expire" '+%d/%m/%Y')"
			printf '  %-30s%s\n' "$user" "$datanormal"
		fi
	fi
  done
tput sgr0
echo ""
if [ -a /tmp/exp ]
then
	rm /tmp/exp
fi
echo -ne "\033[1;32mNome do usuario para mudar a data: \033[1;37m"; read usuario
if [[ -z $usuario ]]
then
	echo ""
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "Erro,  Nome de usuário vazio ou inválido! " ; tput sgr0
	echo ""
	exit 1
else
	if [[ `grep -c /$usuario: /etc/passwd` -ne 0 ]]
	then
	    echo ""
	    echo -ne "\033[1;32mDigite uma nova data \033[1;33mEX:(\033[1;37mDIA/MÊS/ANO\033[1;33m): \033[1;37m"; read inputdate
		sysdate="$(echo "$inputdate" | awk -v FS=/ -v OFS=- '{print $3,$2,$1}')"
		if (date "+%Y-%m-%d" -d "$sysdate" > /dev/null  2>&1)
		then
			if [[ -z $inputdate ]]
			then
				echo ""
				tput setaf 7 ; tput setab 1 ; tput bold ;	echo "Você digitou uma data inválida ou inexistente!" ; echo "Digite uma data válida no formato DIA/MÊS/ANO" ; echo "Por exemplo: 21/04/2018" ; tput sgr0 ; tput sgr0
				echo ""
				exit 1	
			else
				if (echo $inputdate | egrep [^a-zA-Z] &> /dev/null)
				then
					today="$(date -d today +"%Y%m%d")"
					timemachine="$(date -d "$sysdate" +"%Y%m%d")"
					if [ $today -ge $timemachine ]
					then
						echo ""
						tput setaf 7 ; tput setab 1 ; tput bold ;	echo "Você digitou uma data passada ou o dia atual!" ; echo "Digite uma data futura e válida no formato DIA/MÊS/ANO" ; echo "Por exemplo: 21/04/2018" ; tput sgr0
						echo ""
						exit 1
					else
						chage -E $sysdate $usuario
						echo ""
						tput setaf 7 ; tput setab 4 ; tput bold ; echo "Sucesso Usuário $usuario nova data: $inputdate " ; tput sgr0
						echo ""
						exit 1
					fi
				else
					echo ""
					tput setaf 7 ; tput setab 1 ; tput bold ;	echo "Você digitou uma data inválida ou inexistente!" ; echo "Digite uma data válida no formato DIA/MÊS/ANO" ; echo "Por exemplo: 21/04/2018" ; tput sgr0
					echo ""
					exit 1
				fi
			fi
		else
			echo ""
			tput setaf 7 ; tput setab 1 ; tput bold ;	echo "Você digitou uma data inválida ou inexistente!" ; echo "Digite uma data válida no formato DIA/MÊS/ANO" ; echo "Por exemplo: 21/04/2018" ; tput sgr0
			echo ""
			exit 1
		fi
	else
		echo " "
		tput setaf 7 ; tput setab 1 ; tput bold ;	echo "O usuário $usuario não existe!" ; tput sgr0
		echo " "
		exit 1
	fi
fi
