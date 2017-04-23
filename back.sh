#!/bin/bash
root=`pwd`;
. $root/dev/backup.sh;		# All about backup
. $root/dev/hosts.sh;		# Host`s managment
. $root/dev/restore.sh; 	# All restore functions
. $root/dev/enchant.sh; 	# Some cool output
logfile="$root/log.txt";

case $1 in
*) less $root/README.md;
;;
log) less $logfile;
;;
backup) backup "$2" "$3" "$4";
;;
restore) restore "$2" "$3" "$4";
;;
esac;
