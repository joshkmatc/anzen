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
					echo "[INFO] The password for ${users[${i}]} has been changed. [CUSTOM]"
				else
					pass="3af32ag45g!!9%"
					echo -e "$pass\n$pass" | passwd ${users[${i}]}
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
echo "[SEL] samba ftp ssh telnet mail print mysql webserver dns mediafiles ipv6"
read -a services
servicesLen=${#services[@]}

for (( i=0;i<$servicesLen;i++))
do
	if [ ${services[${i}]} == "sambaY" ]
	then
		
	elif [ ${services[${i}]} == "ftp" ]
	then
		echo "ftp!!"
	else
	fi
done

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

