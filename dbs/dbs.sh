#!/bin/bash

# (C) Copyright 2019 Alec Bloss.

# This is the Dissonant Build System.

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

## HEADER ##

DBSVER="1"
COPYYEAR="2019"

## END HEADER ##

## FUNCTIONS ##

function dexit {
	rm -r /tmp/dbs.$$
	rm "$HOME/dsnt-working/.lock"
	exit $1
}


function dbsstart {
	clear
	echo "Dissonant Build System version $DBSVER"
	echo "(C) Copyright $COPYYEAR Alec Bloss"
	echo ""
	sleep 1s
	echo "Checking shell version"
	if [ -z "${BASH_VERSINFO}" ] || [ -z "${BASH_VERSINFO[0]}" ] || [ ${BASH_VERSINFO[0]} -lt 4 ]; then echo "This script requires Bash version >= 4"; exit 1; fi
	sleep 2s
	echo "Shell version OK"
	echo "Checking for working directory..."
	if [ ! -d "$HOME/dsnt-working" ]
	then
		echo "FATAL: No working directory found!"
		echo "ABORTING"
		dexit 1
	fi
	echo "Checking for existing or failed builds..."
	if [ -a "$HOME/dsnt-working/.lock" ]
	then
		echo "WARNING: Either DBS is currently running, or a previous build was interrupted."
		echo "ABORTING"
		exit 1 # Don't use internal dexit here, otherwise it will inadvertently delete the lock file
	fi
	sleep 1s
	echo "Creating lock..."
	touch "$HOME/dsnt-working/.lock"
	echo "Creating temporary resources..."
	mkdir /tmp/dbs.$$
	if [ ! -f "$HOME/dsnt-tree/dbs.conf" ]
	then
	whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Important<<" --msgbox "No configuration found, please choose Configure from the main menu to create a configuration." 8 75	fi
	fi
	source "$HOME/dsnt-tree/dbs.conf"
}

function daboutmsg {
	whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>About<<" --msgbox \
		"Dissonant Build System version $DBSVER \
		\n \
		(C) Copyright $COPYYEAR Alec Bloss \
		\n \
		This program is licensed under the BSD 3-clause license. \
		\n \
		You can find a copy of this license in $HOME/dsnt-tree/COPYING.BSD3 \
		\n \
		or on the web at https://raw.githubusercontent.com/binaryblob01/dsnt-scripts/master/COPYING.BSD3" 15 125
		dbsmain
}


