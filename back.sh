#!/bin/bash
root=`pwd`;
. $root/dev/backup.sh;		# All about backup
. $root/dev/hosts.sh;		# Host`s managment
. $root/dev/restore.sh; 	# All restore functions
. $root/dev/enchant.sh; 	# Some cool output
logfile="$root/log.txt";	# Path to log file
mkdir -p $root/storage; 	# Check storage dir
mkdir -p $root/hosts; 		# Check host dir

case $1 in
*) echo -e "\tUsage: [help|backup {list|host_name backup_name}|restore {list|backup_name host_name}]";
;;
help) less $root/README.md;
;;
log) less $logfile;
;;
backup) backupC "$2" "$3" "$4";
;;
restore) restoreC "$2" "$3" "$4";
;;
esac;
