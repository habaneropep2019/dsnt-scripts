#!/bin/bash

# (C) Copyright 2018 Alec Bloss. All rights reserved. 

# This is a Dissonant build utility.

# This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

# This script performs the actions for setting up the tempchain that need to be done as root.

# Load tempchain configuration options from tempchain.conf

source $HOME/dsnt-tree/tempchain.conf


clear


echo "asrootsetup"
echo ""
echo "(C) Copyright 2018 Alec Bloss. All rights reserved."
echo "Licensed under the GNU GPL version 3 (or, at your option, any later version)"
echo "This is a Dissonant build utility."
echo ""
echo "Checking shell version"
if [ -z "${BASH_VERSINFO}" ] || [ -z "${BASH_VERSINFO[0]}" ] || [ ${BASH_VERSINFO[0]} -lt 4 ]; then echo "This script requires Bash version >= 4"; exit 1; fi

sleep 2s

echo "Performing setup actions..."
echo ""
echo "Adding fstab entry..."
echo ""

echo "$DISKIMGLOC $DISKIMGMNTLOC ext4 user,rw,exec,dev,relatime,auto,suid 0 2" >> /etc/fstab
##log
echo "`date +%Y%m%d_%H%M%S%Z` Created fstab entry for diskimage" >> $DSNTWORKINGROOT/log/mktempchain.log
##endlog
##status
touch $DSNTWORKINGROOT/.status/create_diskimage_mnt
##

echo "Mounting diskimage to create initial structure..."
mount -v $DISKIMGMNTLOC 2>&1 | tee $HOME/dsnt-working/$DSNTBUILDID/log/mktempchain.log
echo "Checking for successful mount, please wait..."

if [ ! -d "$DISKIMGMNTLOC/lost+found ]
then
	##log
	echo "`date +%Y%m%d_%H%M%S%Z` Attempting to mount the diskimage as root" >> $HOME/dsnt-working/$DSNTBUILDID/log/mktempchain.log
	##endlog
	echo "Diskimage mount as root failed. Please check the log."
	exit 1
fi

echo "Mount as root appears to be successful."
##log
echo "`date +%Y%m%d_%H%M%S%Z` Mounted diskimage as root successfully" >> $HOME/dsnt-working/$DSNTBUILDID/log/mktempchain.log
##endlog
##status
touch $HOME/dsnt-working/$DSNTBUILDID/.status/mount_diskimage_root_success
##

# ¬! We need to create the directories on the diskimage as root and set permissions correctly.


echo "Root procedures finished, please go back to the other terminal."

exit 0



