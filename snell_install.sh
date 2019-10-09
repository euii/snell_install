#! /bin/bash
snell_file_name='snell-server-v1.1.1-linux-amd64.zip'
snell_systemd_conf='https://raw.githubusercontent.com/surge-networks/snell/master/systemd-example'
unzip_file='snell-server'
bin_dic='/usr/local/bin'

create_systemd_service() {

 if [[ ! -f '/etc/snell-server.conf' && -f '/usr/local/bin/snell-server.conf' ]]; then
    ln -s /usr/local/bin/snell-server.conf /etc/snell-server.conf
 fi
 cd /etc/systemd/system
 wget -O snell.service ${snell_systemd_conf}
 systemctl enable snell.service
 systemctl start snell.service
}

rm -rf ${unzip_file}*
wget https://github.com/surge-networks/snell/releases/download/v1.1.1/${snell_file_name}
if [[ -f ${snell_file_name} ]]; then
  unzip ${snell_file_name}
  mv -f $PWD/${unzip_file} ${bin_dic}

  if [[ -f '/usr/local/bin/snell-server.conf' ]]; then

    create_systemd_service
    cat /etc/snell-server.conf
  else
    echo 'snell conf is not exist, Initializing...'
    cd ${bin_dic}
    ${bin_dic}/${unzip_file}
    wait
    create_systemd_service
  fi
else
  echo 'file is not exist.'
fi

