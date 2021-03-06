#!/bin/bash
# sources:
# http://mywiki.wooledge.org/BashFAQ/003
# https://stackoverflow.com/questions/5885934/bash-function-to-find-newest-file-matching-pattern
# https://stackoverflow.com/questions/15644991/running-several-scripts-in-parallel-bash-script
# https://stackoverflow.com/questions/1378274/in-a-bash-script-how-can-i-exit-the-entire-script-if-a-certain-condition-occurs
# https://stackoverflow.com/questions/2990414/echo-that-outputs-to-stderr


# abcde options
# -N: non-interactive, no input
# -x: eject cd after process
# -o: output format (mp3)
# -B: embed album art into tracks
OPTS="-N -x -B -o mp3"

# nextcloud address
URL="pi@liambeckman.com:/media/drive/nextcloud/music"

# email address for notification
EMAIL="lbeckman314@gmail.com"

# directory to hold albums
DIR="$HOME/Audio/cds/musicDir"


cd $DIR

# get tracks
abcde $OPTS

# if abcde encountered problems, exit script.
if [ $? -ne 0 ]
then
    echo -e "\e[1;31mabcde hit rocky waters.\e[m" >&2
    #exit 1
fi


# email notification of completion (can now change cd's).
echo ":)" | mail -s abcde $EMAIL


# get latest music directory (album)
unset -v latest
for music in ./*
do
    if [ -d "$music" ]
    then
        [[ $music -nt $latest ]] && latest=$music
    fi
done


# transfer album to pi to be accessible by nextcloud.
scp -r $latest $URL &


# wait until copy process is complete before exiting.
wait

