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



# mk-conflictslist prompts the user for input to generate conflicts lists.
#       a Dissonant application image.

#
#


# SET MKCFL_CFG_VER

mkcfl_ver="0.1"


## FUNCTIONS

function dsp_header {

        echo "mk-conflictslist v`echo $mkcfl_ver`"
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


echo "mk-conflictslist version $mkcfl_ver"
echo ""
echo "(C) Copyright 2018 Alec Bloss. All rights reserved."
echo "This is a Dissonant build utility."
echo ""

sleep 2s

dsp_clear

dsp_header

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


dbk

echo "Dissonant packages need a conflicts list."
echo "This is a requirement even if there are no"
echo "conflicts."

dbk
echo "All Dissonant packages must have at least one conflict."
echo "This would be \"ghostlinux\"."
echo "It will be added automatically."
dbk
echo "On the next screen you will be provided with an editor"
echo "to edit the conflicts list. List one package name"
echo "per line. DO NOT include any version information."
echo "\"ghostlinux\" will be automatically included, so don\'t"
echo "include that."
dbk
echo "Press any key to continue, or CTRL+C to abort."
read

dsp_clear
dsp_header

cd pkgtmp/meta/conflicts

pwd #For debugging purposes only


dbk
echo "Please enter the package names of each conflict, without"
echo "any versions, one per line. When finished, please press"
echo "CTRL+D. To abort, press CTRL+C"
dbk

echo "---------------------- conflictslist editor -----------------------------"
echo "CTRL+D to save and continue, CTRL+C to abort and exit"
echo "========================================================================="

cat > master.dep

echo "------------------------ end conflictslist ------------------------------"
echo "========================================================================="

echo "ghostlinux" >> master.cfl

cd ../../..

exit 0
