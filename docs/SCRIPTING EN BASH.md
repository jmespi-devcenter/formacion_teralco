# INTRODUCCIÓN
La primera línea de un script indica el shell que vamos a utilizar

```shell
#!/bin/bash
```

- Modo depuración

```shell
#!/bin/bash
#Entra al modo depuración
set -x

#Salir del modo depuración
set +x
```

- Cortar ejecución del fichero

```shell
#!/bin/bash
set -e
```

- Mostrar más información en la ejecución

```shell
#!/bin/bash
set -v
```

- Obtener errores de sintaxis

```shell
#!/bin/bash
set -n
```

## -EJECUCIÓN

Para ejecutar un scrip utilizaremos, debemos tener permisos de ejecución sobre el fichero.

```shell
./"nombre fichero"
```

Si no añadimos esta línea al principio del fichero podemos utilizar el comando.
Para este  ejemplo solo tenemos que tener permisos de lectura

```shell
bash "nombre del fichero"
```

## -ERRORES
**Importante** -> un script puede no detenerse ante un error, continua su ejecución de comandos.
Debemos controlar los errores y finalizar la ejecución del mismo si procede.

Si el último resultado de ejecución de un comando en un script el resultado obtenido de 

```shell
echo $?
2
```

Si la salida es exitosa el resultado será:
```shell
echo $?
1
```

# EXPRESIONES

Utilizaremos las expresiones para realizar comparaciones y determinar el flujo de ejecución en funcion del cumplimiento de estas expresiones.

 ## -COMPARADORES

- <= -> Menor que
- >= -> Mayor que
- == -> Igual
- != -> Distinto
- -a, && -> Se cumplan condición 1 y condición 2
- -o, || -> Se cumpla condición 1 ó condición 2
- =~ -> para compara con expresiones regulares
- -n -> verdadero si la variable no está vacía
- -z -> verdadero si la variable está vacía
- \[\[ $var1]] -> comprueba si la variable existe y contiene un valor que no sea vacío

## -COMPARADORES NUMÉRICOS

 - num1 **-eq** num2 -> Comprueba que los numeros son **iguales**
 - num1 **-ne** num2 -> Comprueba que los numeros son **distintos**
 - num1 **-gt** num2 -> Comprueba si num1 es **mayor** que num 2
 - num1 **-ge** num2 -> Comprueba si num 1 es **mayor o igual** que num 2
 - num1 **-lt** num2 -> Comprueba qi num1 es **menor** que num 2
 -  num1 **-le** num2 -> Comprueba si num 1 es **menor o igual** que num 2

## -COMPARADORES DE FICHEROS
- -e fichero -> Comrpueba si el **fichero existe**
- -f fichero -> Comprueba si el **fichero existe y además es un fichero**
- -d fichero -> Comprueba si el **fichero existe y ademas es un directorio**
- -r fichero -> Comprueba si el proceso (script) tiene permiso de **lectura** sobre el fichero
- -x  fichero-> Comprueba si el proceso (script) tiene permiso de **ejecución** sobre el fichero
- w fichero -> Comprueba si el proceso (script) tiene permiso de **escritura** sobre el fichero
- -s fichero -> Comprueba si el fichero **no es vacio** (tiene más de 0 bytes)
- **fich1 -nt fich2** -> Comprueba si fich1 se ha modificado más recientemente que fich2 (newer than)
- **fich1 -ot fich2** -> Comprueba si fich1 se ha modificado antes que fich2 (older than)

## -CARACTERES ESPECIALES
Con el carácter **\\**** escapamos el siguiente caracter (se trata como si fuera texto)
El texto siempre debería ir incluido entre comillas simples o dobles

Hay 3 carácteres que no se ignoran **' $ y /** por lo que hay que escaparlos manualmente

## -EJEMPLOS
```shell
echo "hoy es date"
? hoy es date
echo "hoy es $(date)"
? hoy es mié 18 ene 2023 12:46:45 CET
echo "hoy es \$(date)"
? hoy es $(date)
echo 'hoy es $(date)'
? hoy es $(date)

```

# VARIABLES
- Se pueden declarar variables con el comando **declare**

```shell
$ declare -i var
$ var="4+5"
 #var tendrá un valor de 9
printenv
```

-  Con la opción - se otorgan propiedas a las variables y con la opción + se le quitan. 
- Opciones de la función declare: #COMPLETAR
	- -i ->
	- 
