#!/bin/bash
# Script by Derekcat (Derek DeMoss) to test a disk under *nix systems, originally written in 2013

# Variables
thrash_path="/var/thrash" # No trailing slash
max_seconds=60 # Between operations
thrash_size=1 # How much space to use in GB
let thrash_seq_end=$thrash_size*19 # Convert GB into how many thrash files we need to create

# Functions
help ()
{
        echo -e "Usage: $0"
        echo -e "Test writing to a disk with random interval."
        echo -e ""
        echo -e "Optional arguments:"
        echo -e "\t-h | --help\tPrint this help message and exit"
}

random_sleep ()
{
	sleep_number=$[ ( $RANDOM % $max_seconds ) + 1 ]
	echo "Now sleeping: $sleep_number seconds"
	sleep $sleep_number
}

# Main execution code
# Setup source and directory
echo "Thrash working directory: $thrash_path"
echo "Thrash max sleep: $max_seconds"
echo "Thrash max GB usage: $thrash_size"
echo "Thrash max thrash file count: $thrash_seq_end"

echo "Creating $thrash_path and $thrash_path/thrash-source"
mkdir -p $thrash_path
nice -n 20 dd if=/dev/urandom of=$thrash_path/thrash-source bs=1024 count=262144 

# Write files
for i in $( seq 1 $thrash_seq_end ); do
	echo creating file: $i
	nice -n 20 dd if=$thrash_path/thrash-source of=$thrash_path/thrash-file$i bs=214748364 count=1 
	random_sleep
done

# Delete files
for i in $( seq 1 $thrash_seq_end ); do
	echo now deleting file: $i
	rm $thrash_path/thrash-file$i
	random_sleep
done

# Cleanup
rm -rf $thrash_path/thrash*
