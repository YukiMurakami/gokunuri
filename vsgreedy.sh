#!/bin/bash

matchcount=10

function sente() {
	manager/gameManager \
		-a players/gokunuri -p "" -u "" -n "gokunuri1" -r 1 -s 100 \
		-a players/gokunuri -p "" -u "" -n "gokunuri2" -r 2 -s 98 \
		-a players/gokunuri -p "" -u "" -n "gokunuri3" -r 3 -s 80 \
		-a players/greedyPlayer -p "" -u "" -n "greedy4" -r 4 -s 70 \
		-a players/greedyPlayer -p "" -u "" -n "greedy5" -r 5 -s 60 \
		-a players/greedyPlayer -p "" -u "" -n "greedy6" -r 6 -s 20
}

function gote() {
	manager/gameManager \
		-a players/greedyPlayer -p "" -u "" -n "greedy1" -r 1 -s 100 \
		-a players/greedyPlayer -p "" -u "" -n "greedy2" -r 2 -s 98 \
		-a players/greedyPlayer -p "" -u "" -n "greedy3" -r 3 -s 80 \
		-a players/gokunuri -p "" -u "" -n "gokunuri4" -r 4 -s 70 \
		-a players/gokunuri -p "" -u "" -n "gokunuri5" -r 5 -s 60 \
		-a players/gokunuri -p "" -u "" -n "gokunuri6" -r 6 -s 20
}

if [ $# -eq 1 ]; then
	matchcount=$1
fi

echo "極塗 vs greedy"
wincount=0
for k in $(seq $matchcount); do
#	sente | head -n 2 | tail -n 1 | cut -d "[" -f 2 | cut -d "]" -f 1
	winner=$(sente | head -n 4 | tail -n 1 | cut -d '"' -f 4)
	if [ $winner -eq 0 ]; then
		wincount=$(( $wincount + 1 ))
	fi
done
winrate=$(( 100 * $wincount / $matchcount ))
echo "$wincount / $matchcount ( $winrate %)"
echo ""

echo "greedy vs 極塗"
wincount=0
for k in $(seq $matchcount); do
	winner=$(gote | head -n 4 | tail -n 1 | cut -d '"' -f 4)
	if [ $winner -eq 1 ]; then
		wincount=$(( $wincount + 1 ))
	fi
done
winrate=$(( 100 * $wincount / $matchcount ))
echo "$wincount / $matchcount ( $winrate %)"
