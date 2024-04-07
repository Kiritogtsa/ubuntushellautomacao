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
main() {
    local arquivo="/home/$user/shhconf.txt"
    if [ -e $arquivo ]; then
        user_ip=$(cat "$arquivo")
        userssh=$(echo "$user_ip" | cut -d ' ' -f1)
        ipserv=$(echo "$user_ip" | cut -d ' ' -f2)
        if ping -c 1 $ipserv >/dev/null 2>&1; then
            sshconf=$userssh"@"$ipserv
            verificarsshbackup "$user_ip"
            if [ ${#array[@]} -gt 0 ]; then
                readarray -t array <<<"files"
                vericaremover "${array[@]}" $sshconf $userssh
            fi
            fazerbackup $sshconf $userssh
        else
            echo "nao ta ativo"
            echo $user"@"$ipserv
        fi
    fi
}
main
