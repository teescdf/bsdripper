#!/bin/sh
# script to perform triage and targeted collection of data from BSD-based systems
echo "Starting data collection phase...ensure this script is run from an otherwise empty directory. If the directory is not empty, kill the script now (CTRL+C). The script will resume in 5 seconds..."
sleep 5
echo "Resuming script..."
# make directories for acquisition of collected data and parsed results
echo "Creating collection directory...remember to acquire this later!"
mkdir collection
echo " "
# collect case information and save to summary file
echo "Creating case information & details..."
touch collection/0_caseinfo.txt
echo "Please enter case name/reference number and press ENTER: "
read varcase
echo "Case ref: $varcase" >> collection/0_caseinfo.txt
echo "Please enter subject/suspect name and press ENTER: "
read varsubject
echo "Subject/suspect name: $varsubject" >> collection/0_caseinfo.txt``
echo "Please enter investigator name and press ENTER: "
read varinvestigator
echo "Case investigator: $varinvestigator" >> collection/0_caseinfo.txt
echo -n "Date and time triage script run: " >> collection/0_caseinfo.txt
date >> collection/0_caseinfo.txt
echo "Case information saved to 0_caseinfo.txt file"
echo " "
# capture process information
echo "Capturing process information with ps and top..." 
ps -aux > collection/processes_ps.txt
top -b -n 1 > collection/processes_top.txt
echo "Collection of process information complete; please see files with names beginning "processes_" for more information"
echo " "
# capture OS information
echo "Collecting operating system information..."
touch collection/OS_info.txt
echo " " >> collection/OS_info.txt
echo "Output of uname -sr: " >> collection/OS_info.txt
uname -sr >> collection/OS_info.txt
echo " " >> collection/OS_info.txt
echo "Output of uname -a: " >> collection/OS_info.txt
uname -a >> collection/OS_info.txt
echo "Collection of OS information is complete; please see OS_info.txt file"
# determine likely OS installation date
echo "Attempting to determine likely (approximate) installation date & time of system from creation of key os files and directories...use with caution"
touch collection/OS_installdate.txt
echo "Likely installation date&time from /home: " >> collection/OS_installdate.txt
stat /home >> collection/OS_installdate.txt
echo "Likely installation date&time from /root: " >> collection/OS_installdate.txt
stat /root >> collection/OS_installdate.txt
echo " " >> collection/OS_installdate.txt
# for FreeBSD:
echo "FreeBSD /home dir ls output: "  >> collection/OS_installdate.txt
ls -lU / | grep home >> collection/OS_installdate.txt
echo " " >> collection/OS_installdate.txt
echo "FreeBSD fstab stat output: "  >> collection/OS_installdate.txt
stat -f '%SB' /etc/fstab >> collection/OS_installdate.txt
echo " " >> collection/OS_installdate.txt
# for OpenBSD:
echo "OpenBSD installation date&time from myname & installurl file: " >> collection/OS_installdate.txt
stat /etc/myname >> collection/OS_installdate.txt
stat /etc/installurl >> collection/OS_installdate.txt
echo " " >> collection/OS_installdate.txt
echo "OpenBSD fstab ls output: "  >> collection/OS_installdate.txt
ls -l /etc/fstab >> collection/OS_installdate.txt
echo "Use the dates provided here with caution...ensure that you corroborate using multiple sources" >> collection/OS_installdate.txt
echo "Collection of OS installation date/time details is complete; please see OS_installdate.txt file"
# capture hostname information
hostname > collection/OS_hostname.txt
# for FreeBSD:
grep -i "hostname" /etc/rc.conf >> collection/OS_hostname.txt
# for OpenBSD:
cat /etc/myname >> collection/OS_hostname.txt
# capture hosts file
cat /etc/hosts > collection/OS_hosts.txt
cat /etc/hosts.allow > collection/OS_hostsallow.txt
# capture timezone information
touch collection/OS_timezone.txt
ls -l /etc/localtime >> collection/OS_timezone.txt
date >> collection/OS_timezone.txt
echo "Collection of timezone information is complete; please see OS_timezone.txt file"
# capture filesystem table and disc mountpoint information
echo "Attempting to capture hard disc, mountpoint, filesystem, and partition information..."
touch collection/OS_discandfsinfo.txt
echo "Contents of /etc/fstab: " >> collection/OS_discandfsinfo.txt
cat /etc/fstab >> collection/OS_discandfsinfo.txt
echo " " >> collection/OS_discandfsinfo.txt
echo "Output of mount command: " >> collection/OS_discandfsinfo.txt
mount >> collection/OS_discandfsinfo.txt
echo " " >> collection/OS_discandfsinfo.txt
echo "Output of df -h command: " >> collection/OS_discandfsinfo.txt
df -h >> collection/OS_discandfsinfo.txt
echo "Collection of disc/filesystem/partition information is complete; please see OS_discandfsinfo.txt file"
echo " "
# capture user account information
echo "Capturing user account information...some of this may fail if the script is not run with admin/root privileges"
cat /etc/passwd > collection/users_passwd.txt
cat /etc/group > collection/users_group.txt
cat /etc/master.passwd > collection/users_master.passwd.txt
cat /etc/sudoers > collection/users_sudoers.txt
cp /etc/spwd.db collection/users_spwd.db
# determine likely user account creation date by determining creation datetime of users' home directories
touch collection/users_creationdates.txt
echo "Attempting to determine likely (approximate) creation date & time of user accounts from creation of respective home directories and userlog file..."
echo "stat of /home/*: " >> collection/users_creationdates.txt
stat /home/* >> collection/users_creationdates.txt
echo " " >> collection/users_creationdates.txt
# for FreeBSD:
echo "Content of FreeBSD userlog file: " >> collection/users_creationdates.txt
cat /var/log/userlog >> collection/users_creationdates.txt
# create basic user list
cat collection/users_group.txt | grep -E '[^0-9][0-9][0-9][0-9][0-9][^0-9]' | cut -d: -f1 > collection/users_list.txt
echo "root" >> collection/users_list.txt
# determine users with admin privileges
echo "Attempting to determine users with administrative privileges..."
touch collection/users_withadmin.txt
echo -n "wheel group: " >> collection/users_withadmin.txt
grep -i "wheel:" /etc/group | cut -d: -f4 >> collection/users_withadmin.txt
echo "Collection of information relating to user accounts is complete. Please see collected files with names beginning with "users_" for more information"
echo " "
# determine currently logged-on users
touch collection/users_loggedon.txt
echo "Output of w: " >> collection/users_loggedon.txt
w >> collection/users_loggedon.txt
# add line of cleartext
echo " " >> collection/users_loggedon.txt
echo "Output of who: " >> collection/users_loggedon.txt
who >> collection/users_loggedon.txt
# determine potential use of common encryption technologies...TO FINISH!!
touch collection/encryption.txt
# for FreeBSD:
echo "FreeBSD encryption: " >> collection/encryption.txt
geom -t >> collection/encryption.txt
grep -i "geli_enable" /etc/rc.conf >> collection/encryption.txt
grep -i "geom_eli" /boot/loader.conf >> collection/encryption.txt
grep -i ".eli" /etc/fstab >> collection/encryption.txt
ls -l /etc/geli >> collection/encryption.txt
echo " " >> collection/encryption.txt
# for OpenBSD:
echo "OpenBSD encryption: " >> collection/encryption.txt
bioctl -l >> collection/encryption.txt
bioctl $(awk '$2 == "/" { print $1 }' /etc/fstab) >> collection/encryption.txt
echo " " >> collection/encryption.txt
# for NetBSD:
echo "NetBSD encryption: " >> collection/encryption.txt
cgdconfig -l >> collection/encryption.txt
cat /etc/cgd/cgd.conf >> collection/encryption.txt
echo " " >> collection/encryption.txt
# check for ZFS encryption:
echo "ZFS-based encryption info: " >> collection/encryption.txt
zfs get encryption >> collection/encryption.txt





# capture information from log files
echo "Capturing information from logs relating to failed & successful logins, and likely signs of brute-force login attempts, including archived logs..."
touch collection/logs_loginsuccess.txt
touch collection/logs_loginfailure.txt
touch collection/logs_sumisuse.txt
touch collection/logs_last.txt
# capture info from last command (wtmp/utx.log file)
last > collection/logs_last.txt
# capture successful logins
# for FreeBSD:
grep -i "login on" /var/log/auth.log >> collection/logs_loginsuccess.txt
grep -i "login on" /var/log/auth.log.0 >> collection/logs_loginsuccess.txt
zgrep -a "login on" /var/log/auth.log.*.gz >> collection/logs_loginsuccess.txt
grep -i "root login" /var/log/auth.log >> collection/logs_loginsuccess.txt
grep -i "root login" /var/log/auth.log.0 >> collection/logs_loginsuccess.txt
zgrep -a "root login" /var/log/auth.log.*.gz >> collection/logs_loginsuccess.txt
grep -i "login\[" /var/log/messages >> collection/logs_loginsuccess.txt
grep -i "login\[" /var/log/messages.0 >> collection/logs_loginsuccess.txt
zgrep -a "login\[" /var/log/messages.*.gz >> collection/logs_loginsuccess.txt
# for OpenBSD:
grep -i "login:" /var/log/authlog >> collection/logs_loginsuccess.txt
grep -i "to root" /var/log/authlog >> collection/logs_loginsuccess.txt
zgrep a- "login:" /var/log/authlog.*.gz >> collection/logs_loginsuccess.txt
zgrep a- "to root" /var/log/authlog.*.gz >> collection/logs_loginsuccess.txt


# capture login failures etc.
# for FreeBSD:
grep -i "login failure" /var/log/auth.log >> collection/logs_loginfailure.txt
grep -i "login failure" /var/log/auth.log.0 >> collection/logs_loginfailure.txt
zgrep -a "login failure" /var/log/auth.log.*.gz >> collection/logs_loginfailure.txt
# for OpenBSD:
echo " " >> collection/logs_loginfailure.txt
echo "NB: OpenBSD does not record failed logins for standard users by default" >> collection/logs_loginfailure.txt
# capture information on potential misuse of su command
# for FreeBSD:
grep -i "bad su" /var/log/auth.log >> collection/logs_sumisuse.txt
grep -i "bad su" /var/log/auth.log.0 >> collection/logs_sumisuse.txt
zgrep -a "bad su" /var/log/auth.log.*.gz >> collection/logs_sumisuse.txt
# for OpenBSD:
grep -i "bad su" /var/log/authlog >> collection/logs_sumisuse.txt
zgrep -a "bad su" /var/log/authlog.*.gz >> collection/logs_sumisuse.txt


# capture information relating to sytem power on/off/reboot events
touch collection/logs_powerevents.txt
# start with power-on events
echo "Power on events: " >> collection/logs_powerevents.txt
# for FreeBSD:
grep -i "<<BOOT>>" /var/log/messages >> collection/logs_powerevents.txt
grep -i "<<BOOT>>" /var/log/messages.0 >> collection/logs_powerevents.txt
zgrep -a "<<BOOT>>" /var/log/messages.*.gz >> collection/logs_powerevents.txt
# for OpenBSD:
grep -i "bootblocks" /var/log/messages >> collection/logs_powerevents.txt
zgrep -a "bootblocks" /var/log/messages.*.gz >> collection/logs_powerevents.txt


# now do power-off events
echo "Power off events: " >> collection/logs_powerevents.txt
# for FreeBSD:
grep -i "shutdown[" -A 2 /var/log/messages >> collection/logs_powerevents.txt
grep -i "shutdown[" -A 2 /var/log/messages.0 >> collection/logs_powerevents.txt
zgrep -a "shutdown[" -A 2 /var/log/messages.*.gz >> collection/logs_powerevents.txt
grep -i "halt[" -A 2 /var/log/messages >> collection/logs_powerevents.txt
grep -i "halt[" -A 2 /var/log/messages.0 >> collection/logs_powerevents.txt
zgrep -a "halt[" -A 2 /var/log/messages.*.gz >> collection/logs_powerevents.txt
# for OpenBSD:
echo "NB: OpenBSD does not record shutdown events in the messages log by default...see logs_last.txt file instead" >> collection/logs_powerevents.txt


# now do reboots
echo "Reboot events: " >> collection/logs_powerevents.txt
# for FreeBSD:
grep -i "reboot\[" -A 3 /var/log/messages >> collection/logs_powerevents.txt
grep -i "reboot\[" -A 3 /var/log/messages.0 >> collection/logs_powerevents.txt
zgrep -a "reboot\[" -A 3 /var/log/messages.*.gz >> collection/logs_powerevents.txt
# for OpenBSD:
grep -i "reboot:" /var/log/messages >> collection/logs_powerevents.txt
zgrep -a "reboot:" /var/log/messages.*.gz >> collection/logs_powerevents.txt


# capture information relating to USB device history & usage
touch collection/logs_USB.txt
# gather information about USB interactions
# for FreeBSD:
grep -i -B 2 -A 10 "umass[0-9]: <" /var/log/messages >> collection/logs_USB.txt
grep -i -B 2 -A 10 "umass[0-9]: <" /var/log/messages.0 >> collection/logs_USB.txt
# for OpenBSD:
grep -i -A 4 ": umass[0-9] at" /var/log/messages >> collection/logs_USB.txt
# USB removal:
grep -i -B 2 "umass[0-9]: detached" /var/log/messages >> collection/logs_USB.txt
grep -i -B 2 "umass[0-9]: detached" /var/log/messages.0 >> collection/logs_USB.txt
zgrep -a -B 2 "umass[0-9]: detached" /var/log/messages.*.gz >> collection/logs_USB.txt


# collect users' shell history files
echo "Attempting to collect shell history data..."
ts=$(date +%Y%m%d_%H%M%S)
mkdir -p collection/shellhistory
awk -F: '($3>=1000 && $7!~/(nologin|false)$/)||$1=="root"{print $1":"$6}' /etc/passwd |
while IFS=: read -r user homedir; do
    [ -d "$homedir" ] && {
        cat "$homedir/.bash_history" > "collection/shellhistory/${user}_bash_$ts.txt"
        cat "$homedir/.sh_history" > "collection/shellhistory/${user}_sh_$ts.txt"
        cat "$homedir/.zsh_history" > "collection/shellhistory/${user}_zsh_$ts.txt"
        cat "$homedir/.local/share/fish/fish_history" > "collection/shellhistory/${user}_fish_$ts.txt"
        cat "$homedir/.history" > "collection/shellhistory/${user}_csh_$ts.txt"
		cat "$homedir/.mksh_history" > "collection/shellhistory/${user}_mksh_$ts.txt"
    }
done
find collection/shellhistory -type f -exec md5 {} \; > "collection/shellhistory/hashlist.txt"
echo "Shell history collected. Please see the contents of the collection/shellhistory folder."
# primary data collection complete, optional collection follows
echo "Primary data collection complete. Secondary (optional) collections commencing..."
echo " "


# hash collected files and stores the output for audit purposes
# creation of hashlist.txt file
touch hashlist.txt
# hash and store file hashes and names
md5 collection/* >> hashlist.txt
mv hashlist.txt collection/0_hashlist.txt
echo "MD5 of hashlist.txt file: " >> logfile.txt
md5 collection/0_hashlist.txt >> logfile.txt
# finishing up
echo "Moving case logfile.txt (if present) into collection directory and renaming to 0_logfile.txt..."
mv logfile.txt collection/0_logfile.txt
echo "NB: if you named this file something different from "logfile.txt", you will need to obtain it manually"
echo "Script complete. Remember to acquire a copy of the collection folder (and if necessary delete both it and the script from the live system)!"