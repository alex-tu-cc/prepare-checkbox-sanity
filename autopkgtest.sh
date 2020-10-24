#!/bin/bash

cat << EOF > auto.sh
#!/bin/bash
set -x
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export LANGUAGE=C:

install_pkgs ()
{
    for pkg in "\$@"; do
        if ! dpkg-query -W -f='\${Status}\n' "\$pkg" | grep "install ok installed"; then
            apt-get install "\$pkg" --yes
        fi
    done
}

install_pkgs gpg apt-transport-https software-properties-common

create_source_list ()
{
    echo "\$*" | tr "|" "\n" | while read -r line; do
        NAME=\$(echo "\$line" | awk '{print \$1}')
        URL=\$(echo "\$line" | awk '{print \$2}')
        KEY=\$(echo "\$line" | awk '{print \$3}')
        apt-key adv --keyserver keyserver.ubuntu.com --recv-key "\$KEY"
        echo "deb \$URL \$(lsb_release -cs) main" > "/etc/apt/sources.list.d/\$NAME-\$(lsb_release -cs).list"
        echo "# deb-src \$URL \$(lsb_release -cs) main" >> "/etc/apt/sources.list.d/\$NAME-\$(lsb_release -cs).list"
    done
}

sudo add-apt-repository -y ppa:checkbox-dev/ppa
EOF

if [ "build" = "$1" ]; then
    MIRROR=http://tw.archive.ubuntu.com/ubuntu/  sudo -E autopkgtest-build-lxc ubuntu focal amd64 auto.sh
else
    sudo autopkgtest --shell-fail -- lxc autopkgtest-focal-amd64
fi

