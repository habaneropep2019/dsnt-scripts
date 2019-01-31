#!/bin/bash

# (C) Copyright 2018 Alec Bloss. All rights reserved. 

# This is a Dissonant build utility.

# This program is dual-licensed.

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#    (1) Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer. 
#
#    (2) Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with the
#    distribution.  
#    
#    (3)The name of the author may not be used to
#    endorse or promote products derived from this software without
#    specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
# IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# This script builds the tempchain

# SET mktempchain_CFG_RELEASE

mktempchain_release="1"

# Load tempchain configuration options from tempchain.conf

source $HOME/dsnt-tree/tempchain.conf


## FUNCTIONS

function dsp_header {

        echo "Dissonant mktempchain `echo $mktempchain_release`"
        echo "========================================================================="
        echo ""
}

function dsp_clear {
        clear
}

function dbk {
        echo ""
}


# Clear the screen and display an information message

dsp_clear


echo "mktempchain release $fetchtree_release"
echo ""
echo "(C) Copyright 2018 Alec Bloss. All rights reserved."
echo "Licensed under the GNU GPL version 3 (or, at your option, any later version)"
echo "This is a Dissonant build utility."
echo ""
echo "Checking shell version"
if [ -z "${BASH_VERSINFO}" ] || [ -z "${BASH_VERSINFO[0]}" ] || [ ${BASH_VERSINFO[0]} -lt 4 ]; then echo "This script requires Bash version >= 4"; exit 1; fi

sleep 2s

dsp_clear

dsp_header

echo "Welcome to the Dissonant tempchain build system."
echo "This script will guide you through the process."
dbk
echo "Your current build settings are as follows:"
echo "---------------------------------------------"
echo "Dissonant Build ID: $DSNTBUILDID"
echo "CPU Threads Available: $THREADSAVAIL"
dbk
read -p "Does this look correct? (y/n):" Dconfirmsettings

if [ "$Dconfirmsettings" = "n" ] || [ "$Dconfirmsettings" = "N" ]
	then
		echo "User aborted."
		echo "Exiting."
		sleep 1s
		exit 2
fi	

sleep 2s

dsp_clear

dsp_header

echo "Now we need to set up your working directory for this build.

echo "Creating directory structure..."
dbk

cd $HOME/dsnt-working/$DSNTBUILDID
mkdir -v build
mkdir -v disk
mkdir -v tmp
mkdir -v scripts
mkdir -v logs
mkdir -v doc
mkdir -v .status
##status
touch .status/directory-struct
##
touch logs/mktempchain.log

dbk
echo "Logging enabled."
##log
echo "mktempchain.log" >> logs/mktempchain.log
echo "-------------------" >> logs/mktempchain.log
echo "Dissonant mktempchain release $mktempchain_release" >> log/mktempchain.log
echo "Tempchain configuration:" >> log/mktempchain.log
echo "Selected Dissonant build ID: $DSNTBUILDID" >> log/mktempchain.log
echo "CPU Threads setting: $THREADSAVAIL" >> log/mktempchain.log
echo "Log initialization timestamp: `date +%Y%m%d_%H%M%S%Z`" >> log/mktempchain.log
echo "Detected host system kernel: `uname -a`" >> log/mktempchain.log
echo "============================BEGIN LOG============================" >> log/mktempchain.log
echo "`date +%Y%m%d_%H%M%S%Z` Logging enabled" >> log/mktempchain.log
##

##status
touch .status/enable_logging
##
sleep 1s
echo "Directory structure created."
##log
echo "`date +%Y%m%d_%H%M%S%Z` Directory structure created" >> log/mktempchain.log
##endlog

sleep 1s


dsp_clear

dsp_header

echo "Now we need to create a disk image. This will take up approximately"
echo "15GB of disk space."
read -p "Do you wish to continue? (y/n):" Dconfirmimgcreate

if [ "$Dconfirmimgcreate" = "n" ] || [ "$Dconfirmimgcreate" = "N" ]
	then
		echo "User aborted."
		echo "Exiting."
		sleep 1s
		exit 2
fi

dbk
dbk
sleep 1s
echo "Creating disk image, this may take a while..."
dbk

