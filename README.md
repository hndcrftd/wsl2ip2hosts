# wsl2ip2hosts

WSL2 assigns different IPs to itself and the Windows host system every time it (re)starts.

**This solution automatically updates WSL2 IP in the Windows C:\Windows\system32\drivers\etc\hosts on WSL start.**

Optionally it updates its own /etc/hosts with the Windows IP.

Optionally it starts httpd (and creates /run/httpd which gets cleared on every shutdown) so you can get right to development without having to start services manually. (I needed this for WSL2 Centos7 box. You may not need it, or you may want to execute different services, like apache2, so feel free to modify that script for your needs after installation.)

The install script places 2 other scripts on your system and asks you for hostnames, as well as other configuration details.

### TL;DR:

To install the scripts automatically, copy and run the following commands in your selected WSL Linux distribution bash:
```
cd ~;\
curl -s https://raw.githubusercontent.com/hndcrftd/wsl2ip2hosts/master/install.sh > wsl2ip2hosts.install.sh;\
chmod +x wsl2ip2hosts.install.sh;\
sudo PATH="$PATH" ~/wsl2ip2hosts.install.sh
```
Yes, you can copy and paste the whole block at once.  
The script will walk you through the installation, i.e. setting up optional actions and selecting which hostnames you want to assign to WSL and Windows.  
You can (and should) look at the content of the install.sh script either on github or after curl request. It grabs the bash and powershell files from github and replaces the hostnames and conditional variables with what you set during the prompts.  
At the end of installation the scripts will be attempted to run and you may see the changes in your hosts files immediately.  
When the script runs on WSL or Distro start you will see 2 PowerShell windows briefly opening and closing. This is normal behavior.  
There is no way to edit the Windows hosts file from WSL bash, even as root, but running PowerShell as Administrator does the job, hence 2 scripts.  
Once installed, the settings and hostnames persist and to change them you can either re-run the install script (the last command from the block above) or edit the generated scripts manually.  
As of this time you **cannot** have separate WSL hostname per distro as distros reuse the same WSL IP when ran concurrently so make sure same services in different distros don't listen on same ports.  
This means you can run the install script on all of your distros, just use the same hostname(s) for WSL. Windows host machine domains **can** be different per distro (if needed) as they are saved in the distro's /etc/hosts file.  
This only affects people who run two or more distros concurrently. Perhaps in the future Microsoft can fix that.

**Note: This has been tested on Centos7 and Ubuntu 18.04 WSL2 images that are available at this time. If running into problems - feel free to open issues but provide as much info as possible about your distro and the nature of the issue. Thank you.**

You will have two new commands (aliases) in your distro bash for convenience:  
- `wslip` - shows your WSL current IP address  
- `hostip` - shows Windows (host machine) IP address

---
Feel free to modify the scripts to fit your needs.

After you run the installation you can create a convenient shortcut to start WSL default distro in the background and populate the *hosts* files without having to open a new command window if you don't need it:  
>Right-click on your Desktop (or within any folder empty area) and select *New > Shortcut*  
>In the target field paste the following: `bash /etc/profile.d/runips2hosts.sh`  
>Click *Next* and name your shortcut.  

Windows will expand _bash_ to include the full path automatically, so it will become C:\Windows\System32\bash.exe, or you can explicitly type that in when making the shortcut.

As an option, if you do make the shortcut, you can even have it run on Windows boot, in case most of your work depends on WSL2.

If you are also running docker and allowed it to run on boot and integrate with WSL2 in the settings, your default distro will be initialized on boot and you don't need the shortcut. I have ran into issues accessing web server in my distros (on port 80) when docker desktop is running and quitting docker desktop seems to help.

I also have a shortcut that performs `wsl --shutdown`, however, in my experience, I can leave it running indefinitely and it resumes perfectly fine if I put Windows to Sleep or Hybernate.  
The shutdown is for cases when you are rebooting or turning the computer off.

A lot of research and debugging went into this project to make it work specifically for Ubuntu (damn you, sudo!), Centos was done in an evening, after taming PowerShell (tripple command execution in one line with bash expansions, double nested quotes, and escaping spaces in windows paths, and multiple ways of doing each, oh holy cat, don't you love dev work!?). In any case, I hope this saves someone some time and headache and gets more people on board with WSL2. It's got its quirks, sure, but it's a way more efficient full Linux dev environment than any virtualization solutions. Your computer will thank you.


-Jakob Wildrain (hndcrftd)
