#!/bin/bash

clear

echo -e "\033[4;36m © TwoVPS | 2018 All rights reserved \033[0m"

echo ""

echo -e "\033[1;36mStart PythonSocks\033[0m"
echo ""
echo -e "\033[1;31mVerificando... \033[0m"

sleep 2

abobora=/root/
verde=proxy80.py
rosa=proxy8080.py
preto=proxy8799.py
azul=proxy3128.py

sshd_config(){ echo "# © TwoVPS | 2018 All rights reserved
#
Port 22
Port 144
Protocol 2
KeyRegenerationInterval 3600
ServerKeyBits 1024
SyslogFacility AUTH
LogLevel INFO
LoginGraceTime 120
PermitRootLogin yes
StrictModes yes
RSAAuthentication yes
PubkeyAuthentication yes
IgnoreRhosts yes
RhostsRSAAuthentication no
HostbasedAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
PasswordAuthentication yes
X11Forwarding yes
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
#UseLogin no
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
UsePAM yes" > /etc/ssh/sshd_config
}

if [ -e "$abobora$verde" ] ; then
echo -e "\033[1;32mPort 80 OK √ \033[0m"
history -c
else
echo -e "\033[1;31mBaixando arquivos para porta 80...\033[0m"
wget https://www.dropbox.com/s/7jaj26xjb6c655p/proxy80.py > /dev/null 2> /dev/null
history -c
fi

if [ -e "$abobora$rosa" ] ; then
echo -e "\033[1;32mPort 8080 OK √ \033[0m"
history -c
else
echo -e "\033[1;31mBaixando arquivos para porta 8080...\033[0m"
wget https://www.dropbox.com/s/hgwn9esvgchozyk/proxy8080.py > /dev/null 2> /dev/null
history -c
fi

if [ -e "$abobora$preto" ] ; then
echo -e "\033[1;32mPort 8799 OK √ \033[0m"
history -c
else
echo -e "\033[1;31mBaixando arquivos para porta 8799...\033[0m"
wget https://www.dropbox.com/s/q24h7hmp41cprvn/proxy8799.py > /dev/null 2> /dev/null
history -c
fi

sshd_config


if [ -e "$abobora$azul" ] ; then
echo -e "\033[1;32mPort 3128 OK √ \033[0m"
history -c
else
echo -e "\033[1;31mBaixando arquivos para porta 3128...\033[0m"
wget https://www.dropbox.com/s/3u2mpj62ltaarhc/proxy3128.py > /dev/null 2> /dev/null
history -c
fi

sleep 2

echo ""

echo -e "\033[1;31mATENÇÃO! \033[0m"
echo ""
echo -e "\033[1;36mAo continuar, você aceita que: \n\nEstará ciente que o SQUID Proxy será desativado. \033[0m"

sleep 2

echo ""

echo -e "\033[1;31mRESPONDA ALGUMAS PERGUNTAS \033[0m"
echo ""

echo -e "\033[1;32mAbrir porta 80? \033[0m"
read -p "[s/n]: " -e -i s port80

echo -e "\033[1;32mAbrir porta 8080? \033[0m"
read -p "[s/n]: " -e -i s port8080

echo -e "\033[1;32mAbrir porta 8799? \033[0m"
read -p "[s/n]: " -e -i s port8799

echo -e "\033[1;32mAbrir porta 3128? \033[0m"
read -p "[s/n]: " -e -i s port3128

service squid3 stop > /dev/null 2> /dev/null
service squid stop > /dev/null 2> /dev/null
service ssh restart > /dev/null 2> /dev/null
service sshd restart > /dev/null 2> /dev/null

if [[ "$port80" = 's' ]]; then
chmod a+x proxy80.py && nohup python proxy80.py > proxy80.txt &
fi

if [[ "$port8080" = 's' ]]; then
chmod a+x proxy8080.py && nohup python proxy8080.py > proxy8080.txt &
fi


if [[ "$port8799" = 's' ]]; then
chmod a+x proxy8799.py && nohup python proxy8799.py > proxy8799.txt &
fi


if [[ "$port3128" = 's' ]]; then
chmod a+x proxy3128.py && nohup python proxy3128.py > proxy3128.txt &
fi
echo ""
echo -e "\033[1;32mTudo pronto! \n\nTwoSSH \033[0m"
