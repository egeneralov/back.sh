#!/bin/bash

restoreC () {
	case $1 in
	list) ls $root/storage/;
	;;
	*) create_restore "$2" "$3";
	;;
	*) error "Failed to restore - incorrect command";
	;;
	esac;
}

create_restore () {
	echo "Creating restore";
}
