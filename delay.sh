#!/bin/bash

# Getting the startup minutes and seconds from the system
START_MIN=$(uptime -s | cut -d ":" -f 2)
START_SEC=$(uptime -s | cut -d ":" -f 3)

# Calculate the number of seconds between the startup and the nearest 10th minute.
DELAY=$(echo $START_MIN%10*60+$START_SEC | bc)

# Wait <DELAY> number of seconds to execute the monitoring script
sleep $DELAY
