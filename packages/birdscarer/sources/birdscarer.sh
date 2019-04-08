#!/bin/sh

APPNAME="$(basename $0 .sh)"
HLASY_DIR="/usr/share/birdscarer/voices"
NUM_SONGS=$(ls $HLASY_DIR/*.mp3 | wc -l)

PLAY_MIN_TIME=180
PLAY_MAX_TIME=900

function gen_number {
  local START=$1
  local STOP=$2

  awk -v min=$START -v max=$STOP 'BEGIN{srand(); print int(min+rand()*(max-min+1))}'
}

function play_sound {
  SONG=$1
  madplay -a 6 -t $PLAY_DURATION $SONG > /dev/null 2>&1
}


while true
do
  PLAY_DURATION="00:00:$(gen_number 15 40)"
  SONG_NUMBER=$(gen_number 1 $NUM_SONGS)
  SONG_FILE=$(ls $HLASY_DIR/$SONG_NUMBER*.mp3)
  logger -t $APPNAME "Voice file: $SONG_FILE"
  logger -t $APPNAME "Play duration: $PLAY_DURATION s"

  play_sound $SONG_FILE

  SLEEP_TIME=$(gen_number $PLAY_MIN_TIME $PLAY_MAX_TIME)
  logger -t spackoplas "Sleep time: $SLEEP_TIME sec."
  sleep $SLEEP_TIME

done

exit 0
