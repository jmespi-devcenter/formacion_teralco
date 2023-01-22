#!/bin/bash
if [[ "$1" = "-h" || "$1" = "--help" ]]
then
	echo "debes pasar un argumento que sea un fichero"
elif [[ $# -eq 1 && -f $1 ]]
then
	cat $1
else
	echo "error, es necesario un argumento fichero"
fi