cd $HOME/dsnt-working/$DSNTBUILDID/disk
##log
echo "`date +%Y%m%d_%H%M%S%Z` Starting disk image creation" >> $HOME/dsnt-working/$DSNTBUILDID/log/mktempchain.log
##endlog
dd if=/dev/zero of=root.img bs=1024k count=15360 2>&1 | tee $HOME/dsnt-working/$DSNTBUILDID/log/mktempchain.log
##log
echo "`date +%Y%m%d_%H%M%S%Z` Finished creating disk image" >> $HOME/dsnt-working/$DSNTBUILDID/log/mktempchain.log
##endlog
##status
touch $HOME/dsnt-working/$DSNTBUILDID/.status/create_diskimage
##
##log
echo "`date +%Y%m%d_%H%M%S%Z` Creating filesystem on disk image" >> $HOME/dsnt-working/$DSNTBUILDID/log/mktempchain.log
##endlog
/usr/sbin/mkfs.ext4 root.img 2>&1 | tee $HOME/dsnt-working/$DSNTBUILDID/log/mktempchain.log
##log
echo "`date +%Y%m%d_%H%M%S%Z` Finished creating filesystem on disk image" >> $HOME/dsnt-working/$DSNTBUILDID/log/mktempchain.log
##endlog
##status
touch $HOME/dsnt-working/$DSNTBUILDID/.status/create_fs_diskimage
##

sleep 2s

# We need to prompt the user to add an fstab entry so normal users can access this image
# There are a few steps that have to be done as root - in a separate shell.
# We make this as easy as possible and just give the user a 'one-liner' to copy and paste and run as root.

dsp_clear

dsp_header

echo "Adding configuration details to tempchain.conf..."

echo "DISKIMGLOC=\"\$HOME/dsnt-working/\$DSNTBUILDID/disk/root.img\"" >> $HOME/dsnt-tree/tempchain.conf
echo "DISKIMGMNTLOC=\"\$HOME/dsnt-working/\$DSNTBUILDID/disk/mnt\"" >> $HOME/dsnt-tree/tempchain.conf
echo "DSNTWORKINGROOT=\"\$HOME/dsnt-working/\$DSNTBUILDID\"" >> $HOME/dsnt-tree/tempchain.conf
##log
echo "`date +%Y%m%d_%H%M%S%Z` Added additional configuration details to tempchain.conf" >> $HOME/dsnt-working/$DSNTBUILDID/log/mktempchain.log
##endlog
##status
touch $HOME/dsnt-working/$DSNTBUILDID/.status/add_diskimg_to_config
touch $HOME/dsnt-working/$DSNTBUILDID/.status/add_dsntworkingroot_to_config
##

dbk

echo "Creating mount point for diskimage..."
mkdir $HOME/dsnt-working/$DSNTBUILDID/disk/mnt
##log
echo "`date +%Y%m%d_%H%M%S%Z` Created mount point for diskimage" >> $HOME/dsnt-working/$DSNTBUILDID/log/mktempchain.log
##endlog
##status
touch $HOME/dsnt-working/$DSNTBUILDID/.status/create_diskimage_mnt
##

echo "Generating the script needed for the next step, please wait..."

echo "Put untar and copy part here..."

dsp_clear

dsp_header

echo "There are a few steps that need to be performed as root."
echo "To make this easy for you, a script has been created."
echo "You will need to leave this program running, and open"
echo "another terminal. Then, log in as root."
dbk
echo "Then, as root, run the following command:"
dbk
echo "bash $HOME/dsnt-working/$DSNTBUILDID/scripts/asrootsetup.sh"
dbk
dbk
sleep 5s
echo "Waiting for you to run asrootsetup..."

while [ ! -e "$HOME/dsnt-working/$DSNTBUILDID/.status/create_diskimage_mnt" ]
do
	sleep 2s
done

echo "Detected completion status."
dbk
echo "Please confirm that you have run asrootsetup.sh"
echo "and that it has completed successfully\?"
echo "If not, please do so before continuing."
read -p "Press any key to continue."

##log
echo "`date +%Y%m%d_%H%M%S%Z` Attempting to mount the diskimage as a normal user" >> $HOME/dsnt-working/$DSNTBUILDID/log/mktempchain.log
##endlog

echo "Attempting to mount the diskimage, please wait..."
mount -v $HOME/dsnt-working/$DSNTBUILDID/disk/mnt 2>&1 | tee $HOME/dsnt-working/$DSNTBUILDID/log/mktempchain.log
echo "Checking for successful mount..."

if [ ! -d "$HOME/dsnt-working/$DSNTBUILDID/disk/mnt/lost+found" ] # <<Change this to a created directory
	then
		echo "Diskimage mount as normal user failed."
		##log
		echo "`date +%Y%m%d_%H%M%S%Z` Diskimage mount as normal user failed. See log lines above." >> $HOME/dsnt-working/$DSNTBUILDID/log/mktempchain.log
		##endlog
		exit 1
fi

echo "Mount appears to be successful."
##log
echo "`date +%Y%m%d_%H%M%S%Z` Mounted diskimage as a normal user successfully" >> $HOME/dsnt-working/$DSNTBUILDID/log/mktempchain.log
##endlog
##status
touch $HOME/dsnt-working/$DSNTBUILDID/.status/mount_diskimage_normal_user_success
##




exit 0