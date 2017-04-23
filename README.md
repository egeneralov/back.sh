# back.sh

## Description

Backup linux remote host easy.

## Warning

- For ssh connection will be used default ssh key, or you need to manual enter the password.
- Before each backup will check rsync installation via *apt-get install -y rsync*
- In each restore ALL files in remote will be rewrited (not devices or process)
- Log files will be placed in backup

## Use

### Log

	back.sh log
		[20.02.2017 20:30] {backup|restore} {host name} {host ip}

### Create host

- **mkdir hosts/example_host**
- **nano hosts/example_host/config.sh**
- **chmod +x hosts/example_host/config.sh**

**config.sh**

	#!/bin/bash
	host=123.123.123.123
	user=root	# recommend use root - sudo will not work

If you need to do something in remote before backup - *like stop database server*

- Create bash script in **hosts/example_host/before.sh**
- **chmod +x hosts/example_host/before.sh**

If you need to do something in remote after backup - *like start database server*

- Create bash script in **hosts/example_host/after.sh**
- **chmod +x hosts/example_host/after.sh**

**before.sh** or **after.sh**

	#!/bin/bash
	/etc/init.d/service stop	# use full path
	pwd=/				# work directory will be /

## Host list

	back.sh host list

## Create backup

	back.sh backup example_host name_of_backup "note"

## List of backup`s

	back.sh backup list
		[date] [name]

## Restore backup

	back.sh restore name_of_backup example_host [reboot]
