#!/bin/bash

for i in $( seq 1 10 ); do
	echo creating file: $i
	nice -n 20 dd if=~/thrash/thrash-source of=~/thrash/thrash-file$i bs=214748364 count=1 
	SLEEPNUMBER=$[ ( $RANDOM % 100 ) + 1 ]
	echo now sleeping: $SLEEPNUMBER
	sleep $SLEEPNUMBER
done

SLEEPNUMBER=$[ ( $RANDOM % 100 ) + 1 ]
sleep $SLEEPNUMBER

for i in $( seq 1 10 ); do
	echo now deleting file: $i
	rm ~/thrash/thrash-file$i
	SLEEPNUMBER=$[ ( $RANDOM % 100 ) + 1 ]
	echo now sleeping: $SLEEPNUMBER
	sleep $SLEEPNUMBER
done
