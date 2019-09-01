#!/bin/bash

#i. Kill all processes/zombie processes of service called “gunicorn” in a single command.

echo "kill -9 $(echo $(ps aux | grep 'Z' | grep gunicorn |  awk '{ print $2 }'))"


#ii. MySQL shell command to show the unique IPs from where MySQL connections are being made to the Database.


mysql -u root -BNe "select host,count(host) from processlist;" information_schema


#iii. Bash command to get value of version number of 3 decimal points (first occurrence) from a file containing the JSON:

cat file.json| grep -Po '"version":.*?[^\\.]{2}",'

#iv. Bash command to add these numbers from a file and find average upto 2 decimal points:

cat iv.txt

awk '{ total += $1; count++ } END { printf ("%2.2f", total/count) }' iv.txt