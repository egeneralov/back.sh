#!/bin/bash

hostC () {
	case $1 in
	list) ls $root/hosts/;
	;;
	create) create_host "$2" "$3" "$4";
	;;
	delete) delete_host "$2";
	;;
	*) error "\t host	[list|create \$host_name \$host_ip|delete \$host_name]";
	;;
	esac;
}

create_host () {
	host_name=$1;
	host_ip=$2;
	if [ -z $host_name ];
	then
		host_name=`question "Enter host name"`;
		host_ip=`question "Enter host ip"`;
		create_host $host_name $host_ip;
		nano "$root/hosts/$host_name/before.sh";
		nano "$root/hosts/$host_name/after.sh";
	else
		if [ -z $host_ip ];
		then
			error "Enter IP addres for host";
		else
			mkdir -p "$root/hosts/$host_name";
			cat $root/back.sh | head -n 1 > "$root/hosts/$host_name/config.sh";
			echo "host_ip=$host_ip" >> "$root/hosts/$host_name/config.sh";
			touch "$root/hosts/$host_name/"{before.sh,after.sh};
			chmod +x "$root/hosts/$host_name/"*;
			cat $root/back.sh | head -n 1 > "$root/hosts/$host_name/before.sh";
			cat $root/back.sh | head -n 1 > "$root/hosts/$host_name/after.sh";
			echo "# commands in this file will be runned BEFORE backup" >> "$root/hosts/$host_name/before.sh";
			echo "# commands in this file will be runned AFTER backup" >> "$root/hosts/$host_name/after.sh";
		fi;
	fi;
}

delete_host () {
	host_name=$1;
	if [ -z "$host_name" ]; then error "Specify host name"; fi;
	if [ ! -d "$root/hosts/$host_name" ]; then error "Host not found"; fi;
	sure_delete=`question "Delete host $host_name [y/N]"`;
	if [[ $sure_delete == "y" ]]; then rm -rf "$root/hosts/$host_name" && info "Host $host_name deleted." || error "Failed to delete $root/hosts/$hosts"; fi;
	if [[ $sure_delete == "Y" ]]; then rm -rf "$root/hosts/$host_name" && info "Host $host_name deleted." || error "Failed to delete $root/hosts/$hosts"; fi;
}
