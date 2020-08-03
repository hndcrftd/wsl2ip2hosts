#!/usr/bin/env bash

# Source: https://github.com/hndcrftd/wsl2ip2hosts
# Copyright: 2020 hndcrftd
# Licensed under MIT (https://github.com/hndcrftd/wsl2ip2hosts/blob/master/LICENSE)

# Add hostip as a command in case we want to see our Windows IP in WSL
alias hostip='tail -1 /etc/resolv.conf | cut -d" " -f2' 2>/dev/null

# set this to 1 to add Windows IP to linux /etc/hosts or 0 to skip this
addwiniptohosts=1

if [[ $addwiniptohosts -eq 1 ]]
then
	# Replace old Windows IP with the current one in our local /etc/hosts
	HOSTIP=$(hostip)
	# The following is what you name your Windows machine
	HOSTDOMAIN="windowshost.local"
	if grep $HOSTDOMAIN /etc/hosts
	then
		# if the domain name is in /etc/hosts - replace it
		sed -i "/$HOSTDOMAIN/ s/.*/$HOSTIP\t$HOSTDOMAIN/" /etc/hosts
	else
		# if not - add it
		echo "$HOSTIP\t$HOSTDOMAIN" >> /etc/hosts
	fi
fi

# IP for this WSL2 instance to be included in Windows hosts file
alias wslip='ip -4 a show eth0 | grep -Po "inet \K[0-9.]*"' 2>/dev/null
WSLIP=$(wslip)

# check if our current IP is in the windows hosts file (we can read it but not write to it)
# wslpath command converts from Windows path to a WSL path. We want this in case the drive letter for boot drive is not C:
grep $WSLIP $(wslpath '/Windows')/System32/drivers/etc/hosts
# if it's in there grep returns 0, if not it's 1
if [[ $? -eq 1 ]]
then
	# if we have the new PowerShellCore - use it, it's faster, if not - fallback on the old one
	which pwsh.exe > /dev/null 2>&1 && PS="pwsh" || PS="powershell"
	$PS.exe -Command 'start-process -verb runas '$PS' -ArgumentList "-Command &{~\wsl2ip2winhosts.ps1 '$WSLIP'}"'
fi

# set this to 1 to start httpd on WSL start or 0 to skip
starthttpd=1
# add /run/httpd to allow httpd to start... and allow httpd to start conditionally
if [ ! -d "/run/httpd" ]
then
    mkdir /run/httpd
    chmod 777 /run/httpd # beccause httpd can run as different user on different distros
    if [[ $starthttpd -eq 1 ]]; then httpd -k start; fi;
fi
