# HowToRestore

Backup running correctly. BUT restore - need an upgrade.

1. Open ssh connection to system restore
2. Make sure, your target system have enought space
3. MANUALY backup /etc/network/interfaces and /etc/fstab
4. DO NOT CLOSE SSH!
5. Restore system via back.sh
6. After restore:
6.1 via OPENED ssh connection manualy rewrite fstab and network files.
6.2 via OPENED ssh connection run: update-grub && grub-install --force /dev/sda
