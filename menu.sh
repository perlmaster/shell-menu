#!/bin/ksh

######################################################################
#
# File      : menu.sh
#
# Author    : Barry Kimelman
#
# Created   : February 7, 2005
#
# Purpose   : Module containing menu functions built using the functions
#             defined in curses.sh.
#
#             It contains several functions :
#                 (1) init_menu
#                 (2) draw_menu
#                 (3) get_menu_selection
#
#             See function header comments for further details.
#
######################################################################

# The structure of the menu file is as follows :
#
# menu header line 1
# menu header line 2
# number indicating number of items in menu
# prompt_row prompt_col prompt_string
# menu_item line 1
# menu_item line 2

# The structure of the menu item line is as follows :
#
# row_number column_number choice_number choice_text command_text

######################################################################
#
# Function  : init_menu
#
# Purpose   : Do initialization for screen manipulation functions.
#
# Inputs    : $1 - name of file containing menu definition
#
# Output    : appropriate messages
#
# Returns   : If no errors Then 0 Else appropriate error code
#
# Example   : init_menu menu.txt
#
# Notes     : This function will initialize some global variables
#             used by all the other menu functions.
#
######################################################################

function init_menu
{
	typeset menu_filename
	typeset -i menu_file_num_rows
	typeset tempfile
	typeset -i expected_lines
	typeset menu_line
	typeset -i menu_column
	typeset -i menu_row
	typeset menu_text
	typeset menu_choice
	typeset menu_command
	typeset -i count
	typeset junk

	init_screen   #  do curses.sh initialization
	clear_screen
	OLDSTTY=$(stty -g)

	menu_filename=$1
	if [[ ! -a $menu_filename ]]
	then
		print "Menu file \"$menu_filename\" does not exist"
		return 1
	fi
	if [[ ! -r $menu_filename ]]
	then
		print "Menu file \"$menu_filename\" is not readable"
		return 2
	fi

	menu_file_num_rows=$(wc -l $menu_filename | awk '{print $1}')
	if [[ $? != 0 ]]
	then
		print "Error verifying number of rows in menu file"
		return 3
	fi
	if [[ $menu_file_num_rows < 5 ]]
	then
		print "Insufficient data in menu file"
		return 4
	fi
	
	num_menu_items=$(head -3 $menu_filename | tail -1)
	let "expected_lines = num_menu_items + 4"
	if [[ $menu_file_num_rows != $expected_lines ]]
	then
		print "Incorrect number of lines in menu file"
		print "Expected number of lines is $expected_lines"
		print "Actual number of lines is $menu_file_num_rows"
		return 5
	fi

	menu_line=`head -1 $menu_filename`
	print "$menu_line" | read menu_row menu_col menu_text
	if [[ "$menu_text" == "" ]]
	then
		print "Empty menu header 1"
	fi
	menu_header_1_row=$menu_row
	menu_header_1_column=$menu_column
	menu_header_1_text=$menu_text

	menu_line=`head -2 $menu_filename | tail -1`
	print "$menu_line" | read menu_row menu_col menu_text
	if [[ "$menu_text" == "" ]]
	then
		print "Empty menu header 2"
	fi
	menu_header_2_row=$menu_row
	menu_header_2_column=$menu_column
	menu_header_2_text=$menu_text

	menu_line=`head -4 $menu_filename | tail -1`
	print "$menu_line" | read menu_prompt_row menu_prompt_column menu_prompt_string

	tempfile=/var/tmp/menu.$$
	tail -$num_menu_items $menu_filename >$tempfile
	cat -n $tempfile

	count=0
	while read menu_row menu_col menu_choice menu_text menu_command junk
	do
		menu_text_list[$count]="$menu_text"
		menu_text_rows[$count]=$menu_row
		menu_text_columns[$count]=$menu_col
		menu_text_choices[$count]=$menu_choice
		menu_text_commands[$count]=$menu_command
		let "count += 1"
	done <$tempfile
	/bin/rm -f $tempfile

	return 0
} # end of init_menu

######################################################################
#
# Function  : draw_menu
#
# Purpose   : Draw the menu and get the user's selection.
#
# Inputs    : (none)
#
# Output    : the menu
#
# Returns   : If no errors Then 0 Else appropriate error code
#
# Example   : draw_menu
#
# Notes     : (none)
#
######################################################################

function draw_menu
{
	typeset -i count
	typeset -i row
	typeset -i col
	typeset menu_text
	typeset menu_choice
	typeset menu_command

	clear_screen

	center_message_bold $menu_header_1_row "$menu_header_1_text"

	center_message_underline $menu_header_2_row "$menu_header_2_text"

	count=0
	while [[ $count < $num_menu_items ]]
	do
		row=${menu_text_rows[$count]}
		col=${menu_text_columns[$count]}
		menu_text=${menu_text_list[$count]}
		menu_choice=${menu_text_choices[$count]}
		menu_command=${menu_text_commands[$count]}
		move_cursor $row $col 1
		print -n "$menu_choice - $menu_text [ $menu_command ]"
		let "count += 1"
	done
	move_cursor $menu_prompt_row $menu_prompt_column 1
	print -n "$menu_prompt_string"
	get_menu_selection
	count=$?
	menu_command=${menu_text_commands[$count]}
	$menu_command

	return 0
} # end of draw_menu

######################################################################
#
# Function  : get_menu_selection
#
# Purpose   : Read a user's menu selection.
#
# Inputs    : (none)
#
# Output    : the menu
#
# Returns   : The user's menu selection
#
# Example   : get_menu_selection
#             choice=$?
#
# Notes     : (none)
#
######################################################################

function get_menu_selection
{
	typeset reply
	typeset char
	typeset -i flag
	typeset -i count
	typeset -i selection

	flag=0
	while [[ $flag == 0 ]]
	do
		read reply
		count=0
		flag=0
		while [[ $flag == 0 && $count < $num_menu_items ]]
		do
			if [[ $reply == ${menu_text_choices[$count]} ]]
			then
				flag=1
				selection=$count
			fi
			let "count += 1"
		done
		if [[ $flag == 0 ]]
		then
			move_cursor $menu_prompt_row $menu_prompt_column 1
			clear_eol
			print -n "Invalid selection , try again : "
		fi
	done

	return $selection
} # end of get_menu_selection
