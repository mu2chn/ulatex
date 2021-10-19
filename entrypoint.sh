#!/bin/bash

# 指定された環境変数でuser&group切り替え
sudo usermod -d ${HOME} -u ${USER_ID:-1000} -o -m ${USER}
sudo groupmod -g ${GROUP_ID:-1000} ${USER}
sudo chown ${USER} /tex

if [ "$1" != "" ]; then
    exec "$@"
fi

cat