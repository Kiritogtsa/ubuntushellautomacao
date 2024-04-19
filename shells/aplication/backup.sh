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

vericaremover() {
    for linha in $1; do
        dataarquivo=$(echo "$linha" | cut -d'-' -f2)
        diferenca=$((($(date -d "$dataarquivo" +%s) - $(date -d "$data" +%s)) / 86400))
        if [ $diferenca -gt 3 ]; then
            ssh $2 "rm -r /home/$3/backup/$linha"
        fi
    done
}

# inicia o backup dos caminhos que tao no arquivo
fazerbackup() {
    # esta variavel recebe um resulta de um funcao que retorna um array em strings de nome caminhos
    paths=($(retornapaths "$arquivopath"))
    tar -zcvf "backup_$data.tar.gz" "${paths[@]}"
    # scp copia o arquivo gerado pelo tar para o servidor
    scp "/home/$user/backup_$data.tar.gz" $1:/home/$2/backup
    # remove o arquivo criado localmente depois de enviar o arquivo para o servidor
    rm "/home/$user/backup_$data.tar.gz"
}
# verica se o servidor tem este caminho, se nao tem ele cria uma pasta
verificarsshbackup() {
    pasta= $(ssh $1 "cat bakup")
    if [ "$pasta" != "cat: backup: É um diretório" ]; then
        ssh $1 "mkdir bakup"
    fi
}

# verifica se o servidor ta ativo retornado um booleano apropriado
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
teste() {
  echo "teste"
}

main
