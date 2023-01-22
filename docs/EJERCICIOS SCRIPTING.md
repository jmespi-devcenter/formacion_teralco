SOLUCIONES EJERCICIOS SCRIPTING BASH


1. Hacer un  Script que solicita al usuario un número del 1 al 3 y le contesta indicando  “has elegido el número x" , y si el número no es del 1 al 3, que devuelva mensaje de número incorrecto. 
- Realizar una opción con el comando “if” y otra con el comando “case”


```shell
#!/usr/bin/env bash

declare -i num 

read -p "Introduce un número del 1 al 3: " num 
echo "Has elegido el numero $num"
if [[ $num -lt 1 || $num -gt 3 ]]; then
    echo "Incorrecto, el número elegido debe ser entre 1 y 3"
fi
```

```shell
#!/usr/bin/env bash

declare -i num

read -p "Introduce un número del 1 al 3: " num 
echo "Has elegido el numero $num"
case $num in 
    1 | 2 | 3) ;;
    *)
        echo "ERROR, el número elegido debe ser entre 1 y 3"
	  exit 1;;
esac
```

2. Script que comprueba si recibe como mínimo 2 parámetros. 
- Si recibe menos, muestra un mensaje de error y sale.

```shell
#!/usr/bin/env bash

if [[ $# -lt 2 ]]; then
    echo "ERROR: El script debe recibir al menos dos parámetros."
    exit 1
fi

```

3. Crea una carpeta llamada “EliminaTXT”, cuya ruta absoluta se pasará como argumento.
El script debe, mediante un bucle “for”, eliminar uno a uno cada fichero .txt (únicamente los ficheros .txt, nada más). 
- Una vez terminado debe mostrar un ls -l para comprobar el correcto funcionamiento y corroborar que no quedan ficheros .txt en el directorio. 
- Se dará por sentado que los ficheros no han sido nombrados con espacios en blanco.


```shell
#!/usr/bin/env bash

for i in `ls $1/*.txt`; do
    rm $i
    echo "HAS BORRADO $i" 
done
ls $1
```

4. Script con “case” que muestre 3 opciones: 1 Crear fichero, 2 Copiar fichero, 3 Borrar fichero, Salir. 
- Si seleccionas una opción correcta muestra un mensaje indicando que se ha ejecutado la acción correctamente, si no se ha seleccionado una opción válida se muestra mensaje de error.

```shell
#!/usr/bin/env bash

echo "1. Crear un fichero"
echo "2. Copiar fichero"
echo "3. Borrar fichero"
echo "4. Exit"

read -p "selecciona una de las opciones: " opc

case $opc in
    1)
        echo "fichero creado";;
    2)
        echo "fichero copiado";;
    3)
        echo "fichero borrado";;
    4)
        echo "has solicitado salir, adiós";;
    *)
        echo "esa opción no es correcta, adiós";;
esac

```

5. Crear un script que devuelva la suma de los elementos de un array (crear dentro una función que calcule esa suma)

```shell
#!/usr/bin/env bash

suma_array () {
    declare -i total
    sumandos=($1)

    for (( i = 0; i < ${#sumandos[*]}; i++ ))
    do
        let "total+=${sumandos[$i]}"
    done
    echo $total
}

if [[ $# -gt 0 ]]; then
    suma=`suma_array "${*?}"`
    echo "El resultado es: $suma"
else
    echo "ERROR: Se necesitan parámetros"
fi
```


