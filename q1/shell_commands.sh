#!/bin/bash

#i. Kill all processes/zombie processes of service called “gunicorn” in a single command.

#echo "kill -9 $(echo $(ps aux | grep 'Z' | grep gunicorn |  awk '{ print $2 }'))"


#ii. MySQL shell command to show the unique IPs from where MySQL connections are being made to the Database.

https://www.cyberciti.biz/faq/howto-show-mysql-open-database-connections-on-linux-unix/


#iii. Bash command to get value of version number of 3 decimal points (first occurrence) from a file containing the JSON:

cat file.json| grep -Po '"version":.*?[^\\]",'

echo ${JSON_DATA} | grep -Po '"vetsion\":\"(\.[a-zA-Z.@]+)\",'

#iv.


NUMBERS="0.0238063905753, 0.0308368914424,0.0230014918637, 0.0274232220275, 0.0184563749986"

cat iv.txt

awk '{ total += $1; count++ } END { printf ("%2.2f", total/count) }' iv.txt