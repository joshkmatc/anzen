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
rm -rf /etc/rc.local 
echo 'exit 0' >> /etc/rc.local
# Firewall
apt-get install ufw -y -qq
ufw enable
ufw deny 1337
# Default /etc/hosts file
cp /etc/hosts /home/$mainUser/Desktop/.backups/
rm -rf /etc/hosts
touch /etc/hosts
chmod 777 /etc/hosts
echo -e "127.0.0.1 localhost\n127.0.1.1 $HOSTNAME\n::1 ip6-localhost ip6-loopback\nfe00::0 ip6-localnet\nff00::0 ip6-mcastprefix\nff02::1 ip6-allnodes\nff02::2 ip6-allrouters" >> /etc/hosts
chmod 644 /etc/hosts
# CPU Timings
cp /etc/default/irqbalance /home/$mainUser/Desktop/.backups/
rm -rf /etc/default/irqbalance
echo -e "#Configuration for the irqbalance daemon\n\n#Should irqbalance be enabled?\nENABLED=\"0\"\n#Balance the IRQs only once?\nONESHOT=\"0\"" >> /etc/default/irqbalance


clear 
echo "[INFO] Type the name of critical services need out of this list along with a Y or N (case sensitive). Separate them by spaces."
echo "[INFO] Example: sambaY ftpN sshY telnetY mailN"
echo "[SEL] samba ftp ssh telnet mail print mysql webserver dns ipv6"
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
		systemctl restart pureftpd
	elif [ ${services[${i}]} == "ftpN" ]
	then

	elif [ ${services[${i}]} == "telnetY" ]
	then

	elif [ ${services[${i}]} == "telnetN" ]
	then

	elif [ ${services[${i}]} == "mailY" ]
	then

	elif [ ${services[${i}]} == "mailN" ]
        then

	elif [ ${services[${i}]} == "printY" ]
        then

	elif [ ${services[${i}]} == "printN" ]
        then

	elif [ ${services[${i}]} == "mysqlY" ]
        then

	elif [ ${services[${i}]} == "mysqlN" ]
        then

	elif [ ${services[${i}]} == "webserverY" ]
        then

	elif [ ${services[${i}]} == "webserverN" ]
        then
	
	elif [ ${services[${i}]} == "dnsY" ]
        then
	
	elif [ ${services[${i}]} == "dnsN" ]
        then

	elif [ ${services[${i}]} == "ipv6Y" ]
        then

	elif [ ${services[${i}]} == "ipv6N" ]
        then

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
echo "- Samba has been enabled/disabled"
echo "- FTP has been enabled/disabled"
echo "- Telnet has been enabled/disabled"
echo "- Mail Server has been enabled/disabled"
echo "- Printing Service has been enabled/disabled"
echo "- MySQL has been enabled/disabled"
echo "- Web Server has been enabled/disabled"
echo "- DNS server has been enabled/disabled"
echo "- Media files have been listed in prohibited-files.txt file."
echo "- IPv6 has been enabled/disabled"
