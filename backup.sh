#!/usr/bin/env bash
data=$(date "+%d-%m-%Y")
user=$(whoami)
arquivopath="/home/$user/pathsbackuo.txt"
# patha="/home/$user/a"
retornapaths() {
    local caminhos=()
    while IFS= read -r linha; do
        caminhos+=("$linha")
    done <"$1"
    echo "${caminhos[@]}"
}

# faço uma main com menu?

# verificar() {
#     if [ ! -d $patha ];then
#         mkdir $patha
#     fi
# }

# copyordelete() {
#     verificar
#     local comando="$1"
#     local caminhos=("${@:2}")
#     for pasta in "${caminhos[@]}"; do
#         echo "Caminho: $pasta"  # Adiciona instrução de depuração
#         if [ -e "$pasta" ] && [ "$1" == "cp" ]; then
#             cp -r "$pasta" "$patha"
#         elif [ "$1" == "rm" ] ;then
#             rm -r "$patha"
#         else
#             echo "O diretório ou arquivo '$pasta' não existe."
#         fi
#     done
# }

# path=($(retornapaths "$arquivopath"))

# copyordelete "cp" "${path[@]}"
# echo $(ls $patha)
# copyordelete "rm" "${path[@]}"
# echo $(cat $patha)
vericaremover() {
    for linha in $1; do
        dataarquivo=$(echo "$linha" | cut -d'-' -f2)
        diferenca=$((($(date -d "$dataarquivo" +%s) - $(date -d "$data" +%s)) / 86400))
        if [ $diferenca -gt 3 ]; then
            ssh $2 "rm -r /home/$3/backup/$linha"
        fi
    done
}
fazerbackup() {
    paths=($(retornapaths "$arquivopath"))
    tar -zcvf "backup_$data.tar.gz" "${paths[@]}"
    scp "/home/$user/backup_$data.tar.gz" $1:/home/$2/backup
    rm "/home/$user/backup_$data.tar.gz"
}
verificarsshbackup() {
    pasta= $(ssh $1 "cat bakup")
    if [ "$pasta" != "cat: backup: É um diretório" ]; then
        ssh $1 "mkdir bakup"
    fi
}
vericarconexao() {
        if ping -c 1 $1 >/dev/null 2>&1; then
            return 0
        else
            return 1
        fi
}
verificarstring() {
    arquivo
    while IFS= read -r line;do
        if [ $line == $1 ];then
            return 0
        fi
    done <$arquivopath;
    return 1
}


# adicionar() {
#     echo $(ls)
#     read -p " 1=entra na pasta, 2=adiciona a pasta atual, 3=escolha um arquivo" input
#     pasta=$arquivopath
#     if [ $input -eq 1 ];then
#         echo $(ls) 
#         read -p " qual pasta: " pasta
#         cd $pasta 
#         if $?;then
#             adicionar
#         else 
#          echo " digite certo "
#          adicionar
#         fi
#     elif [ $input -eq 2 ];then
#         caminho=$(pwd)
#         echo $caminho >> $pasta
#     elif [ $input -eq 3 ];then
#         read -ṕ "nome do arquivo: " file
#         caminho=$(pwd)/$file
#         if [ -e $caminho ];then
#             echo $caminho >> $pasta
#         fi
#     fi
# }
# remover() {
#     pasta=(${retornapaths $arquivopath})
#     count=1
#     for path in $pasta;do    
#       echo "$path + $count"
#       count+=1
#     done
#     read -p " escolha um caminho para remover: numero" numer
#     sed """$numer""d" "$arquivopath"
    
# }
# menu() {
#     case $i in 
#         0) adicionar
#             main;;
#         1) 
#             remover
#             main;;
#         *) echo "invalida";;
#     esac

# }
#  local arquivo="/home/$user/shhconf.txt"
#     if [ -e $arquivo ]; then
#         user_ip=$(cat "$arquivo")
#         userssh=$(echo "$user_ip" | cut -d ' ' -f1)
#         ipserv=$(echo "$user_ip" | cut -d ' ' -f2)
#         if vericarconexao $user_ip;then
#             sshconf=$userssh"@"$ipserv
#             verificarsshbackup "$user_ip"
#             if [ ${#array[@]} -gt 0 ]; then
#                 readarray -t array <<<"files"
#                 vericaremover "${array[@]}" $sshconf $userssh
#             fi
#             fazerbackup $sshconf $userssh
#         else
#             echo "nao ta ativo"
#             echo $user"@"$ipserv
#         fi
#     fi
main() {
    local arquivo="/home/$user/shhconf.txt"
    if [ -e $arquivo ]; then
        user_ip=$(cat "$arquivo")
        userssh=$(echo "$user_ip" | cut -d ' ' -f1)
        ipserv=$(echo "$user_ip" | cut -d ' ' -f2)
        if vericarconexao $ipserv;then
            sshconf=$userssh"@"$ipserv
            verificarsshbackup "$user_ip"
            if [ ${#array[@]} -gt 0 ]; then
                readarray -t array <<<"files"
                vericaremover "${array[@]}" $sshconf $userssh
            fi
            fazerbackup $sshconf $userssh
        else
            echo "nao ta ativo"
        fi
    fi
}
# main() {
#     local arquivo="/home/$user/shhconf.txt"
#     if [ -e $arquivo ]; then
#          user_ip=$(cat "$arquivo")
#         userssh=$(echo "$user_ip" | cut -d ' ' -f1)
#         ipserv=$(echo "$user_ip" | cut -d ' ' -f2)
#         if vericarconexao $user_ip;then
#             choice=$(--title "Main Menu" \
#                   --menu "Choose an action:" 10 60 3 \
#                   --item "adicionar pasta/arquivo" 0 \
#                   --item "iniciar o backup" 1 \
#                   --item "sair" 2 3)
#             menu $choice
            
#         fi
#     fi
# }
main
