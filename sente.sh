#!/bin/sh
manager/gameManager \
	-d dump \
	-l log \
	-a players/gokunuri -p "" -u "" -n "gokunuri1" -r 1 -s 100 \
	-a players/gokunuri -p "" -u "" -n "gokunuri2" -r 2 -s 98 \
	-a players/gokunuri -p "" -u "" -n "gokunuri3" -r 3 -s 80 \
	-a players/greedyPlayer -p "" -u "" -n "greedy4" -r 4 -s 70 \
	-a players/greedyPlayer -p "" -u "" -n "greedy5" -r 5 -s 60 \
	-a players/greedyPlayer -p "" -u "" -n "greedy6" -r 6 -s 20
