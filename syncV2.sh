#!/bin/bash
#logging
LOGFILE="log.log"
exec 3>&1 1>"$LOGFILE" 2>&1
trap "echo 'ERROR: An error occurred during execution, check log $LOGFILE for details.' >&3" ERR
trap '{ set +x; } 2>/dev/null; echo -n "[$(date -Is)]  "; set -x' DEBUG

#variables, passed-in first
MEDIA_TYPE=$1
SUBJECT="${2//:}"
#IDs unused for now--maybe to validate later
TMDB_ID=$3
TVDB_ID=$4
ISSUE="$5"

#match folder paths to media title
path="$(find /mnt/data/media/ /mnt/data/media-kids/ -mindepth 1 -maxdepth 2 -type d | grep "$SUBJECT")"
trim_path="$(find /mnt/data/media/ /mnt/data/media-kids/ -mindepth 1 -maxdepth 2 -type d | grep "$SUBJECT" | cut -d'/' -f6-)"

#debug print
echo "$SUBJECT"
echo "$path"

#test to only grab issues from jellyseerr if specific test is passed in--or else EVERY issue will trigger!
if grep -q "unava" <<< " $5"; then
echo "It matches unavailable"

case $1 in
#check media_type, debug messages ahead
  movie)
    echo "yo movie is at $path, moving to /mnt/data/sync/movies/$trim_path"
    cp -alv "$path" "/mnt/data/sync/movies/$trim_path"
    ;;
  tv)
    echo "yo show is at $path, moving to /mnt/data/sync/shows/$trim_path"
    cp -alv "$path" "/mnt/data/sync/shows/$trim_path"
    ;;
esac
fi
