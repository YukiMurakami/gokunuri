#!/bin/bash

allSetting=setting/allSetting.txt
result=log/results
setting=setting/gokunuri_recipe.txt

function game() {
	manager/gameManager \
		-a players/gokunuri -p "" -u "" -n "gokunuri1" -r 1 -s 100 \
		-a players/gokunuri -p "" -u "" -n "gokunuri2" -r 2 -s 98 \
		-a players/gokunuri -p "" -u "" -n "gokunuri3" -r 3 -s 80 \
		-a players/gokunuri -p "" -u "" -n "gokunuri4" -r 4 -s 70 \
		-a players/gokunuri -p "" -u "" -n "gokunuri5" -r 5 -s 60 \
		-a players/gokunuri -p "" -u "" -n "gokunuri6" -r 6 -s 20
}

function winner2result() {
	winner=$1
	if [ $winner -eq 0 ]; then
		echo "1 1 1 0 0 0"
	fi
	if [ $winner -eq 1 ]; then
		echo "0 0 0 1 1 1"
	fi
	if [ $winner -eq 2 ]; then
		echo "2 2 2 2 2 2"
	fi
}

echo "generate setting file"
rm $allSetting -f
for teamMerit in 1 2 3 4 5; do
	for myMerit in 1 2 3 4 5; do
		for huntMerit in 100000; do
			for hidingMerit in 1 5 10; do
				for cand in 1 2 3; do
					echo "$teamMerit $myMerit $huntMerit $hidingMerit $cand" >> $allSetting
				done
			done
		done
	done
done

echo "do test"
rm $result -f
line=$(( $(wc $allSetting -l | cut -d " " -f 1) - 1 ))
for i in $(seq 0 $line); do
	for j in $(seq 0 $line); do
		rm $setting -f
		if [ $i -ne $j ]; then
			continue
		fi
		for k in $(seq 1 2 3); do
			head $allSetting -n $i | tail -n 1 >> $setting
		done
		for k in $(seq 1 2 3); do
			head $allSetting -n $j | tail -n 1 >> $setting
		done
		for k in $(seq 1 5); do
			begin=$(wc $result -l)
			echo $begin $i $j
			game > res
			winner2result $(head -n 4 res | tail -n 1 | cut -d '"' -f 4) | sed -e "s/ /\n/g" > winner
			head -n 2 res | tail -n 1 | cut -d "[" -f 2 | cut -d "]" -f 1 | sed -e "s/ //g" -e "s/,/\n/g" > scores
			paste -d " " $setting winner scores >> $result
			while [ "$begin" = "$(wc $result -l)" ]; do
				sleep 0.1s
			done
		done
	done
done
