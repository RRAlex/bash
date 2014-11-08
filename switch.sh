#!/bin/bash
# Copyright (c) 2014 Alexandre Guédon
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
# Simple script to control a Ubiquiti mFi-LD from bash

IP=192.168.1.135
USER=root
PASS=ubnt
SESSIONID=01234567890123456789012345678901

print_help()
{
        echo "REST API usage:"
        echo "$0 [arg]"
        echo -e "\toff, on, dimdown, dimup, status"
    exit 1
}

if [ $# -lt 1 ]; then
    print_help
fi

# Login ##############################
login_web()
{
    curl -k -X POST -d "username=${USER}&password=${PASS}" -b "AIROS_SESSIONID=${SESSIONID}" https://${IP}/login.cgi
    echo "Logged in"
}

# Logout #############################
logout_web()
{
    curl -k -b "AIROS_SESSIONID=${SESSIONID}" https://${IP}/logout.cgi
    echo "Logged out"
}

# Init signal handler ################
init()
{
    for f in 2
    do
        trap "handle $f" $f
    done
}

# Handle logout if user breakout #####
handle()
{
    case $1 in

        1) echo That was SIGHUP;;
        2) 
            echo
            echo "SIGINT (CTRL-C) received, cleaning up"
            logout_web
            exit
            ;;
        3) echo That was SIGINIT;;
        9) echo That was SIGTERM;;
        15) echo That was SIGTERM;;
        *) echo Default HANDLER;;
    esac
} 
# Command dispatch ###################
init

login_web

case $1 in
    # Power off
    off)
        curl -k -X PUT -d output=0 -b "AIROS_SESSIONID=${SESSIONID}" https://${IP}/sensors/1
        echo "Power off"
        ;;

    # Power on
    on)
        curl -k -X PUT -d output=1 -b "AIROS_SESSIONID=${SESSIONID}" https://${IP}/sensors/1
        echo "Power on"
        ;;

    # Dim light down from current value
    dimdown)
        DIMLVL=$(curl -k -s -b "AIROS_SESSIONID=${SESSIONID}" https://${IP}/sensors | sed 's/.*"dimmer_level":\([0-9]*\).*/\1/')
        echo "Starting value : ${DIMLVL} %"
        for i in $(seq 1 ${DIMLVL} | tac); do
            curl -k -X PUT -d "output=1&dimmer_level=${i}" -b "AIROS_SESSIONID=${SESSIONID}" https://${IP}/sensors/1 > /dev/null 2>&1
            echo -ne "Dim level: ${i}\r"
        done
        # Turn OFF
        curl -k -X PUT -d "output=0&dimmer_level=0" -b "AIROS_SESSIONID=${SESSIONID}" https://${IP}/sensors/1 > /dev/null 2>&1
        echo "Dim down to 0% than OFF"
        ;;

    # Dim light up from current value
    dimup)
        DIMLVL=$(curl -k -s -b "AIROS_SESSIONID=${SESSIONID}" https://${IP}/sensors | sed 's/.*"dimmer_level":\([0-9]*\).*/\1/')
        echo "Starting value : ${DIMLVL} %"
        for i in $(seq ${DIMLVL} 100); do
            curl -k -X PUT -d "output=1&dimmer_level=${i}" -b "AIROS_SESSIONID=${SESSIONID}" https://${IP}/sensors/1 > /dev/null 2>&1
            echo -ne "Dim level: ${i}\r"
        done
        echo "ON than dim up to 100%"
        ;;

    # Dim to specific level of 2nd argument
    dim)
        curl -k -X PUT -d "output=1&dimmer_level=${2}" -b "AIROS_SESSIONID=${SESSIONID}" https://${IP}/sensors/1 > /dev/null 2>&1
        echo "Dimmed to ${2} %"
        ;;

    # Get JSON status
    status)
        curl -k -s -b "AIROS_SESSIONID=${SESSIONID}" https://${IP}/sensors
        ;;

    # Default
    *)
        print_help
        ;;
esac

logout_web


