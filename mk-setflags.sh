##!/bin/bash

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

# mk-setflags prompts the user for input to generate appropriate flags needed to build.
#       a Dissonant application image.

#
#


# SET SETFLAGS_VER

setflags_ver="0.1"



## FUNCTIONS

function dsp_header {

        echo "mk-setflags v`echo $setflags_ver`"
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


echo "mk-setflags version $setflags_ver"
echo ""
echo "(C) Copyright 2018 Alec Bloss. All rights reserved."
echo "This is a Dissonant build utility."
echo ""

sleep 2s

dsp_clear

dsp_header

dbk

## We need to be sure that the temporary package chain is at least existant.
# Let's check to make sure the temporary directory exists. If it does not, ABORT and warn the user.

if [ ! -d pkgtmp ]
then
        echo "WARNING: Temporary package directory does not exist."
	dbk
        echo "ABORTING"
        dbk
        echo "Please run mk-pkgcfg to setup temporary dirchain before proceeeding."
        exit 1
fi



echo "Each Dissonant package must have a flags file."
echo "This utility will ask you questions to help"
echo "generate a sane flags file."
dbk

echo "Is this a development or non-release package? [ Y / N ]:"
read dev1

if [ $dev1 == n -o $dev1 == N ]
then
	echo "Is this a production or release package? [ Y / N ]:"
	read prodrel1
	dbk
fi

dbk
echo "Is this an Official Dissonant package? [ Y / N ]:"
read is_dsnt_pkg1
dbk

echo "Is this a deprecated package?"
echo '!!!!!!!!!!!! WARNING !!!!!!!!!!!!'
echo "Setting the deprecated flag has serious"
echo "consequences. The package management system"
echo "will ALWAYS force a warning with this flag enabled."
echo "On some systems, this flag may also be blacklisted,"
echo "meaning that it cannot be installed at all."
echo "Use with extreme care."
echo "IF YOU ARE ENTIRELY SURE that you DO want to set this"
echo "flag, answer Y here. Otherwise, answer N."
echo "Set deprecated flag? [ Y / N ]:"
read flagdeprecated1

if [ $flagdeprecated1 == y -o $flagdeprecated1 == Y ]
then
	dbk
	dbk
	echo "WARNING: DEPRECATED FLAG HAS BEEN SET."
	echo "YOU HAVE BEEN WARNED."
	dbk
	sleep 5s
fi

dsp_clear

dsp_header

dbk

echo "Does your package require the creation of symlinks"
echo "post-install? [ Y / N ]:"
read pi_symlinks1

dbk

sleep 2s

dsp_clear

dsp_header

dbk

## FUTURE VERSIONS: BE SURE TO CHECK FLAGS TO ENSURE DAIAPI IS AT
## CORRECT MINIMUM, AND PROMPT USER IF THEY WANT TO SET A HIGHER
## DAIAPI REQUIREMENT OR NOT. NOTE THAT DAIAPI SHOULD NOT BE USED
## TO PREVENT INSTALLATION ON A OLDER DISSONANT SYSTEM. THAT IS DONE
## ELSEWHERE. THIS IS JUST TO ENSURE THE PACKAGE MANAGEMENT SYSTEM
## IS CAPABLE OF DOING REQUIRED ACTIONS.

echo "Setting DAIAPI flag..."
dbk

sleep 2s

daiapiver1="01"


# Now we need to create the flags file.

dsp_clear

dsp_header

dbk

echo "Generating flags file, please wait..."
dbk

sleep 1s


cd pkgtmp/meta/data

echo "Creating blank flags file..."
dbk
sleep 1s

touch FLAGS

echo "Parsing flags, please wait..."

if [ $dev1 == y -o $dev1 == Y ]
then
	echo "01000000001D" >> FLAGS
	echo "Set development package flag."
	dbk
	sleep 1s
fi

if [ $prodrel1 == y -o $prodrel1 == Y ]
then
	echo "010000000030" >> FLAGS
	echo "Set production package flag."
	dbk
	sleep 1s
fi

if [ $flagdeprecated1 == y -o $flagdeprecated1 == Y ]
then
	echo "010000000020" >> FLAGS
	echo 'WARNING!!!!!'
	echo "Set deprecated package flag."
	dbk
	sleep 1s
fi

if [ $is_dsnt_pkg1 == y -o $is_dsnt_pkg1 == Y ]
then
	echo "010000000040" >> FLAGS
	echo "You have marked this as an Official Dissonant package."
	echo "Set Official Dissonant package flag."
	dbk
	sleep 1s
fi

dbk
sleep 1s
dbk
sleep 1s

echo "Flag file generated successfully."
dbk

exit 0
