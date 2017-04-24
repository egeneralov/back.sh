#!/bin/bash

hostC () {
	case $1 in
	list) ls $root/storage/;
	;;
	create) create_host "$2" "$3";
	;;
	delete) delete_host "$2";
	;;
	*) error "Failed to modify host - incorrect command";
	;;
	esac;
}

create_host () {
	host_name=$1;
	host_ip=$2;
	echo "Creating host";
}

delete_host () {
	host_name=$1;
}
