#!/bin/bash

# -------------------------
# Script for check and add to a log file all services running on the server and memory status 
# By isaac.gasi@gmail.com
# 2014-04-07
# -------------------------

#--------settings--------

#define duration execution in minutes
min=10
#define runs every few seconds
runsevery=1

#--------logic-----------
advance=''
#Declare path/file to save output log
path='/var/log/'
sufix="$(date +'%d-%m-%Y')"
servicelogfile=$path'services-'$sufix'.log'
memorylogfile=$path'memory-'$sufix'.log'

#calculate durate execution
timeexecution=$(($min*60))
#Inicilizate real time exexution
second=0

# Declare services list
declare -a serviceslist

#Get all services on server only ubuntu
#serviceslist=($(service --status-all | awk '{ print $4 }' ))

#Get all services
serviceslist=($(ls /etc/init.d/ ))

numberofservices=${#serviceslist[@]}
#clear

while [[ $second -lt $timeexecution ]]
do

	#Verifing status of services
	echo ====Number_of_services_to_status_evaluated:_$numberofservices=============================== >> $servicelogfile
	for index in ${!serviceslist[*]}
	do
		#Get date and time 
		now="$(date +'[ %d-%m-%Y %H:%M:%S %Z %:z ]')"
		
		servicestatus=($(sudo service ${serviceslist[$index]} status | tr -d '\r'))
	    printf "%4d %s %s --> %s \n" $index "$now" "${serviceslist[$index]}" "${servicestatus[*]}" >> $servicelogfile
	done

	#Log for memory status
    memorystatus=($(free -m))
	printf "%s %s \n" "$now" "${memorystatus[*]}" >> $memorylogfile	    

	#Time execution control
	sleep $runsevery
	((second++))
	advance="$advance="
	clear
	echo $second / $timeexecution $advance

done