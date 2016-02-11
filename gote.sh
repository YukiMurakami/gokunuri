#!/bin/sh
manager/gameManager \
	-d dump \
	-l log \
	-a players/greedyPlayer -p "" -u "" -n "greedy1" -r 1 -s 100 \
	-a players/greedyPlayer -p "" -u "" -n "greedy2" -r 2 -s 98 \
	-a players/greedyPlayer -p "" -u "" -n "greedy3" -r 3 -s 80 \
	-a players/gokunuri -p "" -u "" -n "gokunuri4" -r 4 -s 70 \
	-a players/gokunuri -p "" -u "" -n "gokunuri5" -r 5 -s 60 \
	-a players/gokunuri  -p "" -u "" -n "gokunuri6" -r 6 -s 20
	# -a players/greedyPlayer -p "" -u "" -n "gokunuri4" -r 4 -s 70 \
	# -a players/greedyPlayer -p "" -u "" -n "gokunuri5" -r 5 -s 60 \
	# -a players/greedyPlayer -p "" -u "" -n "gokunuri6" -r 6 -s 20
