#!/bin/bash
#logging
LOGFILE="log.log"
exec 3>&1 1>"$LOGFILE" 2>&1
trap "echo 'ERROR: An error occurred during execution, check log $LOGFILE for details.' >&3" ERR
trap '{ set +x; } 2>/dev/null; echo -n "[$(date -Is)]  "; set -x' DEBUG

#source for sensitive variables
source /home/slept/scripts/webhooks/scrts.conf

#variables, passed-in first
mediaType=$1
title="${2//:}"
issueID=$3
issueMsg="$4"
#unused for now
#TMDB_ID=$5
#TVDB_ID=$6

#URLs
commentURL="${baseURL}/issue/${issueID}/comment"
statusURL="${baseURL}/issue/${issueID}/resolved"

#logic to fix path issues
find_path()
{
 [ -z "$path" ] && title="${title//&/and}" && path="$(find /mnt/data/media/ /mnt/data/media-kids/ -mindepth 1 -maxdepth 2 -type d | grep "$title")"
}

#match folder paths to media title
path="$(find /mnt/data/media/ /mnt/data/media-kids/ -mindepth 1 -maxdepth 2 -type d | grep "$title")"
find_path
trimPath="$(find /mnt/data/media/ /mnt/data/media-kids/ -mindepth 1 -maxdepth 2 -type d | grep "$title" | cut -d'/' -f6-)"


##function to generate issue comment data
generate_post_data()
{
	cat <<EOF
{
    "message": "Items queued for transfer, closing issue. Upload speed is very slow, it may take quite some time for Series to transfer!"
}
EOF
}

#function to comment/close issue via api
comment_and_close()
{
	curl -X POST -L "${commentURL}" \
		-H 'Content-Type: application/json' \
		-H "X-Api-Key: ${apiKey}" \
		--data "$(generate_post_data)" &&
	curl -X POST -L "${statusURL}" \
		-H 'Content-Type: application/json' \
		-H "X-Api-Key: ${apiKey}"
}

#debug print
echo "Media: $mediaType"
echo "Title: $title"
echo "Current path is $path"
echo "Issue ID is $issueID"
echo "Issue Message sent: '$issueMsg'"

#test to only grab issues from jellyseerr if specific test is passed in--or else EVERY issue will trigger!
if grep -q -i "unava" <<< "$issueMsg"; then
echo "It matches test: 'unavailable'"

case $mediaType in
#check media_type, debug messages ahead
  movie)
#    echo "yo movie is at $path, moving to /mnt/data/sync/movies/$trimPath" &&
    cp -Rlv "$path" "/mnt/data/sync/movies/$trimPath" &&	
    comment_and_close
    ;;
  tv)
#    echo "yo show is at $path, moving to /mnt/data/sync/shows/$trimPath" &&
    cp -Rlv "$path" "/mnt/data/sync/shows/$trimPath" &&
	comment_and_close
    ;;
esac
fi
