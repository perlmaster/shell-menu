#!/bin/ksh

######################################################################
#
# File      : test1.sh
#
# Author    : Barry Kimelman
#
# Created   : February 7, 2005
#
# Purpose   : Sample application to use the Menuing system.
#
######################################################################

######################################################################
#
# Function  : goodbye
#
# Purpose   : Signal catching routine to trap an "exit" and perform
#             end of program processing.
#
# Inputs    : (none)
#
# Output    : appropriate messages
#
# Returns   : (nothing)
#
# Example   : goodbye
#
# Notes     : This function is intended to be called only as a result
#             of an "exit" neing caught.
#
######################################################################

function goodbye
{
	kill -9 $clock_pid
	clear_screen
	echo "Thank you, come again soon..."
}

######################################################################
#
# Function  : MAIN
#
# Purpose   : Main part of application.
#
# Inputs    : $1 - optional name of menu file, default is "menu.txt"
#
# Output    : appropriate messages
#
# Returns   : (nothing)
#
# Example   : test1.sh
#
# Notes     : (none)
#
######################################################################

. curses.sh
. menu.sh

if [[ $# > 0 ]]
then
	menufile=$1
else
	menufile=menu.txt
fi

init_menu $menufile
status=$?
if [[ $status != 0 ]]
then
	echo "init_menu failed with status = $status"
	exit $status
fi

trap goodbye EXIT

myclock.sh &
clock_pid=$!

status=0
while [[ $status == 0 ]]
do
	draw_menu
	status=$?
	read reply
done

cursor_bottom
cursor_up_1

exit 0
