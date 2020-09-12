# wsl2ip2hosts

**Note: This was initially made for Centos where you login as root and I tried making adjustments so it would also run under Ubuntu where you don't login as root and need to run the script as sudo. At the moment the issue is - neither cmd.exe not pwsh.exe can be found by Ubuntu when invoked under sudo. Without sudo (if you login to your distro as root) things work great. I'm still researching solutions. Feel free to suggest yours.**

WSL2 assigns different IPs to itself and the Windows host system every time it (re)starts.

**This solution automatically updates WSL2 IP in the Windows C:\Windows\system32\drivers\etc\hosts on WSL start.**

Optionally it updates its own /etc/hosts with the Windows IP.

Optionally it starts httpd (and creates /run/httpd which gets cleared on every shutdown) so you can get right to development without having to start services manually. (I needed this for WSL2 Centos7 box. You may not need it, or you may want to execute different services, like apache2, so feel free to modify that script for your needs after installation.)

The install script places the batch files on your system and asks you for hostnames, as well as other configuration details.

### TL;DR:

To install the scripts automatically, copy and run the following commands in your selected WSL Linux distribution bash:
```
cd ~;\
curl -s https://raw.githubusercontent.com/hndcrftd/wsl2ip2hosts/master/install.sh > wsl2ip2hosts.install.sh;\
chmod +x wsl2ip2hosts.install.sh;\
sudo ./wsl2ip2hosts.install.sh
```
Yes, you can copy and paste the whole block at once.  
The script will walk you through the installation, i.e. setting up optional actions and selecting which hostnames you want to assign to WSL and Windows.  
You can (and should) look at the content of the install.sh script either on github or after curl request. It grabs the bash and powershell files from github and replaces the hostnames and conditional variables with what you set during the prompts.  
At the end of installation the scripts will be attempted to run and you may see the changes in your hosts files immediately.  
If you are not logged in as root (as in Ubuntu, or other scenarios) you will need to log out and log back in to your distro, at which point the scripts should run. This is because the sudoers file needs to be reloaded.  
Once installed, the settings persist and to change them you can either re-run the install script or edit the generated scripts manually.  
You can have separate settings per distro.

You will have two new commands (aliases) in your distro bash for convenience:  
- `wslip` - shows your WSL current IP address  
- `hostip` - shows Windows (host machine) IP address

---
Feel free to modify the scripts to fit your needs.

After you run the installation you can create a convenient shortcut to start WSL default distro in the background and populate the *hosts* files without having to open a new command window if you don't need it:  
>Right-click on your Desktop (or within any folder empty area) and select *New > Shortcut*  
>In the target field paste the following: `bash /etc/profile.d/runip2hosts.sh`  
>Click *Next* and name your shortcut.  

Windows will expand _bash_ to include the full path automatically, so it will become C:\Windows\System32\bash.exe, or you can explicitly type that in when making the shortcut.

If you are also running docker and allowed it to run on boot and integrate with WSL2 in the settings, your default distro will be initialized on boot and you don't need the shortcut.

As an option, if you do make the shortcut, you can even have it run on Windows boot, in case most of your work depends on WSL2.

I also have a shortcut that performs `wsl --shutdown`, however, in my experience, I can leave it running indefinitely and it resumes perfectly fine if I put Windows to Sleep.  
The shutdown is for cases when you are rebooting or turning the computer off.
YMMV

-Jakob Wildrain (hndcrftd)
