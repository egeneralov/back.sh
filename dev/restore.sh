#!/bin/bash

restoreC () {
	case $1 in
	list) ls $root/storage/;
	;;
	*) create_restore "$2" "$3";
	;;
	esac;
}

create_restore () {
	echo "Creating restore";
}
