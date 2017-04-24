#!/bin/bash

restoreC () {
	case $1 in
	list) ls --color=auto $root/storage/;
	;;
	create) create_restore "$2" "$3";
	;;
	*) error "Failed to restore - incorrect command";
	;;
	esac;
}

create_restore () {
	host_name=$1;
	backup_name=$2;
	if [ -f $root/hosts/config.sh ]; then info "Host exist"; else error "No such host"; fi;
	if [ -f $root/storage/$backup_name ]; then warning "Backup exist"; else error "No such backup"; fi;
	
}
