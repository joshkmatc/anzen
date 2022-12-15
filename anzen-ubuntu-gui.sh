#!/bin/bash
# Colors
endC="\e[0m"
stan="\e["
bold="\e[1;"
und="\e[4;"
red="91m"
yel="93m"
gre="92m"
blu="94m"
mag="95m"

# Version Check
VER=$(lsb_release -cs)
if [ $VER == "bionic" ]
then
	if zenity --question --text="<b>Ubuntu 18.04 Bionic LTS</b> is not supported with this script. Things may not run as expected. Continue anyways?" --ellipsize --default-cancel --icon-name-warning
	then
		echo ""
	else
       		exit	
	fi
elif [ $VER == "xenial" ]
then
	zenity --error --text="<b>Ubuntu 16.04 Xenial LTS</b> is not supported with this script. Upgrade to a newer version of Ubuntu to run his script."
	exit
elif [ $VER == "focal" ]
then
	echo ""
elif [ $VER == "jammy" ]
then
	echo ""
else
	echo -e "${stan}${yel}[WARN] Release $VER is not supported with this script. Things may not work as expected. Continue anyways? (y/N)${endC}"
	if zenity --question --text="Release <b>$VER</b> is not supported with this script. Things may not run as expected. Continue anyways?" --ellipsize --default-cancel --icon-name=warning
	then
		echo ""
	else
       		exit	
	fi
fi

# Root check
if [[ $EUID -ne 0 ]]
then
	pkexec "$0" "$@"
	exit
fi



mainUser=$(getent passwd $PKEXEC_UID | cut -d: -f1)
# Backup directory
mkdir -p /home/$mainUser/Desktop/.backups

# Forensics Questions
(
echo "[INFO] Gathering information for forensics questions..."
find /home -name "*.midi" -type f > /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.mid" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.mod" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.mp3" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.mp2" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.mpa" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.abs" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.mpega" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt  
find /home -name "*.au" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.snd" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.wav" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.aiff" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt 
find /home -name "*.aif" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.sid" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.flac" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.ogg" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.mpeg" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.mpg" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt	
find /home -name "*.mpe" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.dl" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.movie" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.movi" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.mv" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.iff" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.anim5" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
echo "25" ; 
find /home -name "*.anim3" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.anim7" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.avi" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.vfw" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.avx" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.fli" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.flc" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.mov" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.qt" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.spl" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.swf" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.dcr" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.dir" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.dxr" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.rpm" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.rm" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.smi" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.ra" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.ram" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.rv" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.wmv" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.asf" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.asx" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.wma" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.wax" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
echo "50" ; 
find /home -name "*.wmv" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.wmx" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.3gp" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.mov" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.mp4" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.avi" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.swf" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.flv" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.m4v" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.tiff" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.tif" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.rs" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.im1" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.gif" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.jpeg" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
echo "70" ; 
find /home -name "*.jpg" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.jpe" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.png" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.rgb" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.xwd" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.xpm" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.ppm" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.pbm" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.pgm" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.pcx" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.ico" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.svg" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
find /home -name "*.svgz" -type f >> /home/$mainUser/Desktop/.backups/media-files.txt
echo "[INFO] Found media files. Listing users..."
echo "100" ; 
) | sudo -u ${mainUser} --preserve-env=DISPLAY,XDG_RUNTIME_DIR \
	zenity --progress --display=:0 --no-cancel --auto-close --title="Anzen - Forensics Questions" --text="Gathering media files..." --percentage 0
