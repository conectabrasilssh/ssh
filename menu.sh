#!/bin/bash
fun_bar () {
comando[0]="$1"
comando[1]="$2"
 (
[[ -e $HOME/fim ]] && rm $HOME/fim
${comando[0]} -y > /dev/null 2>&1
${comando[1]} -y > /dev/null 2>&1
touch $HOME/fim
 ) > /dev/null 2>&1 &
 tput civis
echo -ne "\033[1;33m["
while true; do
   for((i=0; i<18; i++)); do
   echo -ne "\033[1;31m#"
   sleep 0.1s
   done
   [[ -e $HOME/fim ]] && rm $HOME/fim && break
   echo -e "\033[1;33m]"
   sleep 1s
   tput cuu1
   tput dl1
   echo -ne "\033[1;33m["
done
echo -e "\033[1;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
tput cnorm
}
x="ok"
menu ()
{
velocity () {
aguarde () {
comando[0]="$1"
comando[1]="$2"
 (
[[ -e $HOME/fim ]] && rm $HOME/fim
${comando[0]} -y > /dev/null 2>&1
${comando[1]} -y > /dev/null 2>&1
touch $HOME/fim
 ) > /dev/null 2>&1 &
 tput civis
echo -ne "  \033[1;33mAGUARDE \033[1;37m- \033[1;33m["
while true; do
   for((i=0; i<18; i++)); do
   echo -ne "\033[1;31m#"
   sleep 0.1s
   done
   [[ -e $HOME/fim ]] && rm $HOME/fim && break
   echo -e "\033[1;33m]"
   sleep 1s
   tput cuu1
   tput dl1
   echo -ne "  \033[1;33mAGUARDE \033[1;37m- \033[1;33m["
done
echo -e "\033[1;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
tput cnorm
}
fun_tst () {
speedtest --share > speed
}
echo ""
echo -e "   \033[1;32mTESTANDO A VELOCIDADE DO SERVIDOR !\033[0m"
echo ""
aguarde 'fun_tst'
echo ""
png=$(cat speed | sed -n '5 p' |awk -F : {'print $NF'})
down=$(cat speed | sed -n '7 p' |awk -F :  {'print $NF'})
upl=$(cat speed | sed -n '9 p' |awk -F :  {'print $NF'})
lnk=$(cat speed | sed -n '10 p' |awk {'print $NF'})
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;32mPING (LATENCIA):\033[1;37m$png"
echo -e "\033[1;32mDOWNLOAD:\033[1;37m$down"
echo -e "\033[1;32mUPLOAD:\033[1;37m$upl"
echo -e "\033[1;32mLINK: \033[1;36m$lnk\033[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
rm -rf $HOME/speed
}
menu2 (){
source /etc/SSHPlus/cabecalho
echo ""
echo -e "\033[1;33m[\033[1;31m20\033[1;33m] ADICIONAR HOST \033[1;33m       [\033[1;31m26\033[1;33m] MUDAR SENHA ROOT \033[1;33m
[\033[1;31m21\033[1;33m] REMOVER HOST \033[1;33m         [\033[1;31m27\033[1;33m] ATUALIZAR SCRIPT \033[1;33m
[\033[1;31m22\033[1;33m] REINICIAR SISTEMA \033[1;33m    [\033[1;31m28\033[1;33m] REMOVER SCRIPT \033[1;33m
[\033[1;31m23\033[1;33m] REINICIAR SERVICOS \033[1;33m   [\033[1;31m29\033[1;33m] AJUDA \033[1;33m
[\033[1;31m24\033[1;33m] BLOCK TORRENT \033[1;33m        [\033[1;31m30\033[1;33m] VOLTAR \033[1;32m<\033[1;33m<\033[1;31m< \033[1;33m
[\033[1;31m25\033[1;33m] BOT TELEGRAM \033[1;33m         [\033[1;31m00\033[1;33m] SAIR \033[1;32m<\033[1;33m<\033[1;31m<\033[1;33m"
echo ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo -ne "\033[1;32mOQUE DESEJA FAZER \033[1;33m?\033[1;31m?\033[1;37m "; read x
case "$x" in
   20)
   clear
   addhost
   echo -ne "\n\033[1;31mENTER \033[1;33mpara retornar ao \033[1;32mMENU!\033[0m"; read
   menu2
   ;;
   21)
   clear
   delhost
   echo -ne "\n\033[1;31mENTER \033[1;33mpara retornar ao \033[1;32mMENU!\033[0m"; read
   menu2
   ;;
   22)
   clear
   reiniciarsistema
   ;;
   23)
   clear
   reiniciarservicos
   sleep 3
   ;;
   24)
   blockt
   ;;
   25)
   botssh
   ;;
   26)
   clear
   senharoot
   sleep 3
   ;;
   27)
   attscript
   exit
   ;;
   28)
   clear
   delscript
   ;;
   29)
   ajuda
   echo -ne "\n\033[1;31mENTER \033[1;33mpara retornar ao \033[1;32mMENU!\033[0m"; read
   ;;
   30)
   menu
   ;;
   0|00)
   echo -e "\033[1;31mSaindo...\033[0m"
   sleep 2
   clear
   exit;
   ;;
   *)
   echo -e "\n\033[1;31mOpcao invalida !\033[0m"
   sleep 2
esac
}
while true $x != "ok"
do
source /etc/SSHPlus/cabecalho
echo ""
echo -e "\033[1;33m[\033[1;31m01\033[1;33m] CRIAR USUARIO \033[1;33m              [\033[1;31m11\033[1;33m] SPEEDTEST \033[1;33m
[\033[1;31m02\033[1;33m] CRIAR USUARIO TESTE \033[1;33m        [\033[1;31m12\033[1;33m] BANNER \033[1;33m
[\033[1;31m03\033[1;33m] REMOVER USUARIO \033[1;33m            [\033[1;31m13\033[1;33m] TRAFEGO \033[1;33m
[\033[1;31m04\033[1;33m] MONITOR ONLINE \033[1;33m             [\033[1;31m14\033[1;33m] OTIMIZAR \033[1;33m
[\033[1;31m05\033[1;33m] MUDAR DATA \033[1;33m                 [\033[1;31m15\033[1;33m] BACKUP \033[1;33m
[\033[1;31m06\033[1;33m] ALTERAR LIMITE \033[1;33m             [\033[1;31m16\033[1;33m] TCP SPEED \033[1;33m
[\033[1;31m07\033[1;33m] MUDAR SENHA \033[1;33m                [\033[1;31m17\033[1;33m] BAD VPN \033[1;33m
[\033[1;31m08\033[1;33m] REMOVER EXPIRADOS \033[1;33m          [\033[1;31m18\033[1;33m] INFO VPS \033[1;33m
[\033[1;31m09\033[1;33m] RELATORIO DE USUARIOS \033[1;33m      [\033[1;31m19\033[1;33m] MAIS \033[1;32m>\033[1;33m>\033[1;31m>\033[0m\033[1;33m
[\033[1;31m10\033[1;33m] MODO DE CONEXAO \033[1;33m            [\033[1;31m00\033[1;33m] SAIR \033[1;32m<\033[1;33m<\033[1;31m<\033[0m \033[0m"
echo ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo -ne "\033[1;32mOQUE DESEJA FAZER \033[1;33m?\033[1;31m?\033[1;37m "; read x

case "$x" in 
   1 | 01)
   clear
   criarusuario
   echo -ne "\n\033[1;31mENTER \033[1;33mpara retornar ao \033[1;32mMENU!\033[0m"; read
   ;;
   2 | 02)
   clear
   criarteste
   echo -ne "\n\033[1;31mENTER \033[1;33mpara retornar ao \033[1;32mMENU!\033[0m"; read
   ;;
   3 | 03)
   clear
   remover
   sleep 3
   ;;
   4 | 04)
   clear
   sshmonitor
   echo -ne "\n\033[1;31mENTER \033[1;33mpara retornar ao \033[1;32mMENU!\033[0m"; read
   ;;      
   5 | 05)
   clear
   mudardata
   sleep 3
   ;;
   6 | 06)
   clear
   alterarlimite
   sleep 3
   ;; 
   7 | 07)
   clear
   alterarsenha
   sleep 3
   ;;
   8 | 08)
   clear
   expcleaner
   echo ""
   sleep 3
   ;;     
   9 | 09)
   clear
   infousers
   echo -ne "\n\033[1;31mENTER \033[1;33mpara retornar ao \033[1;32mMENU!\033[0m"; read
   ;;
   10)
   conexao
   exit;
   ;;
   11)
   clear
   velocity
   echo -ne "\n\033[1;31mENTER \033[1;33mpara retornar ao \033[1;32mMENU!\033[0m"; read
   ;;
   12)
   clear
   banner
   sleep 3
   ;;
   13)
   clear
   echo -e "\033[1;32mPARA SAIR CLICK CTRL + C\033[1;36m"
   sleep 4
   nload
   ;;
   14)
   clear
   otimizar
   echo -ne "\n\033[1;31mENTER \033[1;33mpara retornar ao \033[1;32mMENU!\033[0m"; read
   ;;
   15)
   userbackup
   echo -ne "\n\033[1;31mENTER \033[1;33mpara retornar ao \033[1;32mMENU!\033[0m"; read
   ;;
   16)
   tcpspeed
   sleep 2
   ;;
   17)
   clear
   badvpn
   exit;
   ;;
   18)
   clear
   detalhes
   echo -ne "\n\033[1;31mENTER \033[1;33mpara retornar ao \033[1;32mMENU!\033[0m"; read
   ;;
   19)
   menu2
   ;;
   0 | 00)
   echo -e "\033[1;31mSaindo...\033[0m"
   sleep 2
   clear
   exit;
   ;;
   *)
   echo -e "\n\033[1;31mOpcao invalida !\033[0m"
   sleep 2
esac
done
}
menu
#fim
