# wsl2ip2hosts

WSL2 assigns different IPs to itself and the Windows host system every time it (re)starts.

**This solution automatically updates WSL2 IP in the Windows C:\Windows\system32\drivers\etc\hosts on WSL start.**

Optionally it updates its own /etc/hosts with the Windows IP.

Optionally it starts httpd (and creates /run/httpd which gets cleared on every shutdown) so you can get right to development without having to start services manually.

And it does all that with a couple of simple bash and powershell commands.

### TL;DR:

To install the scripts automatically, run the following commands in your selected WSL Linux distribution bash:

`cd ~
curl -s https://raw.githubusercontent.com/hndcrftd/wsl2ip2hosts/master/install.sh > wsl2ip2hosts.install.sh
chmod +x wsl2ip2hosts.install.sh
sudo ./wsl2ip2hosts.install.sh`

The script will walk you through the installation, i.e. setting up optional actions and selecting which hostnames you want to assign to WSL and Windows.  
At the end of installation the scripts will be ran and you can see the changes in your hosts files immediately.  
Once installed, the settings persist and to change them you can either re-run the install script or edit the generated scripts manually.  
You can have separate settings per distro.

You will have two new commands (aliases) in your bash for convenience:  
- `wslip` - shows your WSL current IP address  
- `hostip` - shows Windows (host machine) IP address

---
Feel free to modify the scripts to fit your needs.

After you run the installation you can create a convenient shortcut to start WSL default distro in the background and populate the *hosts* files without having to open a new command window if you don't need it:  
>Right-click on your Desktop (or within any folder empty area) and select *New > Shortcut*  
>In the target field paste the following: `bash /etc/profile.d/ip2hosts.sh`  
>Click *Next* and name your shortcut.  

Windows will expand _bash_ to include the full path automatically, so it will become C:\Windows\System32\bash.exe, or you can explicitly type that in

As an option you can even set the above command to run on Windows boot, in case most of your work depends on WSL2.

I also have a shortcut that performs `wsl --shutdown`, however, in my experience, I can leave it running indefinitely and it resumes perfectly fine if I put Windows to Sleep.  
The shutdown is for cases when you are rebooting or turning the computer off.
YMMV

-Jakob Wildrain (hndcrftd)
