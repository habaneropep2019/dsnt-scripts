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



# mk-iflist creates lists of files installed by a source tarball's 'make install', or equivalent.
# It creates three separate lists - directories, files, and symlinks.

# This script currently creates oversized lists - AKA it does not compare against
#	a baseline file to remove all existing files. This will have to be added
# 	at a later date. So in other words it just saves a bunch of repetetive
# 	work.

# You need to pass some basic options to mk-iflist for it to work. At this time it requires
#	you to pass three options, the baseline name, your package name, and the mounted directory.
#
#				root@ghostlinux# ./mk-iflist.sh dsnt-base dissonant
#
# The above command will output three files in the current directory:
#	- dissonant.dls
#	- dissonant.fls
#	- dissonant.lls
# 

# SET IFLIST_VER

iflist_ver="0.1.3"

# First let's pull our command line arguments into their own variables

echo ""

echo "mk-iflist version `echo $iflist_ver`"
sleep 1s

echo ""
echo "Initializing, please wait..."


baseline=`echo $1`
pkgname=`echo $2`
#path-strip=`echo $3`

sleep 2s


# Search for all directories on system

echo "Searching for directories..."

find -P / -type d >> `echo $pkgname`.tdls

# Search for all files on system

echo "Searching for files..."

find -P / -type f >> `echo $pkgname`.tfls

# Search for all symlinks on system

echo "Searching for symlinks..."

find / -type l >> `echo $pkgname`.tlls


# Strip mount path from t-files

# echo "Stripping mount paths, please wait..."

# cat `echo $pkgname`.tdls | sed 's:^`echo $path-strip`::' >> `echo $pkgname`.ttdls

# cat `echo $pkgname`.tfls | sed 's:^`echo $path-strip`::' >> `echo $pkgname`.ttfls

# cat `echo $pkgname`.tlls | sed 's:^`echo $path-strip`::' >> `echo $pkgname`.ttlls

sleep 1s

echo ""
# echo "Mount paths stripped"

echo "Path stripping disabled, skipping."

sleep 1s

echo ""

# Remove dsnt-scripts, temporary toolchains, and sourcechain

echo "Removing temporary toolchain, dsnt-scripts, and sourcechain references..."

sed -i '/^\/tools/d' `echo $pkgname`.tdls

sed -i '/^\/dsnt-scripts/d' `echo $pkgname`.tdls

sed -i '/^\/sources/d' `echo $pkgname`.tdls


sed -i '/^\/tools/d' `echo $pkgname`.tfls

sed -i '/^\/dsnt-scripts/d' `echo $pkgname`.tfls

sed -i '/^\/sources/d' `echo $pkgname`.tfls


sed -i '/^\/tools/d' `echo $pkgname`.tlls

sed -i '/^\/dsnt-scripts/d' `echo $pkgname`.tlls

sed -i '/^\/sources/d' `echo $pkgname`.tlls


# Removing proc, tmp, and sys references

echo ""

echo "Removing /proc, /tmp, and /sys references..."

sed -i '/^\/proc/d' `echo $pkgname`.tdls

sed -i '/^\/tmp/d' `echo $pkgname`.tdls

sed -i '/^\/sys/d' `echo $pkgname`.tdls


sed -i '/^\/proc/d' `echo $pkgname`.tfls

sed -i '/^\/tmp/d' `echo $pkgname`.tfls

sed -i '/^\/sys/d' `echo $pkgname`.tfls


sed -i '/^\/proc/d' `echo $pkgname`.tlls

sed -i '/^\/tmp/d' `echo $pkgname`.tlls

sed -i '/^\/sys/d' `echo $pkgname`.tlls


# Remove dev, run, and lost+found

echo ""

echo "Removing /dev, /run, and /lost+found references..."

sed -i '/^\/dev/d' `echo $pkgname`.tdls

sed -i '/^\/run/d' `echo $pkgname`.tdls

sed -i '/^\/lost+found/d' `echo $pkgname`.tdls


sed -i '/^\/dev/d' `echo $pkgname`.tfls

sed -i '/^\/run/d' `echo $pkgname`.tfls

sed -i '/^\/lost+found/d' `echo $pkgname`.tfls


sed -i '/^\/dev/d' `echo $pkgname`.tlls

sed -i '/^\/run/d' `echo $pkgname`.tlls

sed -i '/^\/lost+found/d' `echo $pkgname`.tlls


# Remove the single reference to the lone root, "/", and just that

echo ""

echo "Removing singular reference to / ..."

sed -i -e '/^\/$/d' `echo $pkgname`.tdls

sed -i -e '/^\/$/d' `echo $pkgname`.tfls

sed -i -e '/^\/$/d' `echo $pkgname`.tlls


# Some cleanup

mv `echo $pkgname`.tdls `echo $pkgname`.ttdls
mv `echo $pkgname`.tfls `echo $pkgname`.ttfls
mv `echo $pkgname`.tlls `echo $pkgname`.ttlls


echo ""

sleep 1s

echo ""

# Parse files

echo "Parsing files against baseline..."

grep -vf `echo $baseline`.dls `echo $pkgname`.ttdls >> `echo $pkgname`.dls

grep -vf `echo $baseline`.fls `echo $pkgname`.ttfls >> `echo $pkgname`.fls

grep -vf `echo $baseline`.lls `echo $pkgname`.ttlls >> `echo $pkgname`.lls

echo "Parsing complete."

sleep 1s

echo "All files have been successfully generated. Please note that link files are not stripped or parsed."

echo "Cleaning up"

# rm -rv `echo $pkgname`.tdls >> /dev/null
# rm -rv `echo $pkgname`.tfls >> /dev/null
# rm -rv `echo $pkgname`.tlls >> /dev/null
rm -rv `echo $pkgname`.ttdls >> /dev/null
rm -rv `echo $pkgname`.ttfls >> /dev/null
rm -rv `echo $pkgname`.ttlls >> /dev/null

echo ""

cp -v `echo $pkgname`.dls lists/
cp -v `echo $pkgname`.fls lists/
cp -v `echo $pkgname`.lls lists/

echo ""

echo "All done."

echo "You can find your list files for $pkgname in the lists directory"
echo "which should be in your current working directory."
echo ""

exit 0