- Las variables de sistema son en mayúsculas
```shell
echo $SHELL
echo $PATH
printenv
```
- Las variables creadas por los usuarios deberán ir en minúsculas y empezar por letras
	- deberán ser entendibles
	- Se crean de la siguiente manera
```shell
variable=valor
echo $variable
```

- Mostrar longitud de una variable

```shell
echo ${#variable}
5
```

- Eliminar variable

```shell
unset variable
```

- Variable de solo lectura (costante)
```shell
readonly variable=valor
```

- Exportar una variable
	- Solo para terminales hijo, muy util para exportar variables en llamadas a terminales en scripts

```shell
$export saludo = "Hola"
```

### -Uso de comas y contrabarras

- '  Lo que escribimos entre comillas simples es literal

```shell
echo 'mi nombre es $minombre'
mi nombre es $minombre
```

- " Interpreta variables por lo que si escribimos texto entre "" va a interpretar el valor de las variables

```shell
$echo "mi nombre es $minombre"
mi nombre es Jorge
```

- Sin comillas, la teoría es que funcione igual que al utilizar "

```shell
echo mi nombre es $minombre
mi nombre es Jorge
```

- *  al ejecutar con el comando _echo_ se interpreta como ls

```shell
echo *
0 1 2 3 4 5 6 7 8 9 error.log prueba2.sh prueba.sh test1.sh test2.sh
```

- \\ Se utiliza para "escapar comandos"

```shell
echo \*
*
```


# COMANDOS

### -ECHO
 - Visualiza comandos por pantalla
 ```shell
	 echo "Hola \n que tal"
	 # "Hola que tal"
 ```
 
- Con -e se leen los caracteres especiales

 ```shell
	 echo -e 'hola\n que tal'
	# hola
	# que tal
```

```shell
bootuser@bootcamp10:~/Documentos/Scripting$ batcat prueba

   1   │ mi nombre es Jorge
   2   │ mi nombre es $minombre
   3   │ mi nombre es Jorge
   4   │ mi nombre es Jorge y esto es un *
   5   │ mi nombre es Jorge y esto es un 0 1 2 3 4 5 6 7 8 9 error.log prueba prueba2.sh prueba.sh
       │  test1.sh test2.sh
   6   │ mi nombre es $minombre y esto es un *

#Obtenemos el nº de lineas de un fichero
numlineas=`wc -l prueba | cut -d ' ' -f 1`
6
```

### -PRINTF

Muestra datos por pantalla, ya sea texto, variables, etc

```shell
nombre=Jorge
edad=31
echo $nombre
Jorge
echo $nombre $edad
Jorge 31

#Printf con llamada a las variables
printf "Te llamas $nombre y tu edad es $edad\n"
Te llamas Jorge y tu edad es 31

#Printf especificando el tipo de dato y la llamada a las variables al final
printf "Te llamas %s y tu edad es %d\n" $nombre $edad
Te llamas Jorge y tu edad es 31
```

### -READ

Con este comando tambien se puede asignar valor a las variables

```shell
	read var
	hola que tal

	echo $var
	hola que tal

```

Se pueden asignar datos a variables para entradas de "formulario"

```shell
	read -p "Dime tu nombre: " nombre
	> Jorge
	
	echo $nombre
	Jorge
```

- -n indica el número máximo de caracteres que se puede escribir en la entrada
- -s ocultar lo que el usuario escribe
- -r deshabilita los caracteres de escape ( \n \t etc)
- -t tiempo en segundos (con decimales) que espera para recibir la entrada del valor

```shell
	# Lee solo 1 carácter y lo guarda en var(sin presionar entre)
	read -r -n 1 -s var 	
```

Se utiliza la variable $IFS para separar lo que se asigna a cada variable
- IFS es una variable definida en la función read por defecto

```shell
	#Usa : como separador, solo durante la ejecución del read
	IFS=":" read var1 var2 	
```

# ARGUMENTOS
Un argumento es un parámetro que se le pasa a una función o programa. Esto puede modificar la ejecución del mismo.

A bash por defecto se le pueden pasar 9 argumentos, desde $1 a $9. Si fuesen necesarios más se puede redefinir pero no es lo común.

EJEMPLO

```shell
./ejemplo.sh arg1 arg2 arg3....
```

