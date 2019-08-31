#!/bin/bash

#i. Kill all processes/zombie processes of service called “gunicorn” in a single command.

#echo "kill -9 $(echo $(ps aux | grep 'Z' | grep gunicorn |  awk '{ print $2 }'))"


#ii. MySQL shell command to show the unique IPs from where MySQL connections are being made to the Database.

https://www.cyberciti.biz/faq/howto-show-mysql-open-database-connections-on-linux-unix/


#iii. Bash command to get value of version number of 3 decimal points (first occurrence) from a file containing the JSON:

JSON_DATA='"{

"name": "abc",

"version": "1.0",

"version": "1.0.57",

"description": "Testing",

"main": "src/server/index.js",

"version": "1.1"

}"'

cat file.json| grep -Po '"version":.*?[^\\]",'

echo ${JSON_DATA} | grep -Po '"vetsion\":\"(\.[a-zA-Z.@]+)\",'