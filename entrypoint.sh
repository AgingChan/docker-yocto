#!/bin/bash

# first check if environment variable be set or not
if [ -z "${USER}" ]; then
  echo "ERROR: We need USER to be set!"; exit 100
fi

if [ -z "${HOST_UID}" ]; then
    echo "ERROR: We need HOST_UID be set" ; exit 100
fi

if [ -z "${HOST_GID}" ]; then
    echo "ERROR: We need HOST_GID be set" ; exit 100
fi

# reset user_?id to either new id or if empty old (still one of above
# might not be set)
USER_UID=${HOST_UID:=$UID}
USER_GID=${HOST_GID:=$GID}

# Create user
useradd ${USER} --shell /bin/bash --create-home \
	--uid ${USER_UID} --gid ${USER_GID}

echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers

chown -R ${USER_UID}:${USER_GID} /home/${USER}

exec su "${USER}"