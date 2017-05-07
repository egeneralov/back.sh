#!/bin/bash
wget https://cloud.takepage.ru/back.sh-v0.3-release.tar
tar -xf back.sh-v0.3-release.tar
echo "alias back.sh='~/.back.sh/back.sh'" >> ~/.bashrc
alias back.sh='~/.back.sh/back.sh'
