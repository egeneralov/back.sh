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
help) less $root/README.md;
;;
log) less $logfile;
;;
host) hostC "$2" "$3" "$4";
;;
backup) backupC "$2" "$3" "$4" "$5";
;;
restore) restoreC "$2" "$3" "$4" "$5";
;;
*) # In default case - we showing mini help
	info "Usage: [help|host|backup|restore]";
	info "\t host	[list|create \$host_name \$host_ip|delete \$host_name]";
	info "\t backup  [list|create \$host_name \$backup_name|delete \$backup_name]";
	info "\t restore  [list|create \$backup_name \$host_name]";
;;
esac;
