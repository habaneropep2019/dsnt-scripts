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


# This script fetches the latest tree used to build Dissonant.
# It will create a directory called 'dsnt-tree' in your home directory (if it doesn't exist)
# Inside of that tree it creates subdirectories that are specific to builds
# of Dissonant, that way different trees are kept clean and you can easily switch.


# SET FETCHTREE_CFG_RELEASE

fetchtree_release="1"

# SET DISSONANT BUILD NUMBER

dsnt_build_ID="1"

# SET TOTAL NUMBER OF TARBALLS TO GRAB

tarball_count=""

# SET DISSONANT SERVICES URL

DSRCURL="http://dsntos.services/pub/src/"

DIR_WHEN_STARTED=`pwd`

## FUNCTIONS

function dsp_header {

        echo "Dissonant fetchtree `echo $fetchtree_release`"
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


echo "fetchtree release $fetchtree_release"
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

echo "Checking for tree directory..."

cd $HOME

if [ -d "dsnt-tree" ]
	then
		echo "... OK"
	else
		echo "Dissonant tree not found, creating tree directory"
		mkdir -v dsnt-tree
		echo "Dissonant tree created"
fi
	
sleep 1s

dbk

cd dsnt-tree

if [ -d "$dsnt_build_ID" ]
	then
		echo "Dissonant build tree for build $dsnt_build_ID"
		echo "already exists. Aborting."
		echo " If you wish to re-create this tree, please rename or"
		echo "delete this build."
		exit 1
	else
		echo "Build directory does not exist."
		mkdir -v $dsnt_build_ID
		echo "Build directory created succesfully."
fi
	
sleep 2s

dsp_clear

dsp_header

cd $dsnt_build_ID

echo "Preparing to download tarballs, please wait..."
dbk

sleep 1s

echo "The screen may scroll as packages are downloaded."
echo "Downloading tarballs in 3 seconds..."

sleep 3s

wget `echo $DSRCURL`/acl-2.2.53.tar.gz
wget `echo $DSRCURL`/attr-2.4.48.tar.gz
wget `echo $DSRCURL`/autoconf-2.69.tar.xz
wget `echo $DSRCURL`/automake-1.16.1.tar.xz
wget `echo $DSRCURL`/bash-4.4.18.tar.gz
wget `echo $DSRCURL`/bc-1.07.1.tar.gz
wget `echo $DSRCURL`/binutils-2.31.1.tar.xz
wget `echo $DSRCURL`/bison-3.0.5.tar.xz
wget `echo $DSRCURL`/bzip2-1.0.6.tar.gz
wget `echo $DSRCURL`/check-0.12.0.tar.gz
wget `echo $DSRCURL`/coreutils-8.30.tar.xz
wget `echo $DSRCURL`/dejagnu-1.6.1.tar.gz
wget `echo $DSRCURL`/diffutils-3.6.tar.xz
wget `echo $DSRCURL`/eudev-3.2.5.tar.gz
wget `echo $DSRCURL`/e2fsprogs-1.44.3.tar.gz
wget `echo $DSRCURL`/elfutils-0.173.tar.bz2
wget `echo $DSRCURL`/expat-2.2.6.tar.bz2
wget `echo $DSRCURL`/expect5.45.4.tar.gz
wget `echo $DSRCURL`/file-5.34.tar.gz
wget `echo $DSRCURL`/findutils/findutils-4.6.0.tar.gz
wget `echo $DSRCURL`/flex-2.6.4.tar.gz
wget `echo $DSRCURL`/gawk-4.2.1.tar.xz
wget `echo $DSRCURL`/gcc-8.2.0.tar.xz
wget `echo $DSRCURL`/gdbm-1.17.tar.gz
wget `echo $DSRCURL`/gettext-0.19.8.1.tar.xz
wget `echo $DSRCURL`/glibc-2.28.tar.xz
wget `echo $DSRCURL`/gmp-6.1.2.tar.xz
wget `echo $DSRCURL`/gperf-3.1.tar.gz
wget `echo $DSRCURL`/grep-3.1.tar.xz
wget `echo $DSRCURL`/groff-1.22.3.tar.gz
wget `echo $DSRCURL`/grub-2.02.tar.xz
wget `echo $DSRCURL`/gzip-1.9.tar.xz
wget `echo $DSRCURL`/iana-etc-2.30.tar.bz2
wget `echo $DSRCURL`/intltool-0.51.0.tar.gz
wget `echo $DSRCURL`/iproute2-4.18.0.tar.xz
wget `echo $DSRCURL`/kbd-2.0.4.tar.xz
wget `echo $DSRCURL`/kmod-25.tar.xz
wget `echo $DSRCURL`/less-530.tar.gz
wget `echo $DSRCURL`/libcap-2.25.tar.xz
wget `echo $DSRCURL`/libffi-3.2.1.tar.gz
wget `echo $DSRCURL`/libpipeline-1.5.0.tar.gz
wget `echo $DSRCURL`/libtool-2.4.6.tar.xz
wget `echo $DSRCURL`/linux-4.18.5.tar.xz
wget `echo $DSRCURL`/m4-1.4.18.tar.xz
wget `echo $DSRCURL`/make-4.2.1.tar.bz2
wget `echo $DSRCURL`/man-db-2.8.4.tar.xz
wget `echo $DSRCURL`/man-pages-4.16.tar.xz
wget `echo $DSRCURL`/meson-0.47.1.tar.gz
wget `echo $DSRCURL`/mpc-1.1.0.tar.gz
wget `echo $DSRCURL`/mpfr-4.0.1.tar.xz
wget `echo $DSRCURL`/ninja-1.8.2.tar.gz
wget `echo $DSRCURL`/ncurses-6.1.tar.gz
wget `echo $DSRCURL`/openssl-1.1.0i.tar.gz
wget `echo $DSRCURL`/patch-2.7.6.tar.xz
wget `echo $DSRCURL`/perl-5.28.0.tar.xz
wget `echo $DSRCURL`/pkg-config-0.29.2.tar.gz
wget `echo $DSRCURL`/procps-ng-3.3.15.tar.xz
wget `echo $DSRCURL`/psmisc-23.1.tar.xz
wget `echo $DSRCURL`/Python-3.7.0.tar.xz
wget `echo $DSRCURL`/python-3.7.0-docs-html.tar.bz2
wget `echo $DSRCURL`/readline-7.0.tar.gz
wget `echo $DSRCURL`/sed-4.5.tar.xz
wget `echo $DSRCURL`/shadow-4.6.tar.xz
wget `echo $DSRCURL`/sysklogd-1.5.1.tar.gz
# wget `echo $DSRCURL`/sysvinit-2.90.tar.xz
wget `echo $DSRCURL`/tar-1.30.tar.xz
wget `echo $DSRCURL`/tcl8.6.8-src.tar.gz
wget `echo $DSRCURL`/texinfo-6.5.tar.xz
wget `echo $DSRCURL`/tzdata2018e.tar.gz
wget `echo $DSRCURL`/util-linux-2.32.1.tar.xz
wget `echo $DSRCURL`/vim-8.1.tar.bz2
wget `echo $DSRCURL`/XML-Parser-2.44.tar.gz
wget `echo $DSRCURL`/xz-5.2.4.tar.xz
wget `echo $DSRCURL`/zlib-1.2.11.tar.xz

# Now we need to verify the files and let the user know what the outcome is.

sleep 3s

dsp_clear

dsp_header

echo "Now we need to verify the integrity of the downloaded files."
echo "This may take a while. Please note that the screen will scroll."

dbk

sleep 1s

echo "Creating md5sums list, please wait..."

cat > md5sums <<'_EOF'
007aabf1dbb550bcddde52a244cd1070  acl-2.2.53.tar.gz
bc1e5cb5c96d99b24886f1f527d3bb3d  attr-2.4.48.tar.gz
50f97f4159805e374639a73e2636f22e  autoconf-2.69.tar.xz
53f38e7591fa57c3d2cee682be668e5b  automake-1.16.1.tar.xz
518e2c187cc11a17040f0915dddce54e  bash-4.4.18.tar.gz
cda93857418655ea43590736fc3ca9fc  bc-1.07.1.tar.gz
5b7c9d4ce96f507d95c1b9a255e52418  binutils-2.31.1.tar.xz
3e54f20988ecd1b62044e25481e5f06b  bison-3.0.5.tar.xz
00b516f4704d4a7cb50a1d97e6e8e15b  bzip2-1.0.6.tar.gz
31b17c6075820a434119592941186f70  check-0.12.0.tar.gz
ab06d68949758971fe744db66b572816  coreutils-8.30.tar.xz
2ac8405a4c7ca8611d004fe852966c6f  dejagnu-1.6.1.tar.gz
07cf286672ced26fba54cd0313bdc071  diffutils-3.6.tar.xz
6ca08c0e14380f87df8e8aceac123671  eudev-3.2.5.tar.gz
6bd765f3cf8f15740cdf81e71e88f2a4  e2fsprogs-1.44.3.tar.gz
35decb1ebfb90d565e4c411bee4185cc  elfutils-0.173.tar.bz2
ca047ae951b40020ac831c28859161b2  expat-2.2.6.tar.bz2
00fce8de158422f5ccd2666512329bd2  expect5.45.4.tar.gz
44b0b6983462b18f96403d4d3ad80254  file-5.34.tar.gz
9936aa8009438ce185bea2694a997fc1  findutils-4.6.0.tar.gz
2882e3179748cc9f9c23ec593d6adc8d  flex-2.6.4.tar.gz
95cf553f50ec9f386b5dfcd67f30180a  gawk-4.2.1.tar.xz
4ab282f414676496483b3e1793d07862  gcc-8.2.0.tar.xz
f20ce117abc6f302ecf62c34d41c1ecf  gdbm-1.17.tar.gz
df3f5690eaa30fd228537b00cb7b7590  gettext-0.19.8.1.tar.xz
c81d2388896379997bc359d4f2084239  glibc-2.28.tar.xz
f58fa8001d60c4c77595fbbb62b63c1d  gmp-6.1.2.tar.xz
9e251c0a618ad0824b51117d5d9db87e  gperf-3.1.tar.gz
feca7b3e7c7f4aab2b42ecbfc513b070  grep-3.1.tar.xz
cc825fa64bc7306a885f2fb2268d3ec5  groff-1.22.3.tar.gz
8a4a2a95aac551fb0fba860ceabfa1d3  grub-2.02.tar.xz
9492c6ccb2239ff679a5475a7bb543ed  gzip-1.9.tar.xz
3ba3afb1d1b261383d247f46cb135ee8  iana-etc-2.30.tar.bz2
87fef1fa3f603aef11c41dcc097af75e  inetutils-1.9.4.tar.xz
12e517cac2b57a0121cda351570f1e63  intltool-0.51.0.tar.gz
8b8680e91390c57cab788fbf8e929479  iproute2-4.18.0.tar.xz
c1635a5a83b63aca7f97a3eab39ebaa6  kbd-2.0.4.tar.xz
34f325cab568f842fdde4f8b2182f220  kmod-25.tar.xz
6a39bccf420c946b0fd7ffc64961315b  less-530.tar.gz
6666b839e5d46c2ad33fc8aa2ceb5f77  libcap-2.25.tar.xz
83b89587607e3eb65c70d361f13bab43  libffi-3.2.1.tar.gz
b7437a5020190cfa84f09c412db38902  libpipeline-1.5.0.tar.gz
1bfb9b923f2c1339b4d2ce1807064aa5  libtool-2.4.6.tar.xz
22851fe6c82db6673a844bbb7c62df67  linux-4.18.5.tar.xz
730bb15d96fffe47e148d1e09235af82  m4-1.4.18.tar.xz
15b012617e7c44c0ed482721629577ac  make-4.2.1.tar.bz2
ab41db551f500e4a595b11203b86c67a  man-db-2.8.4.tar.xz
ad9f1ff81276fe8d90d077484d6d4b5e  man-pages-4.16.tar.xz
5ed95fd4e9c7634f7cf3482d352804e7  meson-0.47.1.tar.gz
4125404e41e482ec68282a2e687f6c73  mpc-1.1.0.tar.gz
b8dd19bd9bb1ec8831a6a582a7308073  mpfr-4.0.1.tar.xz
5fdb04461cc7f5d02536b3bfc0300166  ninja-1.8.2.tar.gz
98c889aaf8d23910d2b92d65be2e737a  ncurses-6.1.tar.gz
9495126aafd2659d357ea66a969c3fe1  openssl-1.1.0i.tar.gz
78ad9937e4caadcba1526ef1853730d5  patch-2.7.6.tar.xz
f3245183c0a08f65e94a3333995af08e  perl-5.28.0.tar.xz
f6e931e319531b736fadc017f470e68a  pkg-config-0.29.2.tar.gz
2b0717a7cb474b3d6dfdeedfbad2eccc  procps-ng-3.3.15.tar.xz
bbba1f701c02fb50d59540d1ff90d8d1  psmisc-23.1.tar.xz
eb8c2a6b1447d50813c02714af4681f3  Python-3.7.0.tar.xz
c4637cf2a9a6ebb8c5e9dc8ff13fb4cb  python-3.7.0-docs-html.tar.bz2
205b03a87fc83dab653b628c59b9fc91  readline-7.0.tar.gz
ade8f8c2c548bf41f74db2dcfc37e4e3  sed-4.5.tar.xz
b491fecbf1232632c32ff8f1437fd60e  shadow-4.6.tar.xz
c70599ab0d037fde724f7210c2c8d7f8  sysklogd-1.5.1.tar.gz
2d01c6cd1387be98f57a0ec4e6e35826  tar-1.30.tar.xz
81656d3367af032e0ae6157eff134f89  tcl8.6.8-src.tar.gz
3715197e62e0e07f85860b3d7aab55ed  texinfo-6.5.tar.xz
97d654f4d7253173b3eeb76a836dd65e  tzdata2018e.tar.gz
9e5b1b8c1dc99455bdb6b462cf9436d9  util-linux-2.32.1.tar.xz
1739a1df312305155285f0cfa6118294  vim-8.1.tar.bz2
af4813fe3952362451201ced6fbce379  XML-Parser-2.44.tar.gz
003e4d0b1b1899fc6e3000b24feddf7c  xz-5.2.4.tar.xz
85adef240c5f370b308da8c938951a68  zlib-1.2.11.tar.xz
_EOF


sleep 1s

dbk

echo "Verifying checksums, please wait..."

md5sum -c md5sums &> LOG.log

sleep 2s

dbk

echo "The checksum verification has been run."
echo "IMPORTANT"
echo "============"
echo "You must check the file $HOME/dsnt-tree/$dsnt_build_ID/LOG.log"
echo "and verify that all files have an OK. If a file failed,"
echo "you MUST re-download the tree."
echo "Alternatively, you can use wget to re-download an individual package:"
dbk
echo "cd $HOME/dsnt-tree/$dsnt_build_ID/"
echo "wget $DSRCURL<file name>"
dbk
dbk
echo "Have fun..."

exit 0


