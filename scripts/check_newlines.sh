#!/bin/bash

for path in $(find _includes/ -type f -print)
do
	if [[ $1 = "1" || `grep -l "\{\% capture __minify \%\}" $path` ]]; then
		if [[ `tail -c 1 $path` ]]; then
			echo -n "       "
		else
			echo -n "DIRTY: "
		fi
		echo $path
	fi
done
