#!/bin/bash
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
# April's fool 2004 CASINO@DIRO ;-)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
# if 1e avril
if [ `date +%m%d` -ne "0401" ]; then 
	exit
fi
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
if [ -f ~/.POISSONDAVRIL ]; then 
        NUMBER=`tail -1 ~/.POISSONDAVRIL`
        if [ $NUMBER -ge "2" ] ; then
                echo "Joyeux poisson d'avril"
                sleep 3
                exit
        else
                echo $((NUMBER +1)) >> ~/.POISSONDAVRIL
        fi
else # first run
    touch ~/.POISSONDAVRIL
        echo 1 >> ~/.POISSONDAVRIL
fi
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
# BSOD
echo -e "[0m[2J[1;1H[0;25;37;44m                                                                                "
echo -e "                                                                                "
echo -e "                                                                                "
echo -e "                                                                                "
echo -e "                                                                                "
echo -e "                                                                                "
echo -e "                                                                                "
echo -e "                                                                                "
echo -e "                                   [34;47m Windows [44mws[37m                                  "
echo -e "                                                                                "
echo -e "[1m       An exception 0E has occurred at 0028:C0018DBA in VxD IFSMGR(01) +        "
echo -e "       0000340A.  This was called from 0028:C0034118 in VxD NDIS(01) +          "
echo -e "       00000D7C.  It may be possible to continue normally.                      "
echo -e "                                                                                "
echo -e "       *  Press any key to attempt to continue                                  "
echo -e "       *  Press CTRL+ALT+DEL to restart your computer. You will                 "
echo -e "          lose any unsaved information in all applications                      "
echo -e "                                                                                "
echo -e "                           Press Any key to continue.                           "
echo -e "                                                                                "
echo -e "                                                                                "
echo -e "                                                                                "
echo -e "                                                                                "
echo -e "                                                                                "
echo -e "                                                                                [0;37;40m"
echo -e "]2;Lithium server\[1A"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#echo -ne "\033[2J" # CLEAR
XWIN=`xdpyinfo |grep dimensions|awk {'print $2'}|sed s/x.*//`
YWIN=`xdpyinfo |grep dimensions|awk {'print $2'}|sed s/[0-9]*x//g`

for f in `seq 1 15`
do
	trap "handle $f" $f 
done

while(true)
do
#	xset led 3
	echo -ne "\e]1;${RANDOM}\007\e]2;${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}\007" # ICON / TITLE random
	XW=`echo "\`head -1 /dev/urandom | md5sum | sed s/[a-z]//g|cut -f1 -d" "\` % ${XWIN} - 150" | bc` # x position
	YW=`echo "\`head -1 /dev/urandom | md5sum | sed s/[a-z]//g|cut -f1 -d" "\` % ${YWIN} - 150" | bc` # y position
	XH=`echo "\`head -1 /dev/urandom | md5sum | sed s/[a-z]//g|cut -f1 -d" "\` % ${XWIN}" | bc` # x width
	YH=`echo "\`head -1 /dev/urandom | md5sum | sed s/[a-z]//g|cut -f1 -d" "\` % ${YWIN}" | bc` # y height
# 320x240 taille minimale
    if [ $XH -lt 480 ]; then # taille du BSOD
        XH=480 
    fi
    if [ $YH -lt 320 ]; then # taille du BSOD
        YH=320
    fi

	VOL=`echo "\`head -1 /dev/urandom   | head -1 | md5sum | sed s/[a-z]//g | cut -f1 -d" "\` % 100" | bc`
	PITCH=`echo "\`head -1 /dev/urandom | head -1 | md5sum | sed s/[a-z]//g | cut -f1 -d" "\` % 20000" | bc`
	DURATION=`echo "\`head -1 /dev/urandom | head -1 | md5sum | sed s/[a-z]//g | cut -f1 -d" "\` % 2000" | bc`
	X=`echo "\`head -1 /dev/urandom | md5sum | sed s/[a-z]//g|cut -f1 -d" "\` % 81" | bc`
	Y=`echo "\`head -1 /dev/urandom | md5sum | sed s/[a-z]//g|cut -f1 -d" "\` % 25" | bc`
	A=`echo "\`head -1 /dev/urandom | md5sum | sed s/[a-z]//g|cut -f1 -d" "\` % 8" | bc`
	B=`echo "\`head -1 /dev/urandom | md5sum | sed s/[a-z]//g|cut -f1 -d" "\` % 8" | bc`
	C=`echo "\`head -1 /dev/urandom | md5sum | sed s/[a-z]//g|cut -f1 -d" "\` % 2" | bc`
	D=`echo "\`head -1 /dev/urandom | md5sum | sed s/[a-z]//g|cut -f1 -d" "\` % 2" | bc`
	COLORBG="\033[${C};4${A}m" # BACKGROUND
	COLOR="\033[${D};3${B}m"  # COULEUR
	
	echo -ne "\033[3;${XW};${YW}t" # MOVE WINDOW POSITION
	echo -ne "\033[4;${XH};${YH}t" # MOVE WINDOW SIZE
	echo -ne "$COLOR$COLORBG" # SET COLOR
	echo -ne "\033[${Y};${X}f" # SET POSITION
	echo -ne "HAHA\a"	# OUTPUT X
	xset b $VOL $PITCH $DURATION
	xset -led 3
done
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function handle()
{ 
	case $1 in 
	1) echo That was SIGHUP;; 
	2) echo That was SIGINT;; 
	3) echo That was SIGINIT;; 
	9) echo That was SIGTERM;; 
	15) echo That was SIGTERM;;
	*) echo Default HANDLER;;
	esac 
} 
