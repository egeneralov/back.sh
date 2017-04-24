#!/bin/bash

restoreC () {
	case $1 in
	do) create_restore "$2" "$3";
	;;
	*) error "Failed to restore - incorrect command";
	;;
	esac;
}

create_restore () {
	host_name=$1;
	backup_name=$2;
	sure_network_rewrite=$3;
	if [ -f "$root/hosts/$host_name/config.sh" ]; then info "Host found"; . "$root/hosts/$host_name/config.sh"; else error "No such host"; fi; 		# check host config exist
	if [ -d "$root/storage/$backup_name" ]; then info "Backup found"; else error "No such backup"; fi;
	if ping -c 2 $host_ip > /dev/null 2>&1; then info "Server online"; else error "Failed to ping server"; fi; 										# Check network connection to server
	ssh -q -o "BatchMode=yes" root@$host_ip "echo 2>&1" > /dev/null 2>&1 && info "Test SSH connection successfully" || error "Failed to connect"; 	# Check ssh connection to server 

	ssh -o "BatchMode=yes" root@$host_ip '/usr/bin/apt-get install -y rsync acl' > /dev/null && info "Rsync and acl installed" || error "Failed to install rsync or acl"; # Force apt-get install 

	if [ -z $sure_network_rewrite ]; then sure_network_rewrite=`question "Save /etc/network/interfaces? [y/N]"`; fi;
	if [[ $sure_network_rewrite == "y" ]]; then 
			scp root@$host_ip:/etc/network/interfaces /tmp/interfaces > /dev/null 2>&1;
	else
		if [[ $sure_network_rewrite == "Y" ]]; then 
			scp root@$host_ip:/etc/network/interfaces /tmp/interfaces > /dev/null 2>&1;
		else rm /tmp/interfaces > /dev/null 2>&1;
		fi;
	fi;

	info "Restore started";		# Rsync must exclude devices and process save to back.sh/storage/name_of_backup
	rsync -aIr -e ssh --perms --group --owner --xattrs --acls --delete-after --force --compress --specials --exclude={"/dev/*","/etc/machine-id","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} "$root/storage/$backup_name/" root@$host_ip:/ > /dev/null || error "Failed to restore $host_name";
	info "Files transfered";
	if [ -f /tmp/interfaces ]; then scp /tmp/interfaces root@$host_ip:/etc/network/ > /dev/null 2>&1 && info "Network config restored" || warning "Failed rewrite: /etc/network/interfaces"; rm /tmp/interfaces; fi;
	ssh -o "BatchMode=yes" root@$host_ip 'setfacl --restore=/perms.acl /' > /dev/null 2>&1 && info "Permissions restored successfully" || warning "Failed to restored permissions";  # Restore permissions
	info "Restore finished.";

	sure_reboot=`question "Reboot $host_name? [y/N]"`;
	if [[ $sure_reboot == "y" ]]; then 
			ssh -o "BatchMode=yes" root@$host_ip 'reboot' > /dev/null 2>&1 && info "Rebooted" || warning "Failed to restored permissions";
	else
		if [[ $sure_reboot == "Y" ]]; then 
			ssh -o "BatchMode=yes" -o "ServerAliveInterval=1" -o "ServerAliveCountMax=1" root@$host_ip 'reboot &' > /dev/null 2>&1 && info "Rebooted" || warning "Failed to reboot";
		fi;
	fi;
}
