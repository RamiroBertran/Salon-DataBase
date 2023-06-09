#!/bin/bash
PSQL="psql -X --username=kvothe_snow --dbname=salon --tuples-only --no-align -c"
#TRUNCATE="$($PSQL "TRUNCATE customers, appointments;")"
#RESTART_CUSTOMERS_TABLE_SEQ="$($PSQL "ALTER SEQUENCE customers_customer_id_seq RESTART WITH 1;")"
#RESTART_APPOINTMENTS_TABLE_SEQ="$($PSQL "ALTER SEQUENCE appointments_appointment_id_seq RESTART WITH 1;")"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "\nWelcome to My Salon, how can I help you?"
MAIN_MENU() {
	if [[ $1 ]]
	then 
		echo -e "\n$1"
	fi
echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim\n6) exit"
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

SET_NEW_CLIENT_IF() {
if [[ $1 ]]
then
  echo -e "\n$1"
fi
echo -e "\nWhat's your phone number?"
read PHONE_NUMBER
if [[ -z $PHONE_NUMBER ]]
then 
SET_NEW_CLIENT_IF "You've not enter anything. Try again."
elif [[ ! "$PHONE_NUMBER" =~ ^[0-9]{3}-[0-9]{3}-[0-9]{3}$ ]]
then
SET_NEW_CLIENT_IF "The number format has to be 'xxx-xxx-xxx'" 
fi
CLIENT_IS_IN_DATABASE="$($PSQL "SELECT phone FROM appointments WHERE phone='$PHONE_NUMBER'")"
if [[ -z  $CLIENT_IS_IN_DATABASE ]]
then 
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read NAME
  # Set new client to customers
  INSERT_NAME_RESULT="$($PSQL "INSERT INTO customers(name) VALUES('$NAME')")"
  #Get customer ID
  CUSTOMER_ID="$($PSQL "SELECT customer_id FROM customers WHERE name='$NAME'")"
  # Set customer_id, service_id, and phone to appoitments
  INSERT_APPOINTMENT_RESULT="$($PSQL "INSERT INTO appointments(customer_id, service_id, phone, time) VALUES($CUSTOMER_ID, $MENU_OPTION, '$PHONE_NUMBER', null)")"
  # set time to appointmetn
  SET_TIME_TO_APPOINTMENT
else 
  UPDATE_SERVICE_ID="$($PSQL "UPDATE appointments SET service_id=$MENU_OPTION WHERE phone='$PHONE_NUMBER'")"
  SET_TIME_TO_APPOINTMENT
fi
}

SET_TIME_TO_APPOINTMENT() {
  if [[ $1 ]] 
  then 
    echo -e "\n$1"
  fi
  #Get service 
  SERVICE_TYPE="$($PSQL "SELECT name FROM services WHERE service_id=$MENU_OPTION")"
  #Get customer_id
  CUSTOMER_ID="$($PSQL "SELECT customer_id FROM appointments WHERE phone='$PHONE_NUMBER'")"
  #Set customer name into a variable
  USER_NAME="$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID")"
  echo -e "\nWhat time would you like to take your $SERVICE_TYPE, $USER_NAME?" 
  read TIME
  if [[ -z $TIME ]] 
  then

    SET_TIME_TO_APPOINTMENT "You've not enter anything. Try again."
  elif [[ ! $TIME =~ (^[0-9]{2}:[0-9]{2}$|^[0-9]{1,2}(am|pm)$) ]]  # si lo pongo mal es verdadero si lo pongo bien es falso 
  then
    SET_TIME_TO_APPOINTMENT  "The time format is xx:xx or xxam or xxpm"
  fi
    # if time is not empty, and it is equal to either option, then set the time in the appointment table
   SET_TIME="$($PSQL "UPDATE appointments SET time='$TIME' WHERE service_id=$MENU_OPTION")"
   echo -e "\nI have put you down for a $SERVICE_TYPE at $TIME, $USER_NAME"
}

CUT() {
  SET_NEW_CLIENT_IF
}
COLOR() {
  SET_NEW_CLIENT_IF
}
PERM() {
  SET_NEW_CLIENT_IF
}
STYLE() {
  SET_NEW_CLIENT_IF
}
TRIM() {
  SET_NEW_CLIENT_IF
}

EXIT() {
	echo -e "\nThank you for stopping by"
}

MAIN_MENU

