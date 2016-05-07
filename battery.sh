#!/bin/sh

# --------- OPTIONS -----------

# battery level in % under which a warning is displayed
THRESHOLD=15

# time in seconds between checks
SLEEP_TIME=50

# notification options
NOTIFICATION_TITLE="Batterie"
NOTIFICATION_TEXT="Batteriestand unter ${THRESHOLD}%"

# sound effect options
SOUND_COMMAND="cvlc --play-and-exit"
SOUND_FILE='./Wolf.mp3'

# path to the battery-capacity file
CAPACITY_PATH=/sys/class/power_supply/BAT0/capacity
STATUS_PATH=/sys/class/power_supply/BAT0/status


# notification lock-file
LOCK_PATH=/tmp/battery-script-lock/
LOCK_FILE=lock

# -----------------------------

if [ ! -d ${LOCK_PATH} ]
   then
	mkdir -p ${LOCK_PATH}
fi

while [ true ]
 do
	# get capacity and battery status
	CAPACITY=`cat ${CAPACITY_PATH}`
	STATUS=`cat ${STATUS_PATH}`

	if [ "${STATUS}" = "Discharging" ]
	   then
		if [ ${CAPACITY} -lt ${THRESHOLD} ]
	 	   then
			if [ ! -e ${LOCK_PATH}${LOCK_FILE} ] 
			   then
				# display warning
				touch ${LOCK_PATH}${LOCK_FILE}

				notify-send -u critical "${NOTIFICATION_TITLE}" "${NOTIFICATION_TEXT}"
				${SOUND_COMMAND} ${SOUND_FILE}
	
			fi
		   else
			rm -f ${LOCK_PATH}${LOCK_FILE}
		fi
	   else
		rm -f ${LOCK_PATH}${LOCK_FILE}
	fi	

	sleep ${SLEEP_TIME}
done

