#!/bin/bash

backupC () {
	case $1 in
	list) ls $root/hosts/;
	;;
	do) create_backup "$2" "$3";
	;;
	*) error "Failed to backup - incorrect command";
	;;
	esac;
}

create_backup () {
	echo "Creating backup";
}
