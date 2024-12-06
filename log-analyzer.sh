#!/bin/bash

#vars
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
bold=$(tput bold)
normal=$(tput sgr0)

if [ -z "$1" ]; then
	echo -e "${RED}Please provide a log file!${NC}"
	exit 1
elif [ -f "$1" ]; then
	LOG_FILE=$1
	echo "${bold}Top 5 IP addresses with the most requests${normal}"
	awk '{print $1}' $LOG_FILE | sort | uniq -c | sort -nr | awk '{print $2,"-",$1 " request"}' | head -n 5 

	echo ""

	echo "${bold}Top 5 most requested paths${normal}"
	awk -F '"' '{print $2}' $LOG_FILE | awk '{print $2}' | sort | uniq -c | sort -nr | awk '{print $2,"-",$1 " request"}' |head -n 5 

	echo ""

	echo "${bold}Top 5 response status codes${normal}"
	awk -F '"' '{print $3}' $LOG_FILE | awk '{print $1}' | sort | uniq -c | sort -nr | awk '{print $2,"-",$1 " request"}' | head -n 5

	echo ""
	echo "${bold}Top 5 user agents${normal}"
	awk -F '"' '{print $6}' $LOG_FILE | sort | uniq -c | sort -nr | awk '{for(i=2;i<=NF;i++) printf "%s ", $i; print "-\t",$1, " request"}' | head -n 5
	
	echo ""
else
	echo -e "${RED}File not found: $1${NC}"
	exit 1
fi
