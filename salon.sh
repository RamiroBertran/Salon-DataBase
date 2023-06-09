#!/bin/bash
PSQL="psql -X --username=kvothe_snow --dbname=salon --tuples-only --no-align -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "\nWelcome to My Salon, how can I help you?"
MAIN_MENU() {
	if [[ $1 ]]
	then 
		echo -e "\n$1"
	fi
echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim"
read MENU_OPTION
case $MENU_OPTION in 
	1) CUT ;;
	2) COLOR ;;
	3) PERM ;; 
	4) STYLE ;; 
	5) TRIM ;; 
	6) EXIT ;;
	*) MAIN_MENU "I could not find that service. What would you like today?" ;;
esac


}

ASK_PHONE="$(echo -e "\nWhat's your phone number?\n")"

CUT() {
	#ask for phone number
	echo $ASK_PHONE
	read PHONE_NUMBER
	PHONE="$($PSQL "SELECT phone FROM appointments WHERE phone='$PHONE_NUMBER'")"
	if [[ -z $PHONE ]]
	then 
		# insert phone number 
		echo "$($PSQL "INSERT INTO appointments(customer_id, service_id, phone, time) VALUES(null, null, '$PHONE_NUMBER', null)")"
		APM_PHONE="$($PSQL "SELECT * FROM appointments")"
		echo $APM_PHONE
		echo -e "\nI don't have a record for that phone number, what's your name?"
		read NAME
		# insert client to database && phone result
		INSERT_NAME_RESULT="$($PSQL "INSERT INTO customers(name) VALUES('$NAME')")"
		#send to main menu
		MAIN_MENU
	else
		echo -e "What time would you like your cut?"
		# set time to salon option 
		SET_SERVICE_TIME="$($PSQL "INSERT INTO appointments() WHERE phone='$PHONE_NUMBER'")"
	fi
}
COLOR() {
	echo $ASK_PHONE
	read PHONE_NUMBER
}
PERM() {
	echo $ASK_PHONE
	read PHONE_NUMBER
}
STYLE() {
	echo $ASK_PHONE
	read PHONE_NUMBER
}
TRIM() {
	echo $ASK_PHONE
	read PHONE_NUMBER
}

EXIT() {
	echo -e "\nThank you for stopping by"
}

MAIN_MENU