function dselectmenu {
	if [ ! -d "$HOME/dsnt-working/projects" ]
	then
		whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Error<<" --msgbox "ERROR: No projects have been setup. \nPlease start a new build project" 8 40
		dbsmain
	fi
	pushd "$HOME/dsnt-working/projects" > /dev/null
		menubuild=$(
		for f in *.define; do echo "\"$f\" \"$f\"\\"; done
		)
		popd > /dev/null
	dselectmenuout=$(
		whiptail --notags --backtitle "Dissonant Build System $DBSVER" --title ">>Select build project<<" --menu "Choose a build project" 25 78 16 \
		$menubuild 3>&2 2>&1 1>&3
	)
	CHOICE=$?
	if [ $CHOICE = 1 ]
	then
		dbsmain
	fi
	TERM=ansi whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Loading<<" --infobox "Loading project, please wait..." 7 35
	sleep 3s
	DCURRENTPROJECT=$(echo $dselectmenuout | tr -d \")
	#echo $DCURRENTPROJECT #For debugging variables only
	
}

function dnewmenu {
	whiptail --backtitle "Dissonant Build System $DBSVER" --title "New Project" --msgbox "This wizard will guide you through starting a new project. You will need to choose a Dissonant Build ID to work with. If you do not have a tree currently cloned for that build ID, you will be prompted to clone the tree.\n\nPlease note that you can have multiple projects for the same build ID." 13 100
	TERM=ansi whiptail --backtitle "Dissonant Build System $DBSVER" --title "Loading" --infobox "Loading available build IDs, please wait..." 7 49
	if [ ! -d "$HOME/dsnt-tree/build.manifests" ]
	then
	whiptail --backtitle "Dissonant Build System $DBSVER" --title "Error" --msgbox "ERROR: No builds found in tree. \nPlease clone at least one build tree first" 8 40
		dbsmain
	fi
	if [ ! -d "$HOME/dsnt-working/builds" ]
	then
	TERM=ansi whiptail --backtitle "Dissonant Build System $DBSVER" --title "Warning" --infobox "WARNING: No build directory found. \nCreating..." 8 40
	mkdir "$HOME/dsnt-working/builds" > /dev/null
	fi
	pushd "$HOME/dsnt-tree/build.manifests" > /dev/null
		menubuildtwo=$(
		for f in *.define; do echo "\"$f\" \"$f\"\\"; done
		)
		popd > /dev/null
	dnewmenuout=$(
		whiptail --notags --backtitle "Dissonant Build System $DBSVER" --title "Select build ID" --menu "Choose a build ID for your project" 25 78 16 \
		$menubuildtwo 3>&2 2>&1 1>&3
	)
	CHOICE=$?
	if [ $CHOICE = 1 ]
	then
		dbsmain
	fi
	# Name the project
	dprojectname=$(
	whiptail --backtitle "Dissonant Build System $DBSVER" --title "Name project" --inputbox "Enter a name for your project.\nIt cannot contain spaces or special characters, and is case-sensitive.\n\nAllowed characters are 0-9, a-z, and A-Z.\n\nThis version of DBS does not sanitize this form, so BE SURE you've verified it meets the requirements.\n\n" 15 75 3>&1 1>&2 2>&3
	)
	CHOICE=$?
	if [ $CHOICE = 1 ]
	then
		dbsmain
	fi
	if [ -d "$HOME/dsnt-working/builds/$dprojectname"]
	then
		whiptail --backtitle "Dissonant Build System $DBSVER" --title "ERROR" --msgbox "Project name already in use" 7 35
		dnewmenu
	fi
	dprojectarch=$(
	whiptail --nocancel --notags --backtitle "Dissonant Build System $DBSVER" --title "Select Target Architecture" --radiolist \
	"Choose an architecure. \n\nDBS does not support cross-compiling right now, so it must match your host system." 20 78 6 \
	"i386" "Intel 80386 (32-bit)" ON \
	"i486" "Intel 80486 (32-bit)" OFF \
	"i686" "Intel 80686 (32-bit)" OFF \
	"x86_64" "AMD/Intel x86 (64-bit)" OFF \
	"armhf" "ARM hardware-float (64-bit)" OFF 3>&1 1>&2 2>&3
	)
	TERM=ansi whiptail --backtitle "Dissonant Build System $DBSVER" --title "Creating project" --infobox "Generating project, please wait..." 7 45
	sleep 1s
	touch "$HOME/dsnt-working/projects/$dprojectname.define"
	echo "# This file configures this DBS project" >> "$HOME/dsnt-working/projects/$dprojectname.define"
	echo "" >> "$HOME/dsnt-working/projects/$dprojectname.define"
	echo "PRJBUILDID=$dnewmenuout" >> "$HOME/dsnt-working/projects/$dprojectname.define"
	echo "PRJNAME=$dprojectname" >> "$HOME/dsnt-working/projects/$dprojectname.define"
	echo "PRJARCH=$dprojectarch" >> "$HOME/dsnt-working/projects/$dprojectname.define"
	echo "PRJNEWDATE=`date +%Y%m%d_%H%M%S%Z`" >> "$HOME/dsnt-working/projects/$dprojectname.define"
	pushd "$HOME/dsnt-working" > /dev/null
	mkdir "$dprojectname" > /dev/null
	popd > /dev/null
	pushd "$HOME/dsnt-working/$dprojectname" > /dev/null
	mkdir sources > /dev/null
	mkdir scripts > /dev/null
	mkdir tempchain > /dev/null
	popd > /dev/null
	TERM=ansi whiptail --backtitle "Dissonant Build System $DBSVER" --title "Success" --infobox "Project created" 7 22
	sleep 2s
	TERM=ansi whiptail --backtitle "Dissonant Build System $DBSVER" --title "Copying" --infobox "Copying files..." 7 30
	pushd "$HOME/dsnt-working/$dprojectname" > /dev/null
	cp "$HOME/dsnt-tree/$dnewmenuout/strap.sh" scripts/ > /dev/null
	popd > /dev/null
	sleep 2s
	dbsmain
}

function dconfigmenu {
	if [ ! -f "$HOME/dsnt-tree/dbs.conf" ]
	then
		TERM=ansi whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>WARNING<<" --infobox "No configuration found, creating..." 7 35
		sleep 2s
		touch "$HOME/dsnt-tree/dbs.conf"
		echo "#This is the Dissonant Build System configuration file. Most values expect a binary value, AKA" "$HOME/dsnt-tree/dbs.conf" >> "$HOME/dsnt-tree/dbs.conf"
		echo "#1 for No or False, and 0 for Yes or True." "$HOME/dsnt-tree/dbs.conf" >> "$HOME/dsnt-tree/dbs.conf"
		echo "" >> "$HOME/dsnt-tree/dbs.conf"
		echo "# By default, DBS defaults to 1 thread available." >> "$HOME/dsnt-tree/dbs.conf"
		echo "THREADS=1" >> "$HOME/dsnt-tree/dbs.conf"
		echo "LOGGING=0" >> "$HOME/dsnt-tree/dbs.conf"
	fi
	whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Current Configuration<<" --yesno "Below you will find the current configuration.\n\nIf this is satisfactory, you can select \"No\" to go back to the main menu.\nOtherwise, select \"Yes\" to edit the configuration.\n\n\n`cat $HOME/dsnt-tree/dbs.conf`" 25 80
	CHOICE=$?
	if [ $CHOICE = 1 ]
	then
		dbsmain
	fi
	whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Logging<<" --yesno "Enable logging?" 7 20
	DBSCONFIGLOGGING=$?
	DBSCONFIGTHREADS=$(whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>CPU Threads<<" --inputbox "How many CPU threads do you want the build system to utilize?\nMore threads enables faster compiling.\n\nIf your processor supports hyperthreading, you can use two threads per core. For example, if you have a dual-core CPU that supports hyperthreading, you can enable up to four threads. If you intend to use your computer while the build is running, it is recommended to only enable half of the available threads.\n\nIt is important to note that not all packages can compile with multiple threads, so setting this option does not force the use of parallel compilation.\n\nThe value of this option must be a numerical value, with a minimum of 1.\n\nTo return to the main menu, choose Cancel\n\n\n\n" 25 100 3>&1 1>&2 2>&3)
	CHOICE=$?
	if [ $CHOICE = 1 ]
	then
		dbsmain
	fi
	TERM=ansi whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Updating configuration<<" --infobox "Updating configuration, please wait..." 7 45
	rm "$HOME/dsnt-tree/dbs.conf.old" > /dev/null
	mv "$HOME/dsnt-tree/dbs.conf" "$HOME/dsnt-tree/dbs.conf.old"
	touch "$HOME/dsnt-tree/dbs.conf"
	echo "#This is the Dissonant Build System configuration file. Most values expect a binary value, AKA" "$HOME/dsnt-tree/dbs.conf" >> "$HOME/dsnt-tree/dbs.conf"
	echo "#0 for No or False, and 1 for Yes or True." "$HOME/dsnt-tree/dbs.conf" >> "$HOME/dsnt-tree/dbs.conf"
	echo "" >> "$HOME/dsnt-tree/dbs.conf"
	echo "# By default, DBS defaults to 1 thread available." >> "$HOME/dsnt-tree/dbs.conf"
	echo "THREADS=$DBSCONFIGTHREADS" >> "$HOME/dsnt-tree/dbs.conf"
	echo "LOGGING=$DBSCONFIGLOGGING" >> "$HOME/dsnt-tree/dbs.conf"
	sleep 2s
	dbsmain
	
}


function dupdatemenu {
	if [ ! -d "$HOME/dsnt-tree" ]
	then
		TERM=ansi whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>WARNING<<" --infobox "No tree directory, creating..." 7 35
		sleep 2s
		pushd $HOME > /dev/null
			mkdir dsnt-tree > /dev/null
			mkdir dsnt-tree/bin > /dev/null
			mkdir dsnt-tree/tmp > /dev/null
		popd > /dev/null
	fi
	dupdatemenuout=$(
		whiptail --notags --backtitle "Dissonant Build System $DBSVER" --title ">>Select type<<" --menu "Choose an online update type" 25 78 16 \
		"DBS" "Update DBS (this program)" \
		"Tree" "Update the build ID manifest" 3>&2 2>&1 1>&3
	)
	CHOICE=$?
	if [ $CHOICE = 1 ]
	then
		dbsmain
	fi
	case $dupdatemenuout in
		DBS)
			TERM=ansi whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Online Update<<" --infobox "Checking available versions..." 7 35
			pushd "/tmp/dbs.$$" > /dev/null
			wget http://dsntos.services/pub/dev/release-stable/dbs/current.manifest
			if [ $DBSVER = `cat current.manifest` ]
			then
				whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Online Update<<" --msgbox "DBS is up to date." 7 26
				rm current.manifest > /dev/null
				dupdatemenu
			fi
			whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Online Update<<" --yesno "There is a new version of DBS available.\n\nHit Yes to update, No to return to the update menu." 10 50
			CHOICE=$?
			if [ $CHOICE = 1 ]
			then
				rm current.manifest > /dev/null
				dbsmain
				popd
			fi
			TERM=ansi whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Fetching Update<<" --infobox "Fetching update..." 7 35
			wget http://dsntos.services/pub/dev/release-stable/dbs/`cat current.manifest`/dbs.sh > /dev/null
			if [ ! -a "$HOME/dsnt-tree/COPYING.BSD3" ]
				then
					wget --no-check-certificate https://raw.githubusercontent.com/binaryblob01/dsnt-scripts/master/COPYING.BSD3
					mv COPYING.BSD3 "$HOME/dsnt-tree/" > /dev/null
			fi
			sleep 1s
			TERM=ansi whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Installing Update<<" --infobox "Installing update..." 7 35
			sleep 1s
			rm "$HOME/dsnt-tree/bin/dbs.sh" > /dev/null
			cp dbs.sh "$HOME/dsnt-tree/bin/" > /dev/null
			chmod +x "$HOME/dsnt-tree/bin/dbs.sh" > /dev/null
			sleep 1s
			whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Installing Update<<" --msgbox "Please restart DBS." 7 35
			popd > /dev/null
			touch "$HOME/dsnt-tree/.update"
			dexit 0
			;;
		Tree)
			TERM=ansi whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Online Update<<" --infobox "Checking for available builds..." 7 35
			mkdir /tmp/dbs.$$
			pushd "/tmp/dbs.$$" > /dev/null
			wget http://dsntos.services/pub/dev/builds/current.manifest
			if [ ! -f "$HOME/dsnt-tree/current.manifest" ]
			then
				TERM=ansi whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Online Update<<" --infobox "No manifest present, getting latest..." 7 45
				mkdir "$HOME/dsnt-tree/build.manifests" > /dev/null
				mv current.manifest "$HOME/dsnt-tree/" > /dev/null
				wget http://dsntos.services/pub/dev/builds/`cat "$HOME/dsnt-tree/current.manifest"`-defines.tar.gz
				tar xvzf `cat "$HOME/dsnt-tree/current.manifest"`-defines.tar.gz
				cp -R manifests/*.define "$HOME/dsnt-tree/build.manifests/"
				rm -rv manifests > /dev/null
				rm *.tar.gz > /dev/null
				whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Online Update<<" --msgbox "Installed builds manifest..." 7 45
				dupdatemenu
			fi
			if [ `cat $HOME/dsnt-tree/current.manifest` = `cat current.manifest` ]
			then
				whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Online Update<<" --msgbox "Available builds manifest is current" 7 45
				dbsmain
			else
			TERM=ansi whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Installing update<<" --infobox "Installing new builds manifest..." 7 45
			rm "$HOME/dsnt-tree/current.manifest"
			mv current.manifest "$HOME/dsnt-tree/" > /dev/null
			wget http://dsntos.services/pub/dev/builds/`cat "$HOME/dsnt-tree/current.manifest"`-defines.tar.gz
			tar xvzf `cat "$HOME/dsnt-tree/current.manifest"`-defines.tar.gz
			rm "$HOME/dsnt-tree/builds.manifests/*.define"
			cp -R manifests/*.define "$HOME/dsnt-tree/build.manifests/"
			rm -rv manifests > /dev/null
			rm *.tar.gz > /dev/null
			whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Online Update<<" --msgbox "Available builds updated..." 7 45
			popd
			dupdatemenu
			fi
			;;
	esac
}


function dclonetreemenu {
	whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Info<<" --msgbox "This menu allows you to clone the source tree for a selected Dissonant Build ID.\n\nPlease note, to ensure that you have the latest build ID list, you will need to use the Update option from the main menu. Then you can choose to update the build ID manifest." 15 100
	if [ ! -d "$HOME/dsnt-tree" ]
	then
		TERM=ansi whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Tree not found<<" --infobox "The Dissonant tree directory was not found. Creating now..." 8 40
		pushd "$HOME" > /dev/null
		mkdir dsnt-tree > /dev/null
		popd > /dev/null
		sleep 2s
	fi
	if [ ! -d "$HOME/dsnt-tree/build.manifests" ]
	then
		whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Tree manifest not found<<" --msgbox "A tree manifest was not found. Please update or create the tree through the main menu." 8 40
		dbsmain
	fi
	pushd "$HOME/dsnt-tree/build.manifests" > /dev/null
		menubuildthree=$(
		for f in *.define; do echo "\"$f\" \"$f\"\\"; done
		)
		popd > /dev/null
	dclonetreemenuout=$(
		whiptail --notags --backtitle "Dissonant Build System $DBSVER" --title ">>Select build ID<<" --menu "Choose a build ID to clone" 25 78 16 \
		$menubuildthree 3>&2 2>&1 1>&3
	)
	CHOICE=$?
	if [ $CHOICE = 1 ]
	then
		dbsmain
	fi
	# Fix for .define appendage
	DCURRENTBUILDIDB=$(echo $dclonetreemenuout | tr -d \")
	DCURRENTBUILDID=$(echo $DCURRENTBUILDIDB | sed -r 's/(.define)+$//')
whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Build Information<<" --yesno "This screen presents information on the selected build ID.\n\nIf you wish to choose a different build, choose No.\nOtherwise, choose Yes.\n\n\n`head -5 $HOME/dsnt-tree/build.manifests/$DCURRENTBUILDID.define`" 25 100
	CHOICE=$?
	if [ $CHOICE = 1 ]
	then
		dclonetreemenu
	fi
	if [ -d "$HOME/dsnt-tree/$DCURRENTBUILDID" ]
	then
		whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>ERROR<<" --msgbox "It appears this build has already been downloaded.\n\nIf you need to download it again, you will need to manually remove the build IDs directory in the tree." 10 75
		dclonetreemenu
	fi
	
	TERM=ansi whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Fetching source tree<<" --infobox "Fetching tree in 5 seconds..." 7 45
	sleep 5s
	mkdir "$HOME/dsnt-tree/$DCURRENTBUILDID" > /dev/null
	pushd "$HOME/dsnt-tree/$DCURRENTBUILDID" > /dev/null
	# Now the actual download command
	sed -n '/SOURCE.BASE.TARBALLS.BEGIN/,/SOURCE.BASE.TARBALLS.END/p' $HOME/dsnt-tree/build.manifests/$DCURRENTBUILDID.define | sed '1d; $d' | awk '{print "http://dsntos.services/pub/src/"$0}' | wget -i -
	popd > /dev/null
	whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Complete<<" --msgbox "Tree downloaded." 8 20
	TERM=ansi whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Verifying<<" --infobox "Verifying checksums..." 7 45
	pushd "$HOME/dsnt-tree/$DCURRENTBUILDID" > /dev/null
	sed -n '/SOURCE.BASE.TARBALLS.SHA256SUMS.BEGIN/,/SOURCE.BASE.TARBALLS.SHA256SUMS.END/p' $HOME/dsnt-tree/build.manifests/$DCURRENTBUILDID.define | sed '1d; $d' | sha256sum -
	popd > /dev/null
	sleep 15s
	dclonetreemenu
}

function dbsmain {
	clear
	if [ -a "$HOME/dsnt-tree/.update" ]
	then
		whiptail --backtitle "Dissonant Build System $DBSVER" --title ">>Info<<" --msgbox " The Dissonant Build System has been updated successfully." 10 40
		rm "$HOME/dsnt-tree/.update" > /dev/null
	fi
	dbsmenuout=$(
	whiptail --notags --backtitle "Dissonant Build System $DBSVER" --title ">>Main Menu<<" --menu "Choose an action" 25 78 16 \
	"About" "About Dissonant Build System" \
	"Select" "Select current build project" \
	"New" "Start a new build project" \
	"Configure" "General options" \
	"Update" "Check for updates" \
	"Clone" "Clone a Dissonant tree" \
	"Exit" "Exit the build system" 3>&2 2>&1 1>&3
	)
	case $dbsmenuout in
		About)
			daboutmsg
			;;
		Select)
			dselectmenu
			;;
		New)
			dnewmenu
			;;
		Configure)
			dconfigmenu
			;;
		Update)
			dupdatemenu
			;;
		Clone)
			dclonetreemenu
			;;
		Exit)
			dexit 0
			;;
		*)
	esac
}



## END FUNCTIONS ##

## MODULES ##

## END MODULES ##

## MAIN ##

#~API DEFINES~#
if [ $1 = getdbsver ]
then
	echo $DBSVER
	exit 0
fi
if [ $1 = debug ]
then
	echo "Dissonant Build System version $DBSVER"
	echo ""
	echo "Entering debug mode..."
	sleep 2s
	echo "Debug mode not available on this version."
	exit 0
fi
if [ $1 = "conf.threads.avail" ]
then
	source "$HOME/dsnt-tree/dbs.conf"
	echo $THREADS
	exit 0
fi
if [ $1 = "conf.logging.enabled" ]
then
	source "$HOME/dsnt-tree/dbs.conf"
	echo $LOGGING
	exit 0
fi
#~END API DEFINES~#

dbsstart
dbsmain

## END MAIN ##