- Valores por defecto
	- Con la expresión ${variable:-"valor por defecto"} podemos definir un valor por defecto en caso de que no se reciba dicho argumento

```shell
#suma los números que se introducen como argumento, si no se introduce argumento coge el valor 0 que es lo que hemos definido por defecto
suma=$((${1:-0}+${2:-0}+${3:-0}))
```


# CONDICIONALES

## -COMPARADORES
- - -> resta
- ! -> Negación
- <= -> Menor que
- >= -> Mayor que
- == -> Igual
- != -> Distinto
- && -> Se cumplan condición 1 y condición 2
- || -> Se cumpla condición 1 ó condición 2

## -IF
- Realiza una acción si se cumple una condición y sino ejecutamos otra
```shell
$ if [[ "CONDICION" ]]
then
		"ACCIONES SI SE CUMPLE LA CONDICIÓN"
elif [[ "CONDICION" ]]]
then
else
		"ACCIONES SI NO SE CUMPLE LA CONDICIÓN"
fi
```

EJEMPLOS

```shell
#!/bin/bash

if [ $# -eq 1 ]
then
	echo "hago mi script"
	echo "ejecuntando el script"
else
	echo "error, debes proporcionar un argumento"
fi
```

## -CASE
- En este condicional escogeremos cada una de las funciones en función del valor del argumento que reciba la función

```shell
$ case $var in 
	val1)
		funcion();;
	val2)
		funcion();;
	valn)
		funcion();;
	*)
		funcion por defecto();;	
esac
```

EJEMPLOS
```shell
#!/bin/bash
case $var in 
	val1)
		funcion();;
	val2)
		funcion();;
	valn)
		funcion();;
	*)
		funcion por defecto();;	
esac
```

# BUCLES

- Las estructuras de repetición tienen 2 comandos que fuerzan las salidas
	- Break -> fuerza salida inmediata
	- Continue -> pasa a la siguiente iteración
	- exit -> fuerza la salida de la ejecución
	- sleep x -> detiene el programa dura x segundos


## -FOR IN

```shell
items="1 2 3 4 5 6 7 8 9 10"

for i in $items
do 
	echo $item
done
```

- Las variables toma en cada iteración uno de los valores que hay en la lista, de forma ordenada
- Se puede emplear como lista la salida de una orden
- La variable del for va sin $ porque sobreescribimos el valor en cada iteración, no queremos mostrarlo
- La variable lista si que va con $ porque queremos leer el valor en cada iteración
- El separador por defecto será el espacio en blanco

SEPARADOR
 - Por defecto el separador por defecto es el " ", para modificar este sepador haremos uso de la variable $IFS
	 - **IFS** ="separador"
	 - **IFS**=$\'\n' ->(separador por salto de línea)
	 - **IFS**=$\'\t' -> (separador por tabulación)

EJEMPLOS


```shell
#!/bin/bash

#En este caso se trata la variable $items como una lista y se mostraría cada 1 de los elementos en cada iteración del bucle
items="1 2 3 4 5"

for item in $items
do
	echo $item
done
```

```shell
#!/bin/bash

#El * se corresponde a $(ls) 
for file in *
do 
	echo $file
done
```

```shell
#/bin/bash

#En este caso se trataria la cadena "1 2 3 4 Hola Adios" como un único elemento de la lista

for variable in "1 2 3 4 Hola Adios"
do 
	echo $variable
done
```

```shell
#/bin/bash

#Itera por cada uno de los argumentos que reciba el script
for var in $*
do 
	echo $var
done
```

```shell
#/bin/bash

#Cambiamos el delimitador a ":" para el bucle
IFS="."
for var in $*
do 
	echo $var
done
```

## -SEQ
- Seq genera una secuencia entre 2 valores dados
```shell
#genera una secuencia de x a y donde x ha de ser < que y
seq x y
```

EJEMPLOS

```shell
#genera una secuencia de x a y donde x ha de ser < que y
seq 1 5
1
2
3
4
5
```

```shell
#genera una secuencia de x a y con un incremento de z donde x ha de ser < que y
#seq x z y
seq 1 2 6
1
3
5
```

## -WHILE
- Bucle de repetición donde se han de gestionar manualmente la inicialización del iterador y el incremento

```shell
#!/bin/bash
#Declaramos iterado
x=1

while [[ $x -lt 10 ]]
do
	"EJECUCIÓN"
done
echo $x
```

