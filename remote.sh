#!/bin/bash
# Copyright (c) 2012 Alexandre Guédon
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

################################################################
# Simple script to control an Onkyo TX-NR609 from bash
# The IP and PORT of your AVR (Might work with similar models)
#
# Search for Onkyo_RS-232_RCVR_083109.xls or Onkyo_cmds.xls
# for the commands' values.

IP=192.168.1.249
PORT=60128

print_help()
{
        echo "$0 [arg]"
        echo -e "\toff, on, pwrstat"
        echo -e "\tmute, mutestat, vup[1], vdown[1]"
        echo -e "\tz2on, z2off, z2stat, z2vup, z2vdown, z2vstat"
        echo -e "\tinputstat, game, pc, z2pc, tuner, z2tuner, net, z2net"
        echo -e "\tnetpause, netplay, netstop, netprev, netnext"
        echo -e "\tnetup, netdown, netleft, netright, netselect, netreturn"
        echo -e "\ttunerstat, tunerdown, tunerup"
        echo -e "\tmodestat, dimmerstat, dimmertogger"
    exit 1
}

if [ $# -lt 1 ]; then
    print_help
fi
# Command to send: 
for i in "$@"; 
do
    case $i in
    # Power 
    off)
        COMMAND='!1PWR00'
        echo "Power off"
        ;;
    on)
        COMMAND='!1PWR01'
        echo "Power on"
        ;;
    pwrstat)
        COMMAND='!1PWRQSTN'
        echo "Power Status"
        ;;
    # Volume control
    forcemute)
        COMMAND='!1AMT01'
        echo "Muting"
        ;;
    forceunmute)
        COMMAND='!1AMT00'
        echo "Unmuting"
        ;;
    mute)
        COMMAND='!1AMTTG'
        echo "Toggling Mute"
        ;;
    mutestat)
        COMMAND='!1AMTQSTN'
        echo "Mute Status"
        ;;
    vup)
        COMMAND='!1MVLUP'
        echo "Volume up"
        ;;
    vup1)
        COMMAND='!1MVLUP1'
        echo "Volume up"
        ;;
    vdown)
        COMMAND='!1MVLDOWN'
        echo "Volume down"
        ;;
    vdown1)
        COMMAND='!1MVLDOWN1'
        echo "Volume down"
        ;;
    # Front speakers equalizer
    bassup)
        COMMAND='!1TFRBUP'
        echo "Bass up"
        ;;
    bassdown)
        COMMAND='!1TFRBDOWN'
        echo "Bass down"
        ;;
    trebleup)
        COMMAND='!1TFRTUP'
        echo "Treble up"
        ;;
    trebledown)
        COMMAND='!1TFRTDOWN'
        echo "Treble down"
        ;;
    eqstat)
        COMMAND='!1TFRQSTN'
        echo "Bass/Treble stats"
        ;;
    # ZONE 2
    z2on)
        COMMAND='!1ZPW01'
        echo "Zone 2 on"
        ;;
    z2off)
        COMMAND='!1ZPW00'
        echo "Zone 2 off"
        ;;
    z2stat)
        COMMAND='!1ZPWQSTN'
        echo "Zone 2 Status"
        ;;
    z2vdown)
        COMMAND='!1ZVLDOWN'
        echo "Zone 2 Volume Down"
        ;;
    z2vup)
        COMMAND='!1ZVLUP'
        echo "Zone 2 Volume Up"
        ;;
    z2vstat)
        COMMAND='!1ZVLQSTN'
        echo "Zone 2 Volume Stat"
        ;;
# INPUT SELECTION
    inputstat)
        COMMAND='!1SLIQSTN'
        echo "GET current INPUT"
        ;;
    game)
        COMMAND='!1SLI02'
        echo "INPUT: Game"
        ;;
    pc)
        COMMAND='!1SLI05'
        echo "INPUT: PC"
        ;;
    z2pc)
        COMMAND='!1SLZ05'
        echo "Zone 2 INPUT: PC"
        ;;
    tuner)
        COMMAND='!1SLI26'
        echo "INPUT: Tuner"
        ;;
    z2tuner)
        COMMAND='!1SLZ26'
        echo "Zone 2 INPUT: Tuner"
        ;;
    net)
        COMMAND='!1SLI2B'
        echo "INPUT: Network"
        ;;
    z2net)
        COMMAND='!1SLZ2B'
        echo "Zone 2 INPUT: Network"
        ;;
    # NETWORK COMMANDS Play, pause, etc.
    netplay)
        COMMAND='!1NTCPLAY'
        echo "Network PLAY"
        ;;
    netpause)
        COMMAND='!1NTCPAUSE'
        echo "Network PAUSE"
        ;;
    netstop)
        COMMAND='!1NTCSTOP'
        echo "Network STOP"
        ;;
    netnext)
        COMMAND='!1NTCTRUP'
        echo "Network Track UP"
        ;;
    netprev)
        COMMAND='!1NTCTRDN'
        echo "Network Track Down"
        ;;
    netleft)
        COMMAND='!1NTCLEFT'
        echo "Network Left Key"
        ;;
    netright)
        COMMAND='!1NTCRIGHT'
        echo "Network Right Key"
        ;;
    netup)
        COMMAND='!1NTCUP'
        echo "Network Up Key"
        ;;
    netdown)
        COMMAND='!1NTCDOWN'
        echo "Network Down Key"
        ;;
    netselect)
        COMMAND='!1NTCSELECT'
        echo "Network select current Menu"
        ;;
    netreturn)
        COMMAND='!1NTCRETURN'
        echo "Network Return Last Menu"
        ;;
    # TUNER FM: nnn.nn, AM: nnnnn (broken?)
    tunerstat)
        COMMAND='!1TUNQSTN'
        echo "Tuner Stat"
        ;;
    tunerdown)
        COMMAND='!1TUNDOWN'
        echo "Tuner DOWN"
        ;;
    tunerup)
        COMMAND='!1TUNUP'
        echo "Tuner UP"
        ;;

# LISTENING MODE (Sound)
    modestat)
        COMMAND='!1LMDQSTN'
        echo "Listening Mode Stats"
        ;;
    displaystat)
        COMMAND='!1DIFQSTN'
        echo "Display Mode Stats"
        ;;
    dimmerstat)
        COMMAND='!1DIMQSTN'
        echo "Dimmer Mode Stats"
        ;;
    dimmertoggle)
        COMMAND='!1DIMDIM'
        echo "Dimmer Mode Wrap-Around Up"
        ;;
    *)
        print_help
        ;;
    esac

    # String to send is :
    ISCP="ISCP\x00\x00\x00\x10\x00\x00\x00"
    LENGTH=$(echo "\x$(printf "%0.2x" $(echo $COMMAND | wc -c ))")
    MID="\x01\x00\x00\x00"
    CMD=${COMMAND} # just to be linearly explicit about the format
    END="\x0D"

    # Muting would look like this:
    # echo -e 'ISCP\x00\x00\x00\x10\x00\x00\x00\x08\x01\x00\x00\x00!1AMT00\x0D' | nc $IP $PORT

    echo -en "${ISCP}${LENGTH}${MID}${CMD}${END}" | nc -i 1 $IP $PORT
done

