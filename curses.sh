#!/bin/ksh

######################################################################
#
# File      : curses.sh
#
# Author    : Barry Kimelman
#
# Created   : February 7, 2005
#
# Purpose   : Module containing functions and data to implement screen
#             manipulation functionality in a manner similar to the
#             curses library does for C programs.
#
#             It contains several functions :
#                 (1) init_screen
#                 (2) move_cursor
#                 (3) clear_screen
#                 (4) clear_eol
#                 (5) clear_bol
#                 (6) clear_eos
#                 (7) cursor_bottom
#                 (8) cursor_up_1
#                 (9) cursor_down_1
#                 (10) cursor_back_1
#                 (11) cursor_forward_1
#                 (12) cursor_home
#                 (13) cursor_save
#                 (14) cursor_restore
#                 (15) create_window
#                 (16) goto_window
#
#             See function header comments for further details.
#
######################################################################

######################################################################
#
# Function  : init_screen
#
# Purpose   : Do initialization for screen manipulation functions.
#
# Inputs    : (none)
#
# Output    : (none)
#
# Returns   : (nothing)
#
# Example   : init_screen
#
# Notes     : (none)
#
######################################################################

function init_screen
{
	CUP1=`tput cuu1`
	CDOWN1=`tput cud1`
	CBACK1=`tput cub1`
	CFORWARD1=`tput cuf1`
	CHOME=`tput home`
	CSAVE=`tput sc`
	CRESTORE=`tput rc`

	NUM_LINES=`tput lines`
	let "NUM_LINES2 = NUM_LINES - 1"
	NUM_COLS=`tput cols`
	let "NUM_COLS2 = NUM_COLS - 1"
	LLC=`tput cup $NUM_LINES2 0`

	BOLD=$(tput smso)
	NOBOLD=$(tput rmso)
	UL=$(tput smul)
	NOUL=$(tput rmul)

	CLEAR=`tput clear`  # clear screen and home cursor
	CLB=`tput el1`  # clear to beginning of line
	CLE=`tput el`  # clear to end of line
	CLD=`tput el`  # clear to end of display

	return
} # end of init_screen

######################################################################
#
# Function  : move_cursor
#
# Purpose   : Move the cursor to the specified position.
#
# Inputs    : $1 - row number
#             $2 - column number
#             $3 - flag indicating if arguments are zero-origin or one-origin
#
# Output    : (none)
#
# Returns   : (nothing)
#
# Example   : move_cursor $row $col 1
#
# Notes     : If the coordinates are one-origin then they must be
#             converted to zero-origin.
#
######################################################################

function move_cursor
{
	typeset -i row
	typeset -i col
	typeset -i origin
	typeset move

	row=$1
	col=$2
	if [[ $origin != 0 ]]
	then
		let "row -= 1"
		let "col -= 1"
	fi
	move=`tput cup $row $col`
	print -n "${move}"

	return
} # end of move_cursor

######################################################################
#
# Function  : clear_screen
#
# Purpose   : Clear the screen and "home" the cursor.
#
# Inputs    : (none)
#
# Output    : (none)
#
# Returns   : (nothing)
#
# Example   : clear_screen
#
# Notes     : (none)
#
######################################################################

function clear_screen
{
	print -n "${CLEAR}"

	return
} # end of clear_screen

######################################################################
#
# Function  : clear_eol
#
# Purpose   : Clear to the end of the line.
#
# Inputs    : (none)
#
# Output    : (none)
#
# Returns   : (nothing)
#
# Example   : clear_eol
#
# Notes     : (none)
#
######################################################################

function clear_eol
{
	print -n "${CLE}"

	return
} # end of clear_eol

######################################################################
#
# Function  : clear_bol
#
# Purpose   : Clear to the beginning of the line.
#
# Inputs    : (none)
#
# Output    : (none)
#
# Returns   : (nothing)
#
# Example   : clear_bol
#
# Notes     : (none)
#
######################################################################

function clear_bol
{
	print -n "${CLB}"

	return
} # end of clear_bol

######################################################################
#
# Function  : clear_eos
#
# Purpose   : Clear to the end of the display.
#
# Inputs    : (none)
#
# Output    : (none)
#
# Returns   : (nothing)
#
# Example   : clear_eos
#
# Notes     : (none)
#
######################################################################

function clear_eos
{
	print -n "${CLD}"

	return
} # end of clear_eos

######################################################################
#
# Function  : cursor_bottom
#
# Purpose   : Move the cursor to the lower-left-corner of the display.
#
# Inputs    : (none)
#
# Output    : (none)
#
# Returns   : (nothing)
#
# Example   : cursor_bottom
#
# Notes     : (none)
#
######################################################################

function cursor_bottom
{
	print -n "${LLC}"

	return
} # end of cursor_bottom

