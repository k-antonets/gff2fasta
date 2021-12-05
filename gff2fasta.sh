#!/bin/bash

path=$1
if [ "$path" == '' ]; then
	path='.'
fi

for f in $(ls $path/*.gff); do
	ids=$(sed '/##FASTA/Q' $f | awk -F$'\t' '{print $1}' | sort | uniq | sed -r 's/(.+)/(>\1)/g' | tr '\n' '|' | sed 's/|$/\n/')
	n="$(basename $f '.gff').fna"
	sed -n '/##FASTA/,$p' $f | parallel --progress -kN1 --block 20M --recstart '>' --pipe "sed -r -n '/$ids/,\$p'" > $n
done
