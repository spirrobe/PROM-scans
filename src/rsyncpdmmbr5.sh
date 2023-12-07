#!/bin/bash
localdir=/data/userdata/spirig/prom
device="mbr5"
remotedir=/data
bwlimit=5000

SYNCFILE=~/.rsyncpdmmbr5
scantypes=('rhi' 'zen' 'ppibb' 'ppi')

dryrun=""
#dryrun="-n"

if [[ -f "$SYNCFILE" && $(find "$SYNCFILE" -mmin +1500 -print) ]]; then

  echo "File $SYNCFILE exists and is older than 1500 minutes"
  rm -v $SYNCFILE

fi

if [ ! -f "$SYNCFILE" ]; then

  touch $SYNCFILE
  for scantype in ${scantypes[@]}; do
    echo $scantype
    echo "rsync -avP $dryrun --bwlimit=$bwlimit $device:$remotedir/*$scantype.pd[s,m] $localdir/pdm/$scantype/;"
    rsync -avP $dryrun --bwlimit=$bwlimit $device:$remotedir/*$scantype.pd[s,m] $localdir/pdm/$scantype/;
  done;
  rm $SYNCFILE
else

 echo "Not syncing to cloudy because sync is already ongoing!"

fi

