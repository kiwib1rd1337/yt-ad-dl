#!/bin/bash
DL_ADS()
{
 # Quiet flags. Comment these out when debugging...
 YTDLP_FLAG="-q"
 CURL_FLAG="-s"

MAX_COUNT=10

count=1

 #
 # Parse URL to get video ID
 # Useful for alternative YT frontends with compatible URLs
 # e.g. Piped, Invidious
 VID="$1";
 RAWVID=$(echo $VID | awk -F'=' '{print $2}');
 CACHE_FILE=/tmp/yt-ad-dl-cache-"$USER"-"$RAWVID"

AD_DETECT_FILE=/dev/shm/yt-ad-dl-detect-"$USER"-"$RAWVID"
while [ $count -le $MAX_COUNT ]
do
 echo "Attempt $count of $MAX_COUNT..."
 ad_detected=0
 #
 #
 # Fetch the video page
 #
 # if cookies are wanted, we add  -b cookiefile -c cookiefile
 curl $CURL_FLAG "https://www.youtube.com/watch?v=$RAWVID&spf=prefetch" > $CACHE_FILE

 #
 # Fetch metadata of video.
 # Also record a handy little timestamp.
 #
 TIMESTAMP=$(date)
 VIDURL="https://www.youtube.com/watch?v=$RAWVID"
 VIDTITLE=$(cat $CACHE_FILE | grep -o -P '(?<=<meta name="title" content=")[^\"]*(?=">)')
 VIDUPLOADER=$(cat $CACHE_FILE | grep -o -P '(?<=<link itemprop="name" content=")[^\"]*(?=">)')
 VIDINFO=$(echo "TIMESTAMP:\"$TIMESTAMP\", VID-UPLOADER:\""$VIDUPLOADER"\", VID-URL:\""$VIDURL"\", VID-TITLE:\""$VIDTITLE"\"")

 #
 # Parse YT-hosted preroll ads and download them (if any)
 # These ads are hosted as youtube videos, often unlisted ones.
 # We get the video IDs of these ads, and fetch then using yt-dlp
 # Maximum quality is formt 18 (360p) by default.
 #

 # - Old Method
 #cat $CACHE_FILE | grep -oP '\"externalVideoId\":.*adLayoutLoggingData.*\"' |\
 #grep -oP '\"externalVideoId\":\"[a-zA-Z0-9_-]*\"' |\
 #grep -oP '\"externalVideoId\":\"[a-zA-Z0-9_-]*\"' |\
 #grep -oP '[a-zA-Z0-9_-]*' | grep -v 'externalVideoId' |\
 #while read line; do

 # new method
 cat $CACHE_FILE |\
 grep -Po '(?=var ytInitialPlayerResponse = ).*(?=<\/script>)' |\
 sed 's/var ytInitialPlayerResponse =//g' | jq | grep .externalVideoId | \
 grep -oP '[a-zA-Z0-9_-]*' | grep -v 'externalVideoId' |\
 while read line; do
   ADURL="https://www.youtube.com/watch?v=$line"
   #
   # fetch ad metadata (title/uploader)
   AD_CACHE_FILE=/tmp/yt-ad-dl-adcache-"$USER"-yt-"$line"
   curl -b cookiefile -c cookiefile $CURL_FLAG "$ADURL&spf=prefetch" > $AD_CACHE_FILE
   ADTITLE=$(cat $AD_CACHE_FILE | grep -o -P '(?<=<meta name="title" content=")[^\"]*(?=">)')
   ADUPLOADER=$(cat $AD_CACHE_FILE | grep -o -P '(?<=<link itemprop="name" content=")[^\"]*(?=">)')
   #
   # quietly fetch the ad, and find the video file associated.
   # Attempt quality 18,
   # failover to 22,
   # pick best video less than or equal to 720p as last resort.
   yt-dlp $YTDLP_FLAG -f 18/22/"best[height<=?720]" $ADURL
   ADFILE=$(ls | grep "\["$line"\]\.")
   #
   # cleanup and log metadata to logfile...
   rm $AD_CACHE_FILE
   JSON="{ "$VIDINFO", ADTYPE:\"YouTube-hosted\", AD-UPLOADER:\""$ADUPLOADER"\", AD-URL:\""$ADURL"\", AD-TITLE=\""$ADTITLE"\", AD-FILE=\""$ADFILE"\" },"
   echo "$JSON" >> ./yt-ad-dl.log
   echo "AD DETECTED: $JSON"
   # flag as ad detected
   touch $AD_DETECT_FILE
 done
 
 echo e
 #
 # midroll test
 # Midroll ads are not implemented yet.
 # We request the adbreakurl for the sake of cookies anyway...
# cat $CACHE_FILE |\
# grep -Po '(?=var ytInitialPlayerResponse = ).*(?=<\/script>)' |\
# sed 's/var ytInitialPlayerResponse =//g' | jq | grep .getAdBreakUrl |\
# grep -oE "[^\"]*" | grep -vE "(getAdBreakUrl)|^:" | sed 's/&[a-z_]*=\[[A-Z_]*\]*//g' |\
# while read line; do
#   echo $line | grep ":" && curl -s -b cookiefile -c cookiefile "$line"
# done > /dev/null

 # Done. Remove cache file...
 rm $CACHE_FILE
 echo done
 ((count++))
 if [ -f $AD_DETECT_FILE ]; then count=9001; break; fi
done
rm $AD_DETECT_FILE
}
#cat tmp.html | grep -Eo "https:\/\/www.youtube.com\/get_midroll_info?[^\"]*"

DL_ADS "$1"
