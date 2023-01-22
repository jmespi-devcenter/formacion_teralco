#!/bin/bash

fichero=$1

if  [[ -e $fichero ]]
then
	echo "$fichero existe, pero no sé si es un fichero o un directorio"
fi

