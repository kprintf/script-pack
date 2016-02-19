#!/bin/bash
# 2CH grabber by kprintf
# Do what u want with this script
# Requirements: wget grep sed mktemp
QUIET_LEVEL=-q0
SAVE_THREAD=0
THREADS=
PERIOD=NO
for i in "$@"
do
	if [ "$i" == "-h" ]
	then
		echo `echo $0 | grep -o "[^/]*$"` ' - pictures (and threads) grabber from 2ch.hk imageboard'
		echo Usage:
		echo -e '\t board/ID - specify thread ID (may be two or more)'
		echo -e '\t -q0   - print information about every action (default)'
		echo -e '\t -q1   - print info only about new files'
		echo -e '\t -q2   - dont print anything'
		echo -e '\t -s    - save threads (Default is only pictures)'
		echo -e '\t -p[N] - repeat in cycle with sleep period of N seconds'
		exit
	elif [ "$i" == "-q0" ] || [ "$i" == "-q1" ] || [ "$i" == "-q2" ]
	then
		QUIET_LEVEL=$i
	elif [ "$i" == "-s" ]
	then
		SAVE_THREAD=1
	elif [ "`echo "$i" | grep -o '^-p'`" == "-p" ]
	then
		PERIOD=`echo $i | grep -o '[0-9]*$'`
	else
		THREADS="${THREADS} $i"
	fi
done

while true 
do
	for thread in "$THREADS"
	do
		if [ $SAVE_THREAD == 1 ]
		then
			DOCFILE=`echo "${thread}.html" | sed 's/\//_/g' `
		else
			DOCFILE=`mktemp /tmp/grab2ch.XXXXXX`
		fi
		
		DOCPATH=`echo $thread | sed -e 's/\/\([0-9]\)/\/res\/\1/g' `
		
		if [ "$QUIET_LEVEL" == "-q2" ]
		then
			wget -N https://2ch.hk/${DOCPATH}.html -O $DOCFILE > /dev/null 2> /dev/null
		else
			wget -N https://2ch.hk/${DOCPATH}.html -O $DOCFILE 
		fi
		
		for i in `cat ${DOCFILE} | grep -o "/b/src/[^\"']*" | uniq`
		do 
			if [ -f `echo $i | grep -o "[^/]*$"` ] 
			then

				if [ "$QUIET_LEVEL" == "-q0" ]
				then	
					echo $i exists 
				fi

			else 

				if [ "$QUIET_LEVEL" == "-q2" ] 
				then
					wget 2ch.hk${i} > /dev/null 2> /dev/null
				else
					wget 2ch.hk${i} -q --show-progress
				fi

			fi
		done
	done

	if [ "$PERIOD" == "NO" ]
	then 
		exit
	else
		sleep $PERIOD
	fi

done
