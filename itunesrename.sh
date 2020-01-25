#!/bin/bash

# Author: mhamilton
# Modified from: jderefinko
# https://stackoverflow.com/questions/17882418/batch-to-rename-files-with-metadata-name

ITUNESFOLDER='/Users/admin/Music/music_backup'
DESTINATION='/Users/admin/temp/music'

for i in `find $ITUNESFOLDER`;
do
   ARTIST=`mdls $i | grep Author -A 1 | tr '\r\n' ' ' | tr -s [:space:] | cut -d '(' -f 2 | xargs`; # This gets you the Artist
   ALBUM=`mdls $i | grep Album | tr '\r\n' ' ' | tr -s [:space:] | cut -d '=' -f 2 | xargs`; # This gets you the Album title
   TRACK_NUM=`mdls $i | grep TrackNumber | tr '\r\n' ' ' | tr -s [:space:] | cut -d '=' -f 2 | xargs`; # This gets the track ID/position, like "2/13"
   TR_TITLE=`mdls $i | grep Title | tr '\r\n' ' ' | tr -s [:space:] | cut -d '=' -f 2 | xargs`; # Track title
   FILETYPE=`echo $i | cut -d . -f 2`;
   mkdir -p "$DESTINATION/$ARTIST/$ALBUM/";
   cp "$i" "$DESTINATION/$ARTIST/$ALBUM/$TRACK_NUM.$ARTIST.$ALBUM.$TR_TITLE.$FILETYPE";
done;
