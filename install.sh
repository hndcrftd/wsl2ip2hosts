#!/usr/bin/env bash

# Source: https://github.com/hndcrftd/wsl2ip2hosts
# Copyright: 2020 hndcrftd
# Licensed under MIT (https://github.com/hndcrftd/wsl2ip2hosts/blob/master/LICENSE)

if [[ $EUID != 0 ]]; then
    sudo "$0" "$@"
    exit $?
fi

ips2hosts=$(curl -s https://raw.githubusercontent.com/hndcrftd/wsl2ip2hosts/master/ips2hosts.sh)
wsl2ip2winhosts=$(curl -s https://raw.githubusercontent.com/hndcrftd/wsl2ip2hosts/master/wsl2ip2winhosts.ps1)

read -p "Would you like to add your Windows IP to your WSL /etc/hosts? [y/n] (default: y) :" input
if [[ $input == 'n' ]]
then
	ips2hosts=${ips2hosts/addwiniptohosts=1/addwiniptohosts=0}
else
	echo
	read -er -p "Enter hostname for Windows (default: windowshost.local) :" windowshost
	if [[ ! -z $windowshost ]]
	then
		ips2hosts=${ips2hosts/windowshost.local/$windowshost}
	else
		windowshost='windowshost.local'
	fi
fi
echo
read -er -p "Would you like to start httpd web server when WSL starts? [y/n] (default: y) :" httpdautostart
if [[ $httpdautostart == 'n' ]]
then
	ips2hosts=${ips2hosts/starthttpd=1/starthttpd=0}
fi

homefolderscript="$(echo ~)/ips2hosts.sh"
echo "$ips2hosts" > "$homefolderscript"
chmod +x "$homefolderscript"
echo "sudo $homefolderscript" > /etc/profile.d/runips2hosts.sh
chmod +x /etc/profile.d/runips2hosts.sh
#add sudo permissions for script ~/ips2hosts.sh to /etc/sudoers.d folder in a file ips2hosts
printf "ALL\tALL=(root) NOPASSWD: $homefolderscript\n" > /etc/sudoers.d/ips2hosts
chown root:root /etc/sudoers.d/ips2hosts
chmod 0440 /etc/sudoers.d/ips2hosts
grep '#includedir /etc/sudoers.d' /etc/sudoers > /dev/null 2>&1 || sudo sh -c "echo \"#includedir /etc/sudoers.d\" >> /etc/sudoers"

echo
echo "For your WSL enter a hostname or multiple, separated by space"
read -er -p ":" wslhost
while [[ -z $wslhost ]]; do
	echo "Hostname may not be blank. Enter WSL hostname or multiple, separated by space"
	read -er -p ":" wslhost
done
echo

wsl2ip2winhosts=${wsl2ip2winhosts/wslfqdn.local/$wslhost}

echo "$wsl2ip2winhosts" > ~/wsl2ip2winhosts.ps1
chmod 0777 ~/wsl2ip2winhosts.ps1

echo "Populating IPs, this will take a few seconds..."
sudo ~/ips2hosts.sh > /dev/null 2>&1
if [[ $? -eq 0 ]]
then
	echo "Installation completed. The following entries are now in effect:"
	echo "$(tail -1 /etc/resolv.conf | cut -d' ' -f2) $windowshost"
	echo "$(ip -4 a show eth0 | grep -Po --color=never 'inet \K[0-9.]*') $wslhost"
else
	echo "Installation completed. Shutdown and restart your distribution to populate hosts file."
fi
