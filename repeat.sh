#!/bin/bash
# sources
# https://askubuntu.com/questions/359855/how-to-detect-insertion-of-dvd-disc
# https://www.linuxquestions.org/questions/slackware-14/detect-cd-tray-status-4175450610/


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

sleepTime()
{

    # I'll try spinning. That's a good trick!
    while [ $n -ge 0 ]
    do
        echo -en "\r[$n]\e[1;37m giving cd time to run...\e[m"

        sleep 1
        ((n=n-1))
    done
    echo
}


i=0
n=15
while [ true ]
do
    read count < albumNum
    if ! ./trayopen /dev/sr0
    then
        echo -e "\n\e[1;36mcd detected, starting script...\e[m"
        #sleep $n
        sleepTime
        date
        date > .log/log.$count.txt
        time ./music.sh | tee -a .log/log.$count.txt

        # if music script encountered problems, exit script.
        if [ $? -ne 0 ]
        then
            echo -e "\e[1;31mmusic.sh hit rocky waters.\e[m" >&2
            exit 1
        fi

        date
        date >> .log/log.$count.txt

        # wait

        ((count++))
        echo $count > albumNum

    else
        waitForDisk
    fi
    sleep 0.5
done

