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



# mk-pkgcfg prompts the user for input to generate configuration files needed to build.
# 	a Dissonant application image.

#
#


# SET PKG_CFG_VER

pkgcfg_ver="0.1"

# SET DSNT_BUILD_VER

dsnt_build="09012018"


## FUNCTIONS

function dsp_header {

	echo "mk-pkgcfg v`echo $pkgcfg_ver`"
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


echo "mk-pkgcfg version $pkgcfg_ver"
echo ""
echo "(C) Copyright 2018 Alec Bloss. All rights reserved."
echo "This is a Dissonant build utility."
echo ""

sleep 2s

dsp_clear

dsp_header

echo "We need to create configuration files before you can generate"
echo "an application image."
dbk

# Let's check to make sure the temporary directory does not exist. If it does, ABORT and warn the user.

if [ -d pkgtmp ]
then
	echo "Temporary package directory already exists."
	echo "ABORTING"
	echo ""
	echo "Please remove temporary directory before proceeeding."
	exit 1
fi

echo "Temporary directory does not exist, creating..."

dbk

mkdir -v pkgtmp



# Now let's prompt the user for metadata information that we need

dbk
dbk

echo "We need a package name. This is the short version used"
echo "in the filename and other places."
dbk
echo "Package name [ENTER]:"
read pkgn1


dbk
echo "We need to know the package version. This is not"
echo "the same as the actual program version."
echo "It should not include any revisions, and should"
echo "only contain numbers and periods."
dbk
echo "See the documentation for more information."
dbk
echo "Package version [ENTER]:"
read pkgv1

dsp_clear
dsp_header

dbk
echo "Now we need the package revision or any strings"
echo "to append to the base version entered previously."
echo "Note that this is optional. Leave blank to ignore."
dbk
echo "Package version appendix [ENTER]:"
read pkgax1

dbk
echo "You must specify an architecture for your package."
echo "Here is a list of architectures. First listed is the"
echo "abbreviation, followed by a description."
dbk
echo "x86 - All 32-bit Intel-based 80386 and up processors"
echo "486 - All 32-bit Intel-based 80486 and up processors"
echo "686 - All 32-bit Intel-based 80686 and up processors"
echo "x64 - All 64-bit AMD compatible processors"
echo "doc - Architecure independent documentation-only files"
echo "noarch - Architecture independent"
echo "src - Source code only"
echo "arm - All 32-bit ARM-compatible processors"
echo "arm64 - All 64-bit ARM-compatible processors"
echo "sparc - All 32-bit SPARC-compatible processors"
echo "sparc64 - All 64-bit SPARC-compatible processors"
echo "ppc - All PowerPC compatible processors"
dbk
echo "Package architecture [ENTER]:"
read pkgarch1

dsp_clear
dsp_header

dbk
echo "Creating temporary directory structure in"
echo "working directory, please wait..."

cd pkgtmp

dbk

sleep 2s

mkdir -v meta
mkdir -v meta/deps
mkdir -v meta/data
mkdir -v meta/conflicts
mkdir -v meta/provides
mkdir -v meta/lists
mkdir -v meta/files
mkdir -v tmp

sleep 2s

dsp_clear
dsp_header

dbk
echo "Generating specs files, please wait..."
dbk

cd meta
cd data

pwd #Only here for debugging purposes

touch pkgname
touch basever
touch verappend
touch arch
touch dsnt_build

echo $pkgn1 >> pkgname
echo $pkgv1 >> basever
echo $pkgax1 >> verappend
echo $pkgarch1 >> arch
echo $dsnt_build >> dsnt_build
dbk

sleep 1s

echo "Basic spec files generated."

dbk
echo "You can now use mk-deplist and mk-conflictslist"
echo "to generate dependencies and conflicts."
dbk
echo "Happy noisemaking!"

cd ../../..

exit 0

