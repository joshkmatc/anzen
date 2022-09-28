#!/bin/bash
# Root check
if [[ $EUID -ne 0 ]]
then
	echo "[ERR] Run this script as root. To do this, use the sudo command."
	exit
fi

mainUser=${SUDO_USER:-${USER}}
# Backup directory
mkdir -p /home/$mainUser/Desktop/.backups

# User Management
readarray -t users < <(getent passwd | cut -d: -f1 | sort)
uslen=${#users[@]}
echo "### Existing User Changed Passwords ###" >> /home/$mainUser/Desktop/.backups/passwords.txt
for (( i=0;i<$uslen;i++)) 
do
	echo "[INFO] Ignore user ${users[${i}]}? (Do this if it is a system user) (y/n)"
        read ignoreusr
	if [ $ignoreusr == n ] 
	then	
		echo "[INFO] Delete user ${users[${i}]}? (y/n)"
		read deluser 
		if [ $deluser == y ]
		then
			userdel -r ${users[${i}]}
			echo "[INFO] User ${users[${i}]} has been deleted"
		else
			echo "[INFO] Make ${users[${i}]} an admin? (y/n)"
			read admuser
			if [ $admuser == y ]
			then
				gpasswd -a ${users[${i}]} sudo
				gpasswd -a ${users[${i}]} adm
				gpasswd -a ${users[${i}]} lpadmin
				gpasswd -a ${users[${i}]} sambashare
				echo "[INFO] ${users[${i}]} is now an admin."
			else
				gpasswd -d ${users[${i}]} sudo
				gpasswd -d ${users[${i}]} adm
				gpasswd -d ${users[${i}]} lpadmin
				gpasswd -d ${users[${i}]} sambashare
				gpasswd -d ${users[${i}]} root
				echo "[INFO] ${users[${i}]} is now a standard user."	
			fi
			echo "[INFO] Change password for ${users[${i}]}? (y/n)"
			read chpass
			if [ $chpass == y ]
			then
				echo "[INFO] Add custom password for ${users[${i}]}? (y/n)"
				read cpass
				if [ $cpass == y ] 
				then
					echo "Password:"
					read pass
					echo -e "$pass\n$pass" | passwd ${users[${i}]}
					echo "USER: ${users[${i}]} PASS: $pass" >> /home/$mainUser/Desktop/.backups/passwords.txt
					echo "[INFO] The password for ${users[${i}]} has been changed. [CUSTOM]"
				else
					pass="3af32ag45g!!9%"
					echo -e "$pass\n$pass" | passwd ${users[${i}]}
					echo "USER: ${users[${i}]} PASS: $pass" >> /home/$mainUser/Desktop/.backups/passwords.txt
					echo "[INFO] The password for ${users[${i}]} has been changed to $pass"
				fi
			fi
			passwd -x30 -n3 -w7 ${users[${i}]}
			echo "[INFO] ${users[${i}]}'s password ages have been set. MAX: 30D MIN: 3D WARN: 7D"
			echo "[INFO] Lock ${users[${i}]}'s account? (y/n)"
			read lockacc
			if [ $lockacc == y ]
			then
				usermod -L ${users[${i}]}
				echo "[INFO] ${users[${i}]}'s account has been locked."
			fi
		fi	
	fi
	clear
done	

# New User Management
echo "### New User Passwords" >> /home/$mainUser/Desktop/.backups/passwords.txt
clear
echo "[INFO] Type any new user account names below. Separate names using spaces."
read -a newUsers

nuL=${#newUsers[@]}

for (( i=0;i<$nuL;i++))
do
	adduser ${newUsers[${i}]}
	echo "[INFO] ${newUsers[${i}]} has been added to the system."
	echo "[INFO] Make ${newUsers[${i}]} an admin? (y/n)"
       	read admNU
	if [ $admNU == y ]
	then
		gpasswd -a ${newUsers[${i}]} sudo
                gpasswd -a ${newUsers[${i}]} adm
                gpasswd -a ${newUsers[${i}]} lpadmin
                gpasswd -a ${newUsers[${i}]} sambashare
                echo "[INFO] ${newUsers[${i}]} is now an admin."
	else
		echo "[INFO] ${newUsers[${i}]} is now a standard user."
	fi
	echo "[INFO] Add custom password for ${newUsers[${i}]}? (y/n)"
        	read cpass
                if [ $cpass == y ]
                then
                	echo "Password:"
                	read pass
                        echo -e "$pass\n$pass" | passwd ${newUsers[${i}]}
			echo "USER: ${newUsers[${i}]} PASS: $pass" >> /home/$mainUser/Desktop/.backups/passwords.txt
                        echo "[INFO] The password for ${newUsers[${i}]} has been changed. [CUSTOM]"
                else
                        pass="3af32ag45g!!9%"
                        echo -e "$pass\n$pass" | passwd ${newUsers[${i}]}
			echo "USER: ${newUsers[${i}]} PASS: $pass" >> /home/$mainUser/Desktop/.backups/passwords.txt
                        echo "[INFO] The password for ${newUsers[${i}]} has been changed to $pass"
                fi
	passwd -x30 -n3 -w7 ${newUsers[${i}]}
        echo "[INFO] ${newUsers[${i}]}'s password ages have been set. MAX: 30D MIN: 3D WARN: 7D"
        echo "[INFO] Lock ${newUsers[${i}]}'s account? (y/n)"
        read locknacc
        if [ $locknacc == y ]
	then
                usermod -L ${newUsers[${i}]}
        	echo "[INFO] ${newUsers[${i}]}'s account has been locked."
        fi
done

# Basic Security Measures
clear
echo "[INFO] Doing basic security..."
# Locking root account
usermod -L root
# Setting permissions for files
chmod 640 .bash_history
chmod 604 /etc/shadow
# Startup apps
cp /etc/rc.local /home/$mainUser/Desktop/.backups/
echo 'exit 0' > /etc/rc.local
# Firewall
apt-get install ufw -y -qq
ufw enable
ufw deny 1337
# Default /etc/hosts file
cp /etc/hosts /home/$mainUser/Desktop/.backups/
chmod 777 /etc/hosts
echo -e "127.0.0.1 localhost\n127.0.1.1 $HOSTNAME\n::1 ip6-localhost ip6-loopback\nfe00::0 ip6-localnet\nff00::0 ip6-mcastprefix\nff02::1 ip6-allnodes\nff02::2 ip6-allrouters" > /etc/hosts
chmod 644 /etc/hosts
# CPU Timings
cp /etc/default/irqbalance /home/$mainUser/Desktop/.backups/
echo -e "#Configuration for the irqbalance daemon\n\n#Should irqbalance be enabled?\nENABLED=\"0\"\n#Balance the IRQs only once?\nONESHOT=\"0\"" > /etc/default/irqbalance

# Fixing APT sources
echo "[INFO] Fixing and Updating your APT sources..."
cp /etc/apt/sources.list /home/$mainUser/Desktop/.backups/
release=$(lsb_release -c -s)
echo -e "deb http://us.archive.ubuntu.com/ubuntu/ $release $release-updates main restricted universe multiverse $release-backports\ndeb-src http://us.archive.ubuntu.com/ubuntu/ $release-updates main restricted universe multiverse $release-backports\ndeb http://security.ubuntu.com/ubuntu $release-security main restricted universe multiverse\ndeb-src http://security.ubuntu.com/ubuntu $release-security main restricted universe multiverse" > /etc/apt/sources.list
apt-get update
apt-get upgrade -y -qq
echo "[INFO] Updates have been complete."

# Auto updates
echo "[INFO] Turning auto upgrades on..." 
cp /etc/apt/apt.conf.d/20auto-upgrades /home/$mainUser/Desktop/.backups/
echo -e 'APT::Periodic::Update-Package-Lists "1";\nAPT::Periodic::Download-Upgradeable-Packages "0";\nAPT::Periodic::AutocleanInterval "0";\nAPT::Periodic::Unattended-Upgrade "1";' > /etc/apt/apt.conf.d/20auto-upgrades
echo "[INFO] Auto upgrades have been enabled."

clear 
echo "[INFO] Type the name of critical services need out of this list along with a Y or N (case sensitive). Separate them by spaces."
echo "[INFO] Example: sambaY ftpN sshY telnetY mailN"
echo "[SEL] samba ftp ssh telnet mail print webserver dns ipv6"
read -a services
servicesLen=${#services[@]}

for (( i=0;i<$servicesLen;i++))
do
	if [ ${services[${i}]} == "sambaY" ]
	then
		ufw allow netbios-ns
		ufw allow netbios-dgm
		ufw allow netbios-ssn
		ufw allow microsoft-ds
		apt-get install samba system-config-samba -y -qq
		cp /etc/samba/smb.conf /home/$mainUser/Desktop/.backups/
		if [ "$(grep '####### Authentication #######' /etc/samba/smb.conf)" == 0 ]
		then
			sed -i 's/####### Authentication #######/####### Authentication #######\nsecurity = user/g' /etc/samba/smb.conf	
		fi
		sed -i 's/usershare allow guests = no/usershare allow guests = yes/g' /etc/samba/smb.conf
		echo "### SAMBA PASSWORDS ###" >> /home/$mainUser/Desktop/.backups/passwords.txt
		for (( i=0;i<$uslen;i++)) 
		do
			clear
			echo "[INFO] Give ${users[${i}]} Samba permissions? (y/n)"
			read sambaPerm
			if [ $sambaPerm == y ] 
			then
				echo "[INFO] Type in a custom password for ${users[${i}]} or type n for no password."
				read cPassS
				if [ $cPassS == n ] 
				then
					pass="43q0g43qgn!!"
					echo -e "43q0g43qgn!!\43q0g43qgn!!" | smbpasswd -a ${users[${i}]}
					echo "USER: ${users[${i}]} PASS: 43q0g43qgn!!" >> /home/$mainUser/Desktop/.backups/passwords.txt
				else
					echo -e "$cPassS" | smbpasswd -a ${users[${i}]}
					echo "USER: ${users[${i}]} PASS: $cPassS" >> /home/$mainUser/Desktop/.backups/passwords.txt
				fi
			fi
		done
		echo "[INFO] Samba has been enabled."
	elif [ ${services[${i}]} == "sambaN" ]
	then
		ufw deny netbios-ns
		ufw deny netbios-dgm
		ufw deny netbios-ssn
		ufw deny microsoft-ds
		apt-get purge samba samba-common samba-common-bin samba4 -y -qq
		echo "[INFO] Samba has been removed from the system."	
	elif [ ${services[${i}]} == "ftpY" ]
	then
		ufw allow ftp
		ufw allow sftp
		ufw allow saft
		ufw allow ftps-data
		ufw allow ftps
		apt-get install pure-ftpd -y -qq
		systemctl enable --now pure-ftpd
		echo "[INFO] PureFTP has been installed and started on your system."

	elif [ ${services[${i}]} == "ftpN" ]
	then
		ufw deny ftp
		ufw deny sftp
		ufw deny saft
		ufw deny ftps-data
		ufw deny ftps
		apt-get purge pure-ftpd -y -qq
		echo "[INFO] PureFTP has been removed from your system."
	elif [ ${services[${i}]} == "sshY" ]
        then
		apt-get install openssh-server -y -qq
		ufw allow ssh
		cp /etc/ssh/sshd_config /home/$mainUser/Desktop/.backups/
		sshUsers=()
		for (( i=0;i<$uslen;i++))
		do
			clear
			echo "[INFO] Give ${users[${i}]} SSH permission?"
			read sshUser
			sshUsers+=("$sshUser")
		done
		echo -e "# Package generated configuration file\n# See the sshd_config(5) manpage for details\n\n# What ports, IPs and protocols we listen for\nPort 2200\n# Use these options to restrict which interfaces/protocols sshd will bind to\n#ListenAddress ::\n#ListenAddress 0.0.0.0\nProtocol 2\n# HostKeys for protocol version \nHostKey /etc/ssh/ssh_host_rsa_key\nHostKey /etc/ssh/ssh_host_dsa_key\nHostKey /etc/ssh/ssh_host_ecdsa_key\nHostKey /etc/ssh/ssh_host_ed25519_key\n#Privilege Separation is turned on for security\nUsePrivilegeSeparation yes\n\n# Lifetime and size of ephemeral version 1 server key\nKeyRegenerationInterval 3600\nServerKeyBits 1024\n\n# Logging\nSyslogFacility AUTH\nLogLevel VERBOSE\n\n# Authentication:\nLoginGraceTime 60\nPermitRootLogin no\nStrictModes yes\n\nRSAAuthentication yes\nPubkeyAuthentication yes\n#AuthorizedKeysFile	%h/.ssh/authorized_keys\n\n# Don't read the user's ~/.rhosts and ~/.shosts files\nIgnoreRhosts yes\n# For this to work you will also need host keys in /etc/ssh_known_hosts\nRhostsRSAAuthentication no\n# similar for protocol version 2\nHostbasedAuthentication no\n# Uncomment if you don't trust ~/.ssh/known_hosts for RhostsRSAAuthentication\n#IgnoreUserKnownHosts yes\n\n# To enable empty passwords, change to yes (NOT RECOMMENDED)\nPermitEmptyPasswords no\n\n# Change to yes to enable challenge-response passwords (beware issues with\n# some PAM modules and threads)\nChallengeResponseAuthentication yes\n\n# Change to no to disable tunnelled clear text passwords\nPasswordAuthentication no\n\n# Kerberos options\n#KerberosAuthentication no\n#KerberosGetAFSToken no\n#KerberosOrLocalPasswd yes\n#KerberosTicketCleanup yes\n\n# GSSAPI options\n#GSSAPIAuthentication no\n#GSSAPICleanupCredentials yes\n\nX11Forwarding no\nX11DisplayOffset 10\nPrintMotd no\nPrintLastLog no\nTCPKeepAlive yes\n#UseLogin no\n\nMaxStartups 2\n#Banner /etc/issue.net\n\n# Allow client to pass locale environment variables\nAcceptEnv LANG LC_*\n\nSubsystem sftp /usr/lib/openssh/sftp-server\n\n# Set this to 'yes' to enable PAM authentication, account processing,\n# and session processing. If this is enabled, PAM authentication will\n# be allowed through the ChallengeResponseAuthentication and\n# PasswordAuthentication.  Depending on your PAM configuration,\n# PAM authentication via ChallengeResponseAuthentication may bypass\n# the setting of \"PermitRootLogin without-password\".\n# If you just want the PAM account and session checks to run without\n# PAM authentication, then enable this but set PasswordAuthentication\n# and ChallengeResponseAuthentication to 'no'.\nUsePAM yes\n\nAllowUsers ${sshUsers[*]}\nDenyUsers\nRhostsAuthentication no\nClientAliveInterval 300\nClientAliveCountMax 0\nVerifyReverseMapping yes\nAllowTcpForwarding no\nUseDNS no\nPermitUserEnvironment no" > /etc/ssh/sshd_config
		systemctl restart openssh
		mkdir /home/$mainUser/.ssh
		chmod 700 /home/$mainUser/.ssh
		echo "[INFO] Hit enter until the prompt goes away."
		ssh-keygen -t rsa -b 4096
		echo "[INFO] SSH has been enabled and configured."
	elif [ ${services[${i}]} == "sshN" ]
        then
		ufw deny ssh
		apt-get purge openssh-server -y -qq
		echo "[INFO] SSH has been uninstalled."
	elif [ ${services[${i}]} == "telnetY" ]
	then
		ufw allow telnet
		ufw allow rtelnet
		ufw allow telnets
		echo "[INFO] Telnet has been unblocked from firewall."
	elif [ ${services[${i}]} == "telnetN" ]
	then
		ufw deny telnet
		ufw deny rtelnet
		ufw deny telnets
		apt-get purge telnet telnetd inetutils-telnetd telnetd-ssl -y -qq
		echo "[INFO] Telnet has been uninstalled."
	elif [ ${services[${i}]} == "mailY" ]
	then
		ufw allow smtp 
		ufw allow pop2
		ufw allow pop3
		ufw allow imap2
		ufw allow imaps
		ufw allow pop3s
		echo "[INFO] Mail services have been unblocked from firewall."
	elif [ ${services[${i}]} == "mailN" ]
        then
		ufw deny smtp
		ufw deny pop2
		ufw deny pop3
		ufw deny imap2
		ufw deny imaps
		ufw deny pop3s
		echo "[INFO] Mail services have been blocked in the firewall."
	elif [ ${services[${i}]} == "printY" ]
        then
		ufw allow ipp
		ufw allow printer
		ufw allow cups
		echo "[INFO] Print services have been unblocked from firewall."
	elif [ ${services[${i}]} == "printN" ]
        then
		ufw deny ipp
		ufw deny printer
		ufw deny cups
		echo "[INFO] Print services have been blocked in the firewall."
	elif [ ${services[${i}]} == "webserverY" ]
        then
		apt-get install apache2 -y -qq
		ufw allow http
		ufw allow https
		cp /etc/apache2/apache2.conf > /home/$mainUser/Desktop/.backups/
		if [ -e /etc/apache2/apache2.conf ]
		then
			echo -e '\<Directory \>\n\t AllowOverride None\n\t Order Deny,Allow\n\t Deny from all\n\<Directory \/\>\nUserDir disabled root' >> /etc/apache2/apache2.conf
		fi
		chown -R root:root /etc/apache2
		echo "[INFO] Web services have been enabled (apache2)."
	elif [ ${services[${i}]} == "webserverN" ]
        then
		ufw deny http
		ufw deny https
		apt-get purge apache2 nginx -y -qq
		rm -r /var/www/*
		echo "[INFO] Web services have been removed."
	elif [ ${services[${i}]} == "dnsY" ]
        then
		ufw allow domain
		echo "[INFO] DNS service has been unblocked from firewall."
	elif [ ${services[${i}]} == "dnsN" ]
        then
		ufw deny domain
		apt-get purge bind9 -y -qq
		echo "[INFO] DNS service has been removed."
	elif [ ${services[${i}]} == "ipv6N" ]
        then
		echo -e "\n\n# Disable IPv6\nnet.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\nnet.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
		sysctl -p >> /dev/null
		echo "[INFO] IPv6 has been disabled."
	fi
done

echo "Script has completed."
echo "Files have been backed up to /home/$mainUser/Desktop/.backups"
echo "Be sure to check this directory, as it contains passwords, backed up files, and more."
echo "This is what has been done on your system:"
echo "- User Management"
echo "- New User Management"
echo "- Basic Security"
echo "	- Turning off aliases"
echo "	- Root account has been locked"
echo "	- .bash_history permissions set to 640"
echo "	- /etc/shadow permissions set to 604"
echo "	- Startup apps have been disabled (backed up)"
echo "	- UFW (firewall) has been enabled with port 1337 disabled"
echo "	- /etc/hosts has been reset (backed up)"
echo "- APT Sources are fixed"
echo "- Auto updates have been enabled (daily)"
echo "- Samba has been enabled/disabled"
echo "- FTP has been enabled/disabled"
echo "- Telnet has been enabled/disabled"
echo "- Mail Server has been enabled/disabled"
echo "- Printing Service has been enabled/disabled"
echo "- MySQL has been enabled/disabled"
echo "- Web Server has been enabled/disabled"
echo "- DNS server has been enabled/disabled"
echo "- IPv6 has been enabled/disabled"
echo "- Media files have been listed in prohibited-files.txt file and deleted (optional)."
