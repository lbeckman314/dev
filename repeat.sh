#!/bin/bash
# sources
# https://askubuntu.com/questions/359855/how-to-detect-insertion-of-dvd-disc


waitForDisk()
{

    # I'll try spinning. That's a good trick!
    case $(($i % 4)) in
            0 ) j="-" ;;
            1 ) j="\\" ;;
            2 ) j="|" ;;
            3 ) j="/" ;;
    esac

    echo -en "\r[$j]\e[1;37m waiting for cd in /dev/cdrom...\e[m"

    ((i=i+1))
}


i=0
while [ true ]
do
    if ! mount | grep -q /dev/cdrom; then
        echo -e "\e[1;36mcd detected, starting script...\e[m"
        # sleep 3
        ./music.sh

        # if music script encountered problems, exit script.
        if [ $? -ne 0 ]
        then
            echo -e "\e[1;31mmusic.sh hit rocky waters.\e[m" >&2
            exit 1
        fi

        wait

    else
        waitForDisk
    fi
    sleep 0.5
done

