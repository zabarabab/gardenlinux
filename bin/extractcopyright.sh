#!/bin/bash

#TODO https://github.com/daald/dpkg-licenses.git


rm -rf lic
mkdir -p lic

plist=( $(dpkg-query -f '${Package} ${Version}\n' -W) )
for ((i=0; i<${#plist[@]};i+=2)); do
	cfile="$(dpkg -L ${plist[i]} | grep /usr/share/doc | grep copyright)"
	ffile="${plist[i]}_$(echo "${plist[i+1]}" | sed 's/^[0-9]*://;s/-.*$//;s/[\.\+]*\(dfsg\|nmu\)[0-9]*$//')"
	if [ -e "$cfile" ]; then
		cp $cfile lic/$ffile
	else
		touch lic/$ffile
	fi
	echo -n "."
done

fdupes -1 lic | while read line; do 
	master=""; 
	for file in ${line[*]}; do 
		if [ "x${master}" == "x" ]; then 
			master=$file; 
		else
			rm -f ${file}
			ln -sf "$(basename ${master})" "${file}"
		fi
	done
done
