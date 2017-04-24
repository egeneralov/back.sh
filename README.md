# back.sh

## Description

Backup remote linux host easy.

## Warning

- For ssh connection will be used default ssh key, or you need to manual enter the password.
- Before each backup will check rsync installation via *apt-get install -y rsync*
- In each restore ALL files in remote will be rewrited (not devices or process)
- Log files will be placed in backup

## Use

### Create host

Manual:

	back.sh host create
		[question] Enter host name: example_host
		[question] Enter host ip: 127.0.0.1
			# Will open 2 files with nano - before.sh and after.sh
Auto:

	back.sh host create example_host 127.0.0.1

**before.sh** or **after.sh**

	#!/bin/bash
	/etc/init.d/service stop	# use full path
	pwd=/				# work directory for script will be /

### Host list

	back.sh host list

### Create backup

	back.sh backup create example_host name_of_backup

### List of backup`s

	back.sh backup list

### Restore backup

	back.sh restore do example_host name_of_backup

Will ask 2 questions:

- Save **/etc/network/interfaces**?
- Reboot host? 		# if you will use DigitalOcean - you got a warn, because logout will not complete, but host **will be** rebooted

	back.sh restore example_host name_of_backup