######################################################################
#
# Function  : cursor_up_1
#
# Purpose   : Move the cursor up one line.
#
# Inputs    : (none)
#
# Output    : (none)
#
# Returns   : (nothing)
#
# Example   : cursor_up_1
#
# Notes     : (none)
#
######################################################################

function cursor_up_1
{
	print -n "${CUP1}"

	return
} # end of cursor_up_1

######################################################################
#
# Function  : cursor_down_1
#
# Purpose   : Move the cursor down one line.
#
# Inputs    : (none)
#
# Output    : (none)
#
# Returns   : (nothing)
#
# Example   : cursor_down_1
#
# Notes     : (none)
#
######################################################################

function cursor_down_1
{
	print -n "${CDOWN1}"

	return
} # end of cursor_down_1

######################################################################
#
# Function  : cursor_back_1
#
# Purpose   : Move the cursor backward 1 column.
#
# Inputs    : (none)
#
# Output    : (none)
#
# Returns   : (nothing)
#
# Example   : cursor_back_1
#
# Notes     : (none)
#
######################################################################

function cursor_back_1
{
	print -n "${CBACK1}"

	return
} # end of cursor_back_1

######################################################################
#
# Function  : cursor_forward_1
#
# Purpose   : Move the cursor forward 1 column.
#
# Inputs    : (none)
#
# Output    : (none)
#
# Returns   : (nothing)
#
# Example   : cursor_forward_1
#
# Notes     : (none)
#
######################################################################

function cursor_forward_1
{
	print -n "${CFORWARD1}"

	return
} # end of cursor_forward_1

######################################################################
#
# Function  : cursor_home
#
# Purpose   : Move the cursor forward 1 column.
#
# Inputs    : (none)
#
# Output    : (none)
#
# Returns   : (nothing)
#
# Example   : cursor_home
#
# Notes     : (none)
#
######################################################################

function cursor_home
{
	print -n "${CHOME}"

	return
} # end of cursor_home

######################################################################
#
# Function  : center_message
#
# Purpose   : Write a message centered on the specified row.
#
# Inputs    : $1 - row number
#             $2 - message string
#
# Output    : (none)
#
# Returns   : (nothing)
#
# Example   : center_message 3 "hello world"
#
# Notes     : (none)
#
######################################################################

function center_message
{
	typeset -i row
	typeset -i col
	typeset message
	typeset -i length

	row=$1
	message=$2

	length=${#message}
	let "col = NUM_COLS - length"
	let "col = col / 2"
	move_cursor $row $col 1
	print -n "$message"

	return
} # end of center_message

######################################################################
#
# Function  : center_message_bold
#
# Purpose   : Write a BOLD message centered on the specified row.
#
# Inputs    : $1 - row number
#             $2 - message string
#
# Output    : (none)
#
# Returns   : (nothing)
#
# Example   : center_message_bold 3 "hello world"
#
# Notes     : (none)
#
######################################################################

function center_message_bold
{
	typeset -i row
	typeset -i col
	typeset message
	typeset -i length

	row=$1
	message=$2

	length=${#message}
	let "col = NUM_COLS - length"
	let "col = col / 2"
	move_cursor $row $col 1
	print -n "${BOLD}$message${NOBOLD}"

	return
} # end of center_message_bold

######################################################################
#
# Function  : center_message_underline
#
# Purpose   : Write an UNDERLINED message centered on the specified row.
#
# Inputs    : $1 - row number
#             $2 - message string
#
# Output    : (none)
#
# Returns   : (nothing)
#
# Example   : center_message_underline 3 "hello world"
#
# Notes     : (none)
#
######################################################################

function center_message_underline
{
	typeset -i row
	typeset -i col
	typeset message
	typeset -i length

	row=$1
	message=$2

	length=${#message}
	let "col = NUM_COLS - length"
	let "col = col / 2"
	move_cursor $row $col 1
	print -n "${UL}$message${NOUL}"

	return
} # end of center_message_underline

######################################################################
#
# Function  : cursor_save
#
# Purpose   : Save the current cursor position
#
# Inputs    : (none)
#
# Output    : (none)
#
# Returns   : (nothing)
#
# Example   : cursor_save
#
# Notes     : (none)
#
######################################################################

function cursor_save
{
	print -n "${CSAVE}"

	return
} # end of cursor_save

######################################################################
#
# Function  : cursor_restore
#
# Purpose   : Restore the current cursor position
#
# Inputs    : (none)
#
# Output    : (none)
#
# Returns   : (nothing)
#
# Example   : cursor_restore
#
# Notes     : (none)
#
######################################################################

function cursor_restore
{
	print -n "${CRESTORE}"

	return
} # end of cursor_restore
