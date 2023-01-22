#!bin/bash

if [[ $1 = -h || $1 = "--help" ]]
then
	echo "Se muestra la ayuda"
elif [[ $# -eq 1 || -f $1 ]]
then
	if [[ $1 ]]
	then
		cat $1
	else
		echo "el argumento 1 no tiene valor"
	fi
else
	echo "error"
fi
