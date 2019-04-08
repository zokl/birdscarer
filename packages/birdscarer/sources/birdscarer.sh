#!/bin/sh

APPNAME="$(basename $0 .sh)"
HLASY_DIR="/usr/share/birdscarer/voices"

DEFAULT_MODE="venda"

DAY_DETECT="true"

# Nastaveni rezimu cinnosti

if [ -z "$1" ]; then
	MODE=$DEFAULT_MODE
else
	MODE="$1"
fi

function set_gpio {

  GPIO_PIN=11
  GPIO_SYSFS="/sys/class/gpio"

  echo $GPIO_PIN > $GPIO_SYSFS/export
  echo 0 > $GPIO_SYSFS/gpio$GPIO_PIN/active_low
  echo rising > $GPIO_SYSFS/gpio$GPIO_PIN/edge

}

function get_day_status {

if [ $DAY_DETECT == "true" ]; then
  STATUS=$(cat $GPIO_SYSFS/gpio$GPIO_PIN/value)
  if [ $STATUS == 1 ]; then
	logger -t $APPNAME "Night detected"
	return 1
  else
	logger -t $APPNAME "Day detected"
	return 0
  fi
else
  return 0
fi
}

function gen_number {
  local START=$1
  local STOP=$2

  awk -v min=$START -v max=$STOP 'BEGIN{srand(); print int(min+rand()*(max-min+1))}'
}

function play_sound {
  SONG=$1
  madplay -a 6 -t $PLAY_DURATION $SONG > /dev/null 2>&1
}

set_gpio

if [ "$MODE" == "auto" ]; then

logger -t $APPNAME "Mode AUTO"

PLAY_MIN_TIME=180
PLAY_MAX_TIME=900
NUM_SONGS=$(ls $HLASY_DIR/*.mp3 | wc -l)

	while true
	do
	if get_day_status ; then
	  PLAY_DURATION="00:00:$(gen_number 15 40)"
	  SONG_NUMBER=$(gen_number 1 $NUM_SONGS)
	  SONG_FILE=$(ls $HLASY_DIR/$SONG_NUMBER*.mp3)
	  logger -t $APPNAME "Voice file: $SONG_FILE"
	  logger -t $APPNAME "Play duration: $PLAY_DURATION s"

	  play_sound $SONG_FILE
	fi

	  SLEEP_TIME=$(gen_number $PLAY_MIN_TIME $PLAY_MAX_TIME)
	  logger -t spackoplas "Sleep time: $SLEEP_TIME sec."
	  sleep $SLEEP_TIME

	done

elif [ "$MODE" == "venda" ]; then

logger -t $APPNAME "Mode VENDA"
PLAY_MIN_TIME=20
PLAY_MAX_TIME=120
SONG_FILE="$HLASY_DIR/2_motak_luzni.mp3"

        while true
        do
	if get_day_status ; then
          PLAY_DURATION="00:00:$(gen_number 15 40)"
          logger -t $APPNAME "Voice file: $SONG_FILE"
          logger -t $APPNAME "Play duration: $PLAY_DURATION s"

          play_sound $SONG_FILE
	fi

          SLEEP_TIME=$(gen_number $PLAY_MIN_TIME $PLAY_MAX_TIME)
          logger -t spackoplas "Sleep time: $SLEEP_TIME sec."

          sleep $SLEEP_TIME

        done
else
	logger -t $APPNAME "Wrong choice"
	exit 1

fi

exit 0
