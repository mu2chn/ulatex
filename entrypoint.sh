#!/bin/bash

# create user
USERHOME=/home/user
USERNAME=user
echo "Starting with UID : ${USER_ID:=1000}, GID: ${GROUP_ID:=1000}"
groupadd ${USERNAME} -g ${GROUP_ID} && \
useradd -u ${USER_ID} -g ${GROUP_ID} -d ${USERHOME} -m -s /bin/bash -G sudo ${USERNAME}

chown ${USERNAME} /tex

echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
# sudo時にPATHを引き継ぐ
sed -i '/Defaults.*secure_path.*/d' /etc/sudoers && \
echo 'Defaults  env_keep += "PATH"' >> /etc/sudoers

if [ "$1" != "" ]; then
    exec /usr/sbin/gosu ${USERNAME} "$@"
else
    exec /usr/sbin/gosu ${USERNAME} bash
fi
