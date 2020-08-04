#!/usr/bin/env bash

# Source: https://github.com/hndcrftd/wsl2ip2hosts
# Copyright: 2020 hndcrftd
# Licensed under MIT (https://github.com/hndcrftd/wsl2ip2hosts/blob/master/LICENSE)

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

# [[ -d ./etc/profile.d/ ]] || mkdir -p ./etc/profile.d/
echo "$ips2hosts" > /etc/profile.d/ips2hosts.sh
chmod +x /etc/profile.d/ips2hosts.sh

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
chmod +x ~/wsl2ip2winhosts.ps1

echo "Populating IPs, this will take a few seconds..."
bash /etc/profile.d/ips2hosts.sh > /dev/null 2>&1
if [[ $? -eq 0 ]]
then
	echo "Installation completed. The following entries are now in effect:"

	if [[ ! -z $windowshost ]]; then
		hostip > /dev/null 2>&1 && echo "$(hostip) $windowshost"
	fi

	wslip > /dev/null 2>&1 && echo "$(wslip) $wslhost"
else
	echo "Installation completed. Shutdown and restart your distribution to populate hosts file."
fi
