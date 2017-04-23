#!/bin/bash

backupC () {
	case $1 in
	list) ls $root/hosts/;
	;;
	*) create_backup "$2" "$3";
	;;
	esac;
}

create_backup () {
	echo "Creating backup";
}