echo "## USERS ##" > /home/$mainUser/Desktop/.backups/users.txt
readarray -t userList < <(getent passwd | cut -d: -f1 | sort)
userlen=${#userList[@]}
(
for ((i=0;i<$userlen;i++))
do
	percdec=$(printf %.2f "$((10**3 * (${i} + 1)/${userlen}))e-3")
	percent=$(echo "${percdec} * 100" | bc)
	echo "${percent}"
	echo "Username: ${userList[${i}]} | ID: $(id ${userList[${i}]} | cut -d ' ' -f1)" >> /home/$mainUser/Desktop/.backups/users.txt
done
) | sudo -u ${mainUser} --preserve-env=DISPLAY,XDG_RUNTIME_DIR \
        zenity --progress --display=:0 --no-cancel --auto-close --title="Anzen - Forensics Questions" --text="Gathering users..." --percentage 0

# clear
echo -e "${bold}${yel}    ___                         
   /   |  ____  ____  ${endC}${bold}${red}___  ____${endC} 
${bold}${yel}  / /| | / __ \\/_  /${endC}${bold}${red} / _ \\/ __ \\ ${endC}
${bold}${yel} / ___ |/ / / / / /${endC}${bold}${red}_/  __/ / / / ${endC}
${bold}${yel}/_/  |_/_/ /_/ /__${endC}${bold}${red}_/\\___/_/ /_/ ${endC}"
echo ""
echo "[INFO] Welcome to Anzen Ubuntu, a script made for the CyberPatriot Competition. Made by Josh K."
echo -e "${bold}${yel}[WARN]${endC}${stan}${yel} This is a beta version of the script. Do not expect it to work fully.${endC}"
echo "-----------------------------------------------------------------------------------------------"
echo -e "${bold}${yel}[WARN]${endC}${stan}${yel} Ensure you do the forensic questions BEFORE you start.${endC}"
echo "[INFO] Media files and users are located in /home/$mainUser/Desktop/.backups"
echo -e "${bold}${yel}[WARN]${endC}${stan}${yel} If a User ID is equal to 0 and it isn't the root user, modify the user's ID in the /etc/passwd file.${endC}"
echo -e "${bold}${yel}[WARN]${endC}${stan}${yel} Delete the user, then continue with the script.${endC}"
echo "-----------------------------------------------------------------------------------------------"
echo ""
echo "[INFO] Press Enter when you are ready to start."
read

# User Management
readarray -t users < <(getent passwd | cut -d: -f1 | sort)
systemusers=("daemon" "bin" "sys" "games" "man" "lp" "mail" "news" "uucp" "proxy" "www-data" "backup" "list" "irc" "gnats" "nobody" "systemd-network" "systemd-resolve" "messagebus" "systemd-timesync" "syslog" "_apt" "tss" "uuidd" "systemd-oom" "tcpdump" "avahi-autoipd" "usbmux" "dnsmasq" "kernoops" "avahi" "cups-pk-helper" "rtkit" "whoopsie" "sssd" "speech-dispatcher" "nm-openvpn" "saned" "colord" "geoclue" "pulse" "gnome-initial-setup" "hplip" "gdm" "sshd" "fwupd-refresh" "systemd-coredump")
uslen=${#users[@]}
echo "### Existing User Changed Passwords ###" >> /home/$mainUser/Desktop/.backups/passwords.txt
for (( i=0;i<$uslen;i++)) 
do
	if [[ " ${systemusers[*]} " =~ " ${users[${i}]} " ]];
	then
		usermod -s /sbin/nologin ${users[${i}]}
		clear
		continue
	elif [[ "${users[${i}]}" == "sync" ]];
	then
		clear
		continue
	elif [[ "${users[${i}]}" == "root" ]];
	then
		clear
		continue
	fi
	echo -e "${bold}${blu}[Phase 1]${endC} ${stan}${blu}User Management${endC}"
	rootcheck=$(id -u ${users[${i}]})
	if [[ $rootcheck == 0 ]] && [[ "${users[${i}]}" != "root" ]];
	then
		sudo -u ${mainUser} --preserve-env=DISPLAY,XDG_RUNTIME_DIR \
        zenity --error --text="Cannot manage <b>${users[${i}]}</b>. Their UID is 0. This means that their user is acting as the root user.\n\nPlease modify their UID manually in this file:\n<b>/etc/passwd</b>\n\nYou will have to manually delete this user.\n\nPress OK when you are ready to continue."
		continue
	fi
	sudo -u "${mainUser}" --preserve-env=DISPLAY,XDG_RUNIME_DIR echo "DISPLAY IS :$DISPLAY"
	sudo -u "${mainUser}" --preserve-env=DISPLAY,XDG_RUNTIME_DIR zenity --question --text="Do you want to modify <b>${users[${i}]}</b>?\n\n<b>Note</b>: Ignore this user if it is a system user.\n\nPress Yes to modify, otherwise press no." --default-cancel --ellipsize
	read
	if sudo -u ${mainUser} --preserve-env=DISPLAY,XDG_RUNTIME_DIR zenity --question --text="Do you want to modify <b>${users[${i}]}</b>?\n\n<b>Note</b>: Ignore this user if it is a system user.\n\nPress Yes to modify, otherwise press no." --default-cancel --ellipsize; 
	then	
		if sudo -u ${mainUser} --preserve-env=DISPLAY,XDG_RUNTIME_DIR zenity --question --text="Do you want to delete <b>${users[${i}]}</b>\n\nPress Yes to delete, otherwise press no." --default-cancel --ellipsize --icon-name=warning;
		then
			if sudo -u ${mainUser} --preserve-env=DISPLAY,XDG_RUNTIME_DIR zenity --question --text="<b>Are you sure</b> you want to delete <b>${users[${i}]}</b>?\n\nPress Yes to confirm deletion, otherwise press no." --default-cancel --ellipsize --icon-name=warning; 
			then
				userdel -r ${users[${i}]}
				echo "[INFO] User ${users[${i}]} has been deleted"
			fi
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
echo -e "${bold}${blu}[Phase 1]${endC}${stan}${blu} User Management${endC}"
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

# Reassinging variables for later use
readarray -t users < <(getent passwd | cut -d: -f1 | sort)
uslen=${#users[@]}

# New Group Management
clear
echo -e "${bold}${blu}[Phase 1]${endC} ${stan}${blu}User Management${endC}"
echo "[INFO] Type any new groups names below. Separate names using spaces."
read -a newGroups

nGrpsL=${#newGroups[@]}

for (( i=0;i<$nGrpsL;i++))
do
	groupadd "${newGroups[${i}]}"
	echo "[INFO] The group ${newGroups[${i}]} has been added to the system."
	for (( j=0;j<$uslen;j++))
	do
		clear
		echo "[INFO] Add ${users[${j}]} to the ${newGroups[${i}]} group? (y/n)"
        	read addGroup
                if [ $addGroup == y ]
                then
			usermod -a -G ${newGroups[${i}]} ${users[${j}]}
			echo "[INFO] ${users[${j}]} has been added to the ${newGroups[${i}]} group."
		fi
	done
done


# Basic Security Measures
clear
echo -e "${bold}${blu}[Phase 2]${endC} ${stan}${blu}Basic Security${endC}"
echo "[INFO] Doing basic security..."
# Locking root account
usermod -L root
passwd -l root
# Setting permissions for files
chmod 640 .bash_history
chmod 604 /etc/shadow
# Startup apps
cp /etc/rc.local /home/$mainUser/Desktop/.backups/
echo 'exit 0' > /etc/rc.local

# Firewall
echo "[INFO] Enabling firewall..."
apt-get install ufw -y -qq
ufw enable
ufw deny 1337
echo "[INFO] Firewall enabled."
# Default /etc/hosts file
echo "[INFO] Fixing /etc/hosts file..."
cp /etc/hosts /home/$mainUser/Desktop/.backups/
chmod 777 /etc/hosts
echo -e "127.0.0.1 localhost\n127.0.1.1 $HOSTNAME\n::1 ip6-localhost ip6-loopback\nfe00::0 ip6-localnet\nff00::0 ip6-mcastprefix\nff02::1 ip6-allnodes\nff02::2 ip6-allrouters" > /etc/hosts
chmod 644 /etc/hosts
echo "[INFO] /etc/hosts file fixed."
# CPU Timings
echo "[INFO] Fixing irqbalance (CPU Timings) file..."
cp /etc/default/irqbalance /home/$mainUser/Desktop/.backups/
echo -e "#Configuration for the irqbalance daemon\n\n#Should irqbalance be enabled?\nENABLED=\"0\"\n#Balance the IRQs only once?\nONESHOT=\"0\"" > /etc/default/irqbalance
echo "[INFO] irqbalance file fixed."

# Crontab
echo "[INFO] Crontab is being backed up and disabled..."
crontab -l > /home/$mainUser/Desktop/.backups/crontab
crontab -r
echo "[INFO] Crontab has been backed up and disabled"

# Passwords /etc/login.defs
echo "[INFO] Changing login.defs file..."
sed -i '165s/PASS_MAX_DAYS.*/PASS_MAX_DAYS	30/' /etc/login.defs
sed -i '166s/PASS_MIN_DAYS.*/PASS_MIN_DAYS	1/' /etc/login.defs
sed -i '167s/PASS_WARN_AGE.*/PASS_WARN_AGE	7/' /etc/login.defs
echo "[INFO] login.defs file has been changed. MAX: 30 MIN: 1 WARN: 7"

# Disabling ICMP in UFW
echo "[INFO] Disabling ICMP in UFW..."
sed -i '34s/-A.*/#-A ufw-before-input -p icmp --icmp-type destination-unreachable -j ACCEPT/' /etc/ufw/before.rules
sed -i '35s/-A.*/#-A ufw-before-input -p icmp --icmp-type time-exceeded -j ACCEPT/' /etc/ufw/before.rules
sed -i '36s/-A.*/#-A ufw-before-input -p icmp --icmp-type parameter-problem -j ACCEPT/' /etc/ufw/before.rules
sed -i '37s/-A.*/#-A ufw-before-input -p icmp --icmp-type echo-request -j ACCEPT/' /etc/ufw/before.rules
sed -i '40s/-A.*/#-A ufw-before-forward -p icmp --icmp-type destination-unreachable -j ACCEPT/' /etc/ufw/before.rules
sed -i '41s/-A.*/#-A ufw-before-forward -p icmp --icmp-type time-exceeded -j ACCEPT/' /etc/ufw/before.rules
sed -i '42s/-A.*/#-A ufw-before-forward -p icmp --icmp-type parameter-problem -j ACCEPT/' /etc/ufw/before.rules
sed -i '43s/-A.*/#-A ufw-before-forward -p icmp --icmp-type echo-request -j ACCEPT/' /etc/ufw/before.rules
ufw reload
echo "[INFO] ICMP disabled in UFW"

# Preventing Standard Users from using dmesg
echo "[INFO] Disabling dmesg for standard users..."
echo 'kernel.dmesg_restrict=1' | tee -a /etc/sysctl.conf
echo "[INFO] Disabled dmesg for standard users."

echo "[INFO] Disabling ICMP redirects from kernel..."
touch /etc/sysctl.d/96-disable-icmpv4.conf
echo 'net.ipv4.conf.all.accept_redirects=0' | tee -a /etc/sysctl.d/96-disable-icmpv4.conf
echo 'net.ipv4.conf.eth0.accept_redirects=0' | tee -a /etc/sysctl.d/96-disable-icmpv4.conf
echo 'net.ipv4.conf.eth1.accept_redirects=0' | tee -a /etc/sysctl.d/96-disable-icmpv4.conf
echo 'net.ipv6.conf.eth0.accept_redirects=0' | tee -a /etc/sysctl.d/96-disable-icmpv4.conf
echo 'net.ipv6.conf.eth1.accept_redirects=0' | tee -a /etc/sysctl.d/96-disable-icmpv4.conf
echo "[INFO] Disabled ICMP redirects from kernel."

# Fixing APT sources
echo "[INFO] Fixing and Updating your APT sources..."
cp /etc/apt/sources.list /home/$mainUser/Desktop/.backups/
release=$(lsb_release -c -s)
echo -e "deb http://us.archive.ubuntu.com/ubuntu/ $release main restricted universe multiverse" > /etc/apt/sources.list
echo -e "deb-src http://us.archive.ubuntu.com/ubuntu/ $release main restricted universe multiverse" >> /etc/apt/sources.list
echo -e "deb http://us.archive.ubuntu.com/ubuntu/ $release-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo -e "deb-src http://us.archive.ubuntu.com/ubuntu/ $release-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo -e "deb http://security.ubuntu.com/ubuntu $release-security main restricted universe multiverse" >> /etc/apt/sources.list
echo -e "deb-src http://security.ubuntu.com/ubuntu $release-security main restricted universe multiverse" >> /etc/apt/sources.list
apt-get update
apt-get upgrade -y -qq
echo "[INFO] Updates have been complete."

# Auto updates
zenity --info --text="Software &amp; Updates will now open.\nNavigate to the Updates tab, then change the settings to:\n\n<b>Subscribed to:</b> All updates\n<b>Automatically check for updates:</b> Daily\n<b>When there are security updates:</b> Download and install automatically\n<b>When there are other updates:</b> Display immediately\n<b>Notify me of a new Ubuntu version:</b> For long-term support versions\n\nWhen you have changed these settings, click Close, then click Reload on the popup asking to refresh the cache." &
software-properties-gtk
echo "[INFO] Auto upgrades have been enabled."

echo "[INFO] Fixing sudoers file..."
cp /etc/sudoers /home/$mainUser/Desktop/.backups/
echo -e "#\n# This file MUST be edited with the 'visudo' command as root.\n#\n# Please consider adding local content in /etc/sudoers.d/ instead of\n# directly modifying this file.\n#\n# See the man page for details on how to write a sudoers file.\n#\nDefaults	env_reset\nDefaults	mail_badpass\nDefaults	secure_path=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin\"\nDefaults	use_pty\n\n# This preserves proxy settings from user environments of root\n# equivalent users (group sudo)\n#Defaults:%sudo env_keep += \"http_proxy https_proxy ftp_proxy all_proxy no_proxy\"\n\n# This allows running arbitrary commands, but so does ALL, and it means\n\n# different sudoers have their choice of editor respected.\n#Defaults:%sudo env_keep += \"EDITOR\"\n\n# Completely harmless preservation of a user preference.\n#Defaults:%sudo env_keep += \"GREP_COLOR\"\n\n# While you shouldn't normally run git as root, you need to with etckeeper\n#Defaults:%sudo env_keep += \"GIT_AUTHOR_* GIT_COMMITTER_*\"\n\n# Per-user preferences; root won't have sensible values for them.\n#Defaults:%sudo env_keep += \"EMAIL DEBEMAIL DEBFULLNAME\"\n\n# \"sudo scp\" or \"sudo rsync\" should be able to use your SSH agent.\n#Defaults:%sudo env_keep += \"SSH_AGENT_PID SSH_AUTH_SOCK\"\n\n# Ditto for GPG agent\n#Defaults:%sudo env_keep += \"GPG_AGENT_INFO\"\n\n# Host alias specification\n\n# User alias specification\n\n# Cmnd alias specification\n\n# User privilege specification\nroot	ALL=(ALL:ALL) ALL\n\n# Members of the admin group may gain root privileges\n%admin ALL=(ALL) ALL\n\n# Allow members of group sudo to execute any command\n%sudo	ALL=(ALL:ALL) ALL\n\n# See sudoers(5) for more information on \"@include\" directives:" > /etc/sudoers
chmod 0440 /etc/sudoers
echo "[INFO] Sudoers file is fixed."
echo "[INFO] Fixing permissions..."
chmod 0640 /etc/shadow
chmod 0644 /etc/passwd

clear 
echo -e "${bold}${blu}[Phase 3]${endC} ${stan}${blu}Service Management${endC}"
echo "[INFO] Type the name of critical services need out of this list along with a Y or N (case sensitive). Separate them by spaces."
echo "[INFO] Example: sambaY ftpN sshY telnetY mailN"
echo "[SEL] samba ftp ssh telnet mail print webserver dns"
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
			echo -e "${bold}${blu}[Phase 3]${endC} ${stan}${blu}Service Management${endC}"
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
		apt-get purge samba -y -qq
		apt-get purge samba-common -y -qq
		apt-get purge samba-common-bin -y -qq
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
		apt-get purge vsftpd -y -qq
		echo "[INFO] FTP has been removed from your system."
	elif [ ${services[${i}]} == "sshY" ]
        then
		apt-get install openssh-server -y -qq
		ufw allow ssh
		cp /etc/ssh/sshd_config /home/$mainUser/Desktop/.backups/
		readarray -t sshuserl < <(getent passwd | cut -d: -f1 | sort)
		sshuserlen=${#sshuserl[@]}
		sshUsers=()
		for (( i=0;i<$sshuserlen;i++))
		do
			clear
			echo -e "${bold}${blu}[Phase 3]${endC}${stan}${blu} Service Management${endC}"
			echo "[INFO] Give ${sshuserl[${i}]} SSH permission? (y/n)"
			read sshUser
			if [ $sshUser == y ]
			then
				sshUsers+=("${sshuserl[${i}]}")
			fi
		done
		echo -e "# Package generated configuration file\n# See the sshd_config(5) manpage for details\n\n# What ports, IPs and protocols we listen for\nPort 2200\n# Use these options to restrict which interfaces/protocols sshd will bind to\n#ListenAddress ::\n#ListenAddress 0.0.0.0\nProtocol 2\n# HostKeys for protocol version \nHostKey /etc/ssh/ssh_host_rsa_key\nHostKey /etc/ssh/ssh_host_dsa_key\nHostKey /etc/ssh/ssh_host_ecdsa_key\nHostKey /etc/ssh/ssh_host_ed25519_key\n#Privilege Separation is turned on for security\nUsePrivilegeSeparation yes\n\n# Lifetime and size of ephemeral version 1 server key\nKeyRegenerationInterval 3600\nServerKeyBits 1024\n\n# Logging\nSyslogFacility AUTH\nLogLevel VERBOSE\n\n# Authentication:\nLoginGraceTime 60\nPermitRootLogin no\nStrictModes yes\n\nRSAAuthentication yes\nPubkeyAuthentication yes\n#AuthorizedKeysFile	%h/.ssh/authorized_keys\n\n# Don't read the user's ~/.rhosts and ~/.shosts files\nIgnoreRhosts yes\n# For this to work you will also need host keys in /etc/ssh_known_hosts\nRhostsRSAAuthentication no\n# similar for protocol version 2\nHostbasedAuthentication no\n# Uncomment if you don't trust ~/.ssh/known_hosts for RhostsRSAAuthentication\n#IgnoreUserKnownHosts yes\n\n# To enable empty passwords, change to yes (NOT RECOMMENDED)\nPermitEmptyPasswords no\n\n# Change to yes to enable challenge-response passwords (beware issues with\n# some PAM modules and threads)\nChallengeResponseAuthentication yes\n\n# Change to no to disable tunnelled clear text passwords\nPasswordAuthentication no\n\n# Kerberos options\n#KerberosAuthentication no\n#KerberosGetAFSToken no\n#KerberosOrLocalPasswd yes\n#KerberosTicketCleanup yes\n\n# GSSAPI options\n#GSSAPIAuthentication no\n#GSSAPICleanupCredentials yes\n\nX11Forwarding no\nX11DisplayOffset 10\nPrintMotd no\nPrintLastLog no\nTCPKeepAlive yes\n#UseLogin no\n\nMaxStartups 2\n#Banner /etc/issue.net\n\n# Allow client to pass locale environment variables\nAcceptEnv LANG LC_*\n\nSubsystem sftp /usr/lib/openssh/sftp-server\n\n# Set this to 'yes' to enable PAM authentication, account processing,\n# and session processing. If this is enabled, PAM authentication will\n# be allowed through the ChallengeResponseAuthentication and\n# PasswordAuthentication.  Depending on your PAM configuration,\n# PAM authentication via ChallengeResponseAuthentication may bypass\n# the setting of \"PermitRootLogin without-password\".\n# If you just want the PAM account and session checks to run without\n# PAM authentication, then enable this but set PasswordAuthentication\n# and ChallengeResponseAuthentication to 'no'.\nUsePAM yes\n\nAllowUsers ${sshUsers[*]}\nDenyUsers\nRhostsAuthentication no\nClientAliveInterval 300\nClientAliveCountMax 0\nVerifyReverseMapping yes\nAllowTcpForwarding no\nUseDNS no\nPermitUserEnvironment no" > /etc/ssh/sshd_config
		systemctl restart sshd
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
		apt-get purge telnet -y -qq
		apt-get purge telnetd -y -qq 
		apt-get purge inetutils-telnetd -y -qq
		apt-get purge telnetd-ssl -y -qq
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
		apt-get purge opensmtpd -y -qq
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
		echo "[INFO] Install apache2? (y/n)"
		read apache
		if [ $apache == y ]
		then
			apt-get install apache2 -y -qq
			cp /etc/apache2/apache2.conf > /home/$mainUser/Desktop/.backups/
			if [ -e /etc/apache2/apache2.conf ]
			then
				echo -e '\<Directory \>\n\t AllowOverride None\n\t Order Deny,Allow\n\t Deny from all\n\<Directory \/\>\nUserDir disabled root' >> /etc/apache2/apache2.conf
			fi
			chown -R root:root /etc/apache2
		fi
		ufw allow http
		ufw allow https
		echo "[INFO] Web services have been enabled."
	elif [ ${services[${i}]} == "webserverN" ]
        then
		ufw deny http
		ufw deny https
		apt-get purge apache2 -y -qq
		apt-get purge nginx -y -qq
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
	fi
done

# Media Files
clear
echo -e "${bold}${blu}[Phase 4]${endC}${stan}${blu} Finishing Phase Removal${endC}"
readarray -t mediafiles < <(cat /home/$mainUser/Desktop/.backups/media-files.txt)
mflength=${#mediafiles[@]}
for (( i=0;i<$mflength;i++))
do
	clear
	echo -e "${bold}${blu}[Phase 4]${endC} ${stan}${blu}Finishing Phase${endC}"
	echo "[INFO] Do you want to delete ${mediafiles[${i}]}? (y/n)"
	rm -i "${mediafiles[${i}]}"
done
echo "[INFO] Finished deleting files."

# Password Policy
clear
echo "[Phase 4] Finishing Phase"
echo "[INFO] Setting up PAM password policies..."
RELEASE=$(lsb_release -cs)
cp /etc/pam.d/common-auth /home/$mainUser/Desktop/.backups/
cp /etc/pam.d/common-password /home/$mainUser/Desktop/.backups/
if [ $RELEASE == "jammy" ]
then
	echo -e "#\n# /etc/pam.d/common-auth - authentication settings common to all services\n#\n# This file is included from other service-specific PAM config files,\n# and should contain a list of the authentication modules that define\n# the central authentication scheme for use on the system\n# (e.g., /etc/shadow, LDAP, Kerberos, etc.).  The default is to use the\n# traditional Unix authentication mechanisms.\n#\n# As of pam 1.0.1-6, this file is managed by pam-auth-update by default.\n# To take advantage of this, it is recommended that you configure any\n# local modules either before or after the default block, and use\n# pam-auth-update to manage selection of other modules.  See\n# pam-auth-update(8) for details.\n\n\n# here are the per-package modules (the "Primary" block)\nauth    required pam_faillock.so preauth audit silent deny=5 unlock_time=1800\nauth    [success=1 default=ignore]      pam_unix.so nullok\n# here's the fallback if no module succeeds\n# BEGIN ANSIBLE MANAGED BLOCK\nauth    [default=die] pam_faillock.so authfail audit deny=5 unlock_time=1800\nauth    sufficient pam_faillock.so authsucc audit deny=5 unlock_time=1800\n# END ANSIBLE MANAGED BLOCK\nauth    requisite                       pam_deny.so\n# prime the stack with a positive return value if there isn't one already;\n# this avoids us returning an error just because nothing sets a success code\n# since the modules above will each just jump around\nauth    required                        pam_permit.so\n# and here are more per-package modules (the "Additional" block)\nauth    optional                        pam_cap.so\n# end of pam-auth-update config" > /etc/pam.d/common-auth
	echo -e "#\n# /etc/pam.d/common-password - password-related modules common to all services\n#\n# This file is included from other service-specific PAM config files,\n# and should contain a list of modules that define the services to be\n# used to change user passwords.  The default is pam_unix.\n\n# Explanation of pam_unix options:\n#\n# The \"sha512\" option enables salted SHA512 passwords.  Without this option,\n# the default is Unix crypt.  Prior releases used the option \"md5\".\n#\n# The \"obscure\" option replaces the old \`OBSCURE_CHECKS_ENAB\' option in\n# login.defs.\n#\n# See the pam_unix manpage for other options.\n\n# As of pam 1.0.1-6, this file is managed by pam-auth-update by default.\n# To take advantage of this, it is recommended that you configure any\n# local modules either before or after the default block, and use\n# pam-auth-update to manage selection of other modules.  See\n# pam-auth-update(8) for details.\n\n# here are the per-package modules (the \"Primary\" block)\npassword	[success=1 default=ignore]	pam_unix.so obscure sha512\n# here's the fallback if no module succeeds\npassword	requisite			pam_deny.so\n# prime the stack with a positive return value if there isn't one already;\n# this avoids us returning an error just because nothing sets a success code\n# since the modules above will each just jump around\npassword	required			pam_permit.so\n# and here are more per-package modules (the \"Additional\" block)\npassword	optional	pam_gnome_keyring.so \npassword requisite pam_pwquality.so retry=3 minlen=8 difok=3 reject_username minclass=3 maxrepeat=2 dcredit=1 ucredit=1 lcredit=1 ocredit=1\npassword requisite pam_pwhistory.so use_authtok remember=24 enforce_for_root\n# end of pam-auth-update config\naccount	required	pam_faillock.so" > /etc/pam.d/common-password

	echo "[INFO] The password policies for PAM (using $RELEASE) have been set. RETRY: 3 MINLEN: 8 DIFOK: 3 REJECT_USER: Enabled MINCLASS: 3 MAXREPEAT: 2 DCREDIT: 1 UCREDIT: 1 LCREDIT: 1 OCREDI: 1"
	echo "[INFO] Reinstalling Firefox as an APT package..."
	add-apt-repository ppa:mozillateam/ppa -y
	snap remove firefox
	echo -e "Package: firefox*\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 501" > /etc/apt/preferences.d/mozillateamppa
	apt-get update
	apt-get install firefox
else
	apt-get install libpam-cracklib -y -qq
	echo -e "#\n# /etc/pam.d/common-auth - authentication settings common to all services\n#\n# This file is included from other service-specific PAM config files,\n# and should contain a list of the authentication modules that define\n# the central authentication scheme for use on the system\n# (e.g., /etc/shadow, LDAP, Kerberos, etc.).  The default is to use the\n# traditional Unix authentication mechanisms.\n#\n# As of pam 1.0.1-6, this file is managed by pam-auth-update by default.\n# To take advantage of this, it is recommended that you configure any\n# local modules either before or after the default block, and use\n# pam-auth-update to manage selection of other modules.  See\n# pam-auth-update(8) for details.\n\n# here are the per-package modules (the \"Primary\" block)\nauth	[success=1 default=ignore]	pam_unix.so nullok_secure\n# here's the fallback if no module succeeds\nauth	requisite			pam_deny.so\n# prime the stack with a positive return value if there isn't one already;\n# this avoids us returning an error just because nothing sets a success code\n# since the modules above will each just jump around\nauth	required			pam_permit.so\n# and here are more per-package modules (the \"Additional\" block)\nauth	optional			pam_cap.so \n# end of pam-auth-update config\nauth required pam_tally2.so deny=5 unlock_time=1800 onerr=fail audit even_deny_root_account silent" > /etc/pam.d/common-auth
	echo -e "#\n# /etc/pam.d/common-password - password-related modules common to all services\n#\n# This file is included from other service-specific PAM config files,\n# and should contain a list of modules that define the services to be\n# used to change user passwords.  The default is pam_unix.\n\n# Explanation of pam_unix options:\n#\n# The \"sha512\" option enables salted SHA512 passwords.  Without this option,\n# the default is Unix crypt.  Prior releases used the option \"md5\".\n#\n# The \"obscure\" option replaces the old \`OBSCURE_CHECKS_ENAB\' option in\n# login.defs.\n#\n# See the pam_unix manpage for other options.\n\n# As of pam 1.0.1-6, this file is managed by pam-auth-update by default.\n# To take advantage of this, it is recommended that you configure any\n# local modules either before or after the default block, and use\n# pam-auth-update to manage selection of other modules.  See\n# pam-auth-update(8) for details.\n\n# here are the per-package modules (the \"Primary\" block)\npassword	[success=1 default=ignore]	pam_unix.so obscure sha512\n# here's the fallback if no module succeeds\npassword	requisite			pam_deny.so\n# prime the stack with a positive return value if there isn't one already;\n# this avoids us returning an error just because nothing sets a success code\n# since the modules above will each just jump around\npassword	required			pam_permit.so\n# and here are more per-package modules (the \"Additional\" block)\npassword	optional	pam_gnome_keyring.so \npassword requisite pam_cracklib.so retry=3 minlen=8 difok=3 reject_username minclass=3 maxrepeat=2 dcredit=1 ucredit=1 lcredit=1 ocredit=1\npassword requisite pam_pwhistory.so use_authtok remember=24 enforce_for_root\n# end of pam-auth-update config" > /etc/pam.d/common-password
	echo "[INFO] The password policies for PAM (using $RELEASE) have been set. RETRY: 3 MINLEN: 8 DIFOK: 3 REJECT_USER: Enabled MINCLASS: 3 MAXREPEAT: 2 DCREDIT: 1 UCREDIT: 1 LCREDIT: 1 OCREDI: 1"
fi

# Bad Programs
echo "[INFO] Removing bad programs..."
badPrograms=("netcat" "netcat-openbsd" "netcat-traditional" "ncat" "pnetcat" "socat" "sock" "socket" "sbd" "john" "john-data" "hydra" "hydra-gtk" "aircrack-ng" "fcrackzip" "lcrack" "ophcrack" "ophcrack-cli" "pdfcrack" "pyrit" "rarcrack" "sipcrack" "irpas" "manaplus" "manaplus-data" "gameconqueror" "freeciv" "dsniff" "p0f" "packit" "pompem" "doona" "proxychains" "xprobe")
badSnaps=("obs-studio" "duckmarines")
for badp in ${badPrograms[@]}; do
	apt-get purge $badp -y -qq
done
for bads in ${badSnaps[@]}; do
	snap remove $bads
done
rm /usr/bin/nc
rm /usr/bin/backdoor
echo "[INFO] Removal of bad programs complete."
echo "[INFO] Installation complete."

clear
echo -e "[INFO] ${bold}${gre}Script has completed.${endC}"
echo -e "[INFO] Files have been backed up to ${bold}${blu}/home/$mainUser/Desktop/.backups${endC}"
echo "[INFO] Be sure to check this directory, as it contains passwords, backed up files, and more."
echo "[INFO] This is what has been done on your system:"
echo "--------------------"
echo "- [Phase 1] User Management"
echo "	- Existing User Management"
echo "	- New User Management"
echo "- [Phase 2] Basic Security"
echo "	- Root account has been locked"
echo "	- .bash_history permissions set to 640"
echo "	- /etc/shadow permissions set to 604"
echo "	- Startup apps have been disabled (backed up)"
echo "	- UFW (firewall) has been enabled with port 1337 disabled"
echo "	- /etc/hosts has been reset (backed up)"
echo "	- /etc/login.defs has been set. MIN: 1 MAX: 30 WARN: 15"
echo "	- APT Sources are fixed"
echo "	- Auto updates have been enabled (daily)"
echo "-	[Phase 3] Service Management"
echo "	- Samba has been enabled/disabled"
echo "	- FTP has been enabled/disabled"
echo "	- Telnet has been enabled/disabled"
echo "	- Mail Server has been enabled/disabled"
echo "	- Printing Service has been enabled/disabled"
echo "	- Web Server has been enabled/disabled"
echo "	- DNS server has been enabled/disabled"
echo "-	[Phase 4] Finishing Phase" 
echo "	- Media files have been listed in media-files.txt file and deleted (optional)."
echo "	- Firefox has been installed as an apt repository (jammy+)"
echo "	- PAM Password Policies have been set. RETRY: 3 MINLEN: 8 DIFOK: 3 REJECT_USER: Enabled MINCLASS: 3 MAXREPEAT: 2 DCREDIT: 1 UCREDIT: 1 LCREDIT: 1 OCREDI: 1"
echo "	- Malicious Programs have been removed."
echo "--------------------"
echo "[INFO] Be sure to check for prohibited programs."
echo "[INFO] Ensure that Firefox settings are good (certs enabled, popup blocker, etc.)."
echo "[INFO] Thanks for running the script. Made by Josh K." 
