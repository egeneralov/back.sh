#!/bin/bash
info () { echo -e "\t\e[1m\e[42m[info]\e[0m \e[92m$1\e[0m"; }
warning () { echo -e "\t\e[1m\e[93m[warn]\e[0m\e[93m\e[1m $1\e[0m"; }
error () { echo -e "\t\e[1m\e[41m[error]\e[0m\e[91m $1\e[0m"; exit; }
question () { read -p "`echo -e \"\t\e[1m\e[93m[question\e[93m]\e[0m \e[1m\e[93m$1: \e[0m\";`" test; echo $test; }

## Tests
#echo `question "Ask"` > /dev/null;
#info "Info";
#warning "Warn";
#error "Failed";
