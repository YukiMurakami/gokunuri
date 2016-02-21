#!/bin/bash

set -eu

result=log/results
setting=setting/gokunuri.recipe
settingAll=$setting.all
settingInit=$setting.init

initParam="1 1 1 1 1 1 1 1 1"
weapon=0
amplitude=1.0
ratio=0.90
childNum=5
matchCount=20
maxIter=50
minAmplitude=0.2

mkdir -p setting log

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

function search_param() {
	#rm -f $setting
	if [ -e $setting ]; then
		echo "read $setting line 1-3 as initial state"
	else
		echo "use '$initParam' as initial state"
		for k in $(seq 3); do
			echo $initParam >> $setting
		done
	fi
	cp $setting $settingInit

	if [ $# -eq 1 ]; then
		weapon=$1
	fi
	echo "search weapon[$weapon]"

	echo "initial parameter: $settingInit, child number:$childNum, match count: $matchCount"
	rm -f $result
	touch $result
	for iter in $(seq $maxIter); do
		echo "iteration: $iter/$maxIter ( amplitude: $amplitude )"
		python generateSetting.py $settingAll $settingInit $result $childNum $matchCount $weapon $amplitude $minAmplitude
		if [ $(wc -l $settingAll | cut -d " " -f 1) -eq 6 ]; then # end search
			break
		fi

		for child in $(seq $(($childNum*2))); do # sente / gote
			head -n $(($child*6)) $settingAll | tail -n 6 > $setting
			for k in $(seq $matchCount); do
				echo -e "$child/$(($childNum*2)) $k/$matchCount\r\c"
				begin_line=$(wc $result -l)
				game > res
				head -n 2 res | tail -n 1 | cut -d "[" -f 2 | cut -d "]" -f 1 | sed -e "s/ //g" -e "s/,/\n/g" > scores
				winner2result $(head -n 4 res | tail -n 1 | cut -d '"' -f 4) | sed -e "s/ /\n/g" > winner
				paste -d " " $setting scores winner >> $result
				while [ "$begin_line" = "$(wc $result -l)" ]; do
					sleep 0.05s
				done
			done
		done
		amplitude=$( echo "scale=4;$amplitude*$ratio" | bc )
	done

	echo "training end"
	cat $settingAll > $setting

	# remove tmp files
	rm -f winner scores $settingInit $settingAll SamuraiLog*
}

beginAmplitude=$amplitude
for i in $(seq 10); do
	echo "=== epoch $i ==="
	for weapon in $(seq 0 2); do
		amplitude=$beginAmplitude
		search_param $weapon
	done
	beginAmplitude=$( echo "scale=4;$beginAmplitude*$ratio" | bc )
done
