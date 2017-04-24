#!/bin/bash

backupC () {
	case $1 in
	list) ls --color=auto $root/storage/;
	;;
	create) create_backup "$2" "$3";
	;;
	delete) delete_backup "$2";
	;;
	*) error "\t backup  [list|create \$host_name \$backup_name|delete \$backup_name]";
	;;
	esac;
}

create_backup () {
	host_name=$1;
	backup_name=$2;
	if [ -f "$root/hosts/$host_name/config.sh" ]; then info "Host found"; . "$root/hosts/$host_name/config.sh"; else error "No such host"; fi; 		# check host config exist
	if [ -z "$backup_name" ]; then error "Specify backup name"; else mkdir -p "$root/storage/$backup_name"; fi; 									# Check name for backup
	if ping -c 2 $host_ip > /dev/null 2>&1; then info "Server online"; else error "Failed to ping server"; fi; 										# Check network connection to server
	ssh -q -o "BatchMode=yes" root@$host_ip "echo 2>&1" > /dev/null 2>&1 && info "Test SSH connection successfully" || error "Failed to connect"; 	# Check ssh connection to server 

	ssh -o "BatchMode=yes" root@$host_ip '/usr/bin/apt-get install -y rsync acl > /dev/null 2>&1' > /dev/null 2>&1 && info "Rsync and acl installed" || error "Failed to install rsync or acl"; # Force apt-get install 
	ssh -o "BatchMode=yes" root@$host_ip 'getfacl -R / > /perms.acl' > /dev/null 2>&1 && info "Permissions backup successfully" || error "Failed to backup permissions";  # Backup permissions

	if [ -f "$root/hosts/$host_name/before.sh" ]; then  		# If file before.sh exist - upload and run - else warn user
		scp "$root/hosts/$host_name/before.sh" root@$host_ip:/before.sh > /dev/null 2>&1 || error "Failed to upload before.sh";
		ssh -o "BatchMode=yes" root@$host_ip '/before.sh' > /dev/null && info "Runned before.sh successfully" || error "Failed to run before.sh";
	else warning "Script before.sh not exist"; fi;

	info "Backup started";		# Rsync must exclude devices and process save to back.sh/storage/name_of_backup
	rsync -ar -e ssh --perms --group --owner --xattrs --acls --delete-after --force --compress --specials --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} root@$host_ip:/ "$root/storage/$backup_name/" > /dev/null || error "Failed to backup $host_name";
	info "Backup finished. Size: `du -sh $root/storage/$backup_name | awk '{print $1}'`";

	if [ -f "$root/hosts/$host_name/after.sh" ]; 
	then 
		scp "$root/hosts/$host_name/after.sh" root@$host_ip:/after.sh > /dev/null 2>&1 || error "Failed to upload after.sh";
		ssh -o "BatchMode=yes" root@$host_ip '/after.sh' > /dev/null && info "Runned after.sh successfully" || warning "Failed to run after.sh";
	else
		warning "Script before.sh not exist";
	fi;
}

delete_backup () {
	backup_name=$1;
	if [ -z "$backup_name" ]; then error "Specify backup name"; fi;
	if [ ! -d "$root/storage/$backup_name" ]; then error "Backup not found"; fi;
	sure_delete=`question "Delete backup $backup_name [y/N]"`;
	if [[ $sure_delete == "y" ]]; then rm -rf "$root/storage/$backup_name" && info "Backup $backup_name deleted." || error "Failed to delete $root/storage/$backup_name"; fi;
	if [[ $sure_delete == "Y" ]]; then rm -rf "$root/storage/$backup_name" && info "Backup $backup_name deleted." || error "Failed to delete $root/storage/$backup_name"; fi;
}
