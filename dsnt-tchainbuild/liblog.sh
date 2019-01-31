#!/bin/bash

# (C) Copyright 2018-2019 Alec Bloss. All rights reserved. 

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

# liblog provides functions to log with timestamps.

# You can use it in your BASH scripts with the source command.

## 

function aINITLOG{
	aLOGPATH=`echo $1`
	aLOGNAME=`echo $2`
	aSOFTNAME=`echo $3`
	aINITMSG=`echo $4`
	aDSNTBLDID=`echo $5`
	
	echo "$aLOGNAME" >> $aLOGPATH
	echo "-------------------" >> $aLOGPATH
	#echo "$aINITMSG" >> $aLOGPATH
	echo "============================BEGIN LOG============================" >> $aLOGPATH
	echo "`date +%Y%m%d_%H%M%S%Z` Logging enabled" >> $aLOGPATH
	
}

function aLOGMSG{
	
	aLOGMSG=`echo $1`
	
	echo "`date +%Y%m%d_%H%M%S%Z`" >> $aLOGPATH
	

}	



function aLOGCLOSE{
	echo "============================CLOSE LOG============================" >> $aLOGPATH
	echo "" >> $aLOGPATH
	echo "" >> $aLOGPATH
	
}

	
exit 0