EJEMPLOS

## -UNITL

- Misma función que while pero en vez de mientras que se cumpla la condición 

# EXPRESIONES ARITMETICAS

## -EXPR
Realiza operaciones matemáticas, tiene una complejidad alta
- Hay que escapar los caracteres especiales

EJEMPLOS

```shell
#Suma
$ expr 3 + 4
7

#Longitud de una variable
$ expr length "hola"
4

#Obtiene 2 caracteres a partir de la posición 3
expr substr "Extintor" 3 2
ti

#Da error porque hay que escapar el *
$ expr 3 * 4
expr: syntax error: unexpected argument «Descargas»

#Multiplicación escapando el *
$ expr 3 \* 4
12
```

## -LET
Comando más intuitivo que expr pero solo opera con números, no funciona con cadenas.
- Es aconsejable encerrar la expresión entre comillas para evitar problemas con los caracteres
- Se asigna el resultado devuelto a la variable automáticamente

EJEMPLOS

```shell
#Suma
$ let "n=5+10"
$ echo $n
15

#No es necesario utilizar el $ para las variables en el comando let, entiende que los caracteres son variables si existiese. Si la variable no existe coge el valor 0 por defecto
$ let "y=x+5"
$ echo $y
11

#Las operaciones matemáticas hacen let por defecto con el doble paréntesis
$ (( x = 2 + 3 )) -> let "x = 2 + 3"
$ (( x++ )) -> let "x = x + 1"

#Otros ejemplos de sintaxis
$ (( x = x + 3 ))

$ (( x = $x + 3 ))
```

# FUNCIONES #COMPLETAR 
- Elementos que agrupamos para reutilizarlas más de 1 vez
- Definición () indica que es función y las {} para el contenido.
- Le podemos enviar parámetros con $1, $2, $3. Si se le pasa un argumento esta función no va a poder acceder a los parámetros iniciarles del script

# ARRAYS #COMPLETAR 
- miarray

# STRING
 - con $(cadena:posicion:longitud) podemos extraer una subcadena de otra
	 - echo $(string:0) -> sin longitud, extrae una cadena entrea
- con $(cadena/buscar/reemplazar) podemos reemplazar la primera coincidencia de 'buscar' por 'reemplazar' y con $(cadena//buscar//reemplazar) reemplazaremos todas
	- echo $(string/abc/xyz) -> reemplaza abc por xyz en la primera coincidencia
	- echo $(string//abc//xyz) -> reemplaza abc por xyz en todas las coincidencias
- Borrar prefijo
	- $(cadena#subcadena) podemos borrar la coincidencia más corta de subcadena desde el principio
	- $(cadena##subcadena) podemos borrar la coincidencia más larga de subcadena desde el principio
- Borrar sufijo -> igual que el prefijo pero utilizando % en vez de # 
	- $(cadena%subcadena) podemos borrar la coincidencia más corta de subcadena desde el final
	- $(cadena%\%subcadena) podemos borrar la coincidencia más larga de subcadena desde el final


# EJEMPLOS DE SCRIPT
- Machea el nombre introducido con el nuestro y te obliga a pulsar cualquier tecla para continuar

```shell
   1   │ #!/bin/bash
   2   │ #set -n
   3   │ 
   4   │ usuario="Jorge"
   5   │ read -p "Introduce tu nombre: " nombre
   6   │ if  [[ $nombre = $usuario ]]; then
   7   │     echo "Bienvenido $nombre"
   8   │     read -p "Press any key to continue..." -r -n 1 -s var
   9   │ else
  10   │     echo "Tu no eres $usuario, adios"
  11   │     read -e -p "Press any key to continue..." -r -n 1 -s var
  12   │ fi
  13   │ 
```

- Obtener rutas relativas

```shell
#Si coincide, elimina el valor de la variable HOME desde el principio al valor de la variable PWD

echo ${PWD}
/home/bootuser/Documentos/Scripting
echo ${HOME}
/home/bootuser

echo ${PWD#$HOME}
/Documentos/Scripting
```


# CRONTAB
PONER EJEMPLO Y WEB DE CRONTAB GENERATOR

//ACONSEJABLE PONER EN EL CRONTAB EN EQUIPOS ANTIGUOS
ntpdate -s hora.roa.es