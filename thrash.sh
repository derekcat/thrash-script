#!/bin/bash
# Script by Derekcat (Derek DeMoss) to test a disk under *nix systems, originally written in 2013

# Variables
thrash_path="/var/thrash" # No trailing slash
declare -i max_seconds
max_seconds=60 # Between operations
declare -i thrash_size
thrash_size=1 # How much space to use in GB
declare -i thrash_seq_end

# Functions
help ()
{
        echo -e "Usage: $0"
        echo -e "Test writing to a disk with random interval."
        echo -e ""
        echo -e "Optional arguments:"
        echo -e "\t-h \tPrint this help message and exit"
        echo -e "\t-p /path/to/use\tSet the path to thrash in (preceeding directories will be created, default /var/thrash)"
        echo -e "\t-s <size in GB>\tSet the size to thrash in integer GB, eg: --size 4"
        echo -e "\t-t <integer in seconds>\tSet the max time between operations in seconds, eg: --time 60 (default)"
}

random_sleep ()
{
	sleep_number=$[ ( $RANDOM % $max_seconds ) + 1 ]
	echo "Now sleeping: $sleep_number seconds"
	sleep $sleep_number
}

# Arugment processing
while getopts ":h:p:s:t" opt; do
	case $opt in
		h)
			nothing="$OPTARG"
			help
			exit
			;;
		p)
			thrash_path="$OPTARG"
			echo "Thrash path set to $thrash_path"
			;;
		s)
			thrash_size="$OPTARG"
			echo "Thrash max size set to $thrash_size GB"
			;;
		t)
			max_seconds="$OPTARG"
			echo "Max time between operations set to $thrash_path seconds"
			;;
		\?)
			echo "ERROR!  Unsupported argument flag $1!  Exiting..."
			help
			exit 1
	esac
done		

# Define calculated variables AFTER argument processing
let thrash_seq_end="$thrash_size*19" # Convert GB into how many thrash files we need to create

# Main execution code
echo "###########################################################################"
echo "Thrash working directory: $thrash_path"
echo "Thrash max sleep: $max_seconds"
echo "Thrash max GB usage: $thrash_size"
echo "Thrash max thrash file count: $thrash_seq_end"

echo "If this is correct, press y, otherwise hit any other key or ^-c"
read sanitycheck
if [ "$sanitycheck" != "y" ]; then
	echo "Aborting on settings check!"
	exit 1
fi
echo "###########################################################################"

# Setup source and directory
echo "Creating $thrash_path and $thrash_path/thrash-source"
mkdir -p $thrash_path
nice -n 20 dd if=/dev/urandom of=$thrash_path/thrash-source bs=1024 count=262144 
echo "###########################################################################"

# Write files
echo "Beggining write sequence"
for i in $( seq 1 $thrash_seq_end ); do
	echo Writing file: $i
	nice -n 20 dd if=$thrash_path/thrash-source of=$thrash_path/thrash-file$i bs=214748364 count=1 
	random_sleep
done
echo "###########################################################################"

# Delete files
echo "Beggining delete sequence"
for i in $( seq 1 $thrash_seq_end ); do
	echo "Deleting file: $i"
	rm $thrash_path/thrash-file$i
	random_sleep
done
echo "###########################################################################"

# Cleanup
echo "Removing thrash_path/thrash*"
rm -rf $thrash_path/thrash*
echo "###########################################################################"

echo "Thrashing complete!"
