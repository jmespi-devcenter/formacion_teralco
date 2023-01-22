#!/bin/bash

if [ $# -eq 1 ]
then
	if ! [[ -d $1 || -f $1 ]]
	then
		echo "debes pasar un argumento que sea un archivo o directorio"
	else
		echo "correcto"
	fi
else
	echo "error, es necesario un argumento"
fi

