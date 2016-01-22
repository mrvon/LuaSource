#!/bin/bash

#--------------------------------------------------------------------------
#config

version_num='1.0'
version_text='return 0.9'

#--------------------------------------------------------------------------
#Warning, export file exclude modification by version($revision_from)

revision_from='16932'
revision_to='16942'
repository='http://192.168.1.200:81/svn/prj_x/myGame-debug'
target_directory='./'

version_filename='updateVersion.lua'

zip_pack_filename=$version_num'.zip'
zip_compress_level='9'

#--------------------------------------------------------------------------

target_temp_directory=$target_directory$version_num'/'
./svn_export.sh $revision_from $revision_to $repository $target_temp_directory
echo $version_text > $target_temp_directory$version_filename
cd $target_temp_directory && zip '-'$zip_compress_level '-r' '-T' '../'$zip_pack_filename *
cd .. && rm -rf $target_temp_directory

#--------------------------------------------------------------------------
