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

## -Ejecución

- Para ejecutar un scrip utilizaremos, debemos tener permisos de ejecución sobre el fichero.

```shell
./"nombre fichero"
```

- Si no añadimos esta línea al principio del fichero podemos utilizar el comando.
Para este  ejemplo solo tenemos que tener permisos de lectura

```shell
bash "nombre del fichero"
```

## - Errores
- **Importante** -> un script puede no detenerse ante un error, continua su ejecución de comandos.
- Debemos controlar los errores y finalizar la ejecución del mismo si procede.
- Si el resultado obtenido de la ejecución de un comando en un script es distinto de 0, significa ese comando no ha sido exitoso.

```shell
echo $?
2
```

- Si la salida es exitosa el resultado será:

```shell
echo $?
0
```

# EXPRESIONES

Utilizaremos las expresiones para realizar comparaciones y determinar el flujo de ejecución en funcion del cumplimiento de estas expresiones.

 ## - Comparadores

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

## - Comparadores numéricos

 - num1 **-eq** num2 -> Comprueba que los numeros son **iguales**
 - num1 **-ne** num2 -> Comprueba que los numeros son **distintos**
 - num1 **-gt** num2 -> Comprueba si num1 es **mayor** que num 2
 - num1 **-ge** num2 -> Comprueba si num 1 es **mayor o igual** que num 2
 - num1 **-lt** num2 -> Comprueba qi num1 es **menor** que num 2
 -  num1 **-le** num2 -> Comprueba si num 1 es **menor o igual** que num 2

## - Comparadores para ficheros
- -e fichero -> Comrpueba si el **fichero existe**
- -f fichero -> Comprueba si el **fichero existe y además es un fichero**
- -d fichero -> Comprueba si el **fichero existe y ademas es un directorio**
- -r fichero -> Comprueba si el proceso (script) tiene permiso de **lectura** sobre el fichero
- -x  fichero-> Comprueba si el proceso (script) tiene permiso de **ejecución** sobre el fichero
- w fichero -> Comprueba si el proceso (script) tiene permiso de **escritura** sobre el fichero
- -s fichero -> Comprueba si el fichero **no es vacio** (tiene más de 0 bytes)
- **fich1 -nt fich2** -> Comprueba si fich1 se ha modificado más recientemente que fich2 (newer than)
- **fich1 -ot fich2** -> Comprueba si fich1 se ha modificado antes que fich2 (older than)

## - Caracteres Especiales
Con el carácter **\\**** escapamos el siguiente caracter (se trata como si fuera texto)
El texto siempre debería ir incluido entre comillas simples o dobles

Hay 3 carácteres que no se ignoran **' $ y /** por lo que hay que escaparlos manualmente

## - Eejmplos

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
	- -i ->La variable solo podrá almacenar enteros
	- +1 -> Borra la restricción de enteros
	- -r -> Declaración de una constante, solo lectura
	- -a -> Fuerza a la variable a ser un array
	- -A -> Array asociativo, solo soportado a partir de la versión 4 de BASH
	- -p -> Muestra el contenido de la variable y sus atributos
	- -u -> Convierte la cadena asignada a la variable a mayúsculas automáticamente

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
$export saludo="Hola"
```

### -Uso de comas y contrabarras

- '  Lo que escribimos entre comillas simples es literal

```shell
echo 'mi nombre es $minombre'
mi nombre es $minombre
```

- " Interpreta variables por lo que si escribimos texto entre " va a interpretar el valor de las variables

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

## - Ifs

- IFS es una variable de sistema que está definida prácticamente en todas las funciones que especifica el delimitador por defecto para cada una de ellas.
- Podemos cambiar el valor de esta en caso que nuestro delimitador para un caso determinado cambiase, es recomendable almacenar el valor actual de la variable y devolverlo a su estado una vez se haya ejecutado nuestra función en concreto

```shell
# Recomendable hacerlo solo temporalmente
OLD_IFS=$IFS - cambiar el valor - usarlo - dejarlo como estaba - IFS=$OLD_IFS
```

# COMANDOS

## - Echo

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

## - Pintf

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

## - Read

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

## - Seq

- Seq genera una secuencia entre 2 valores dados

```shell
#genera una secuencia de x a y donde x ha de ser < que y
seq x y
```

- Ejemplos

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

# ARGUMENTOS

- Un argumento es un parámetro que se le pasa a una función o programa. Esto puede modificar la ejecución del mismo.

- A bash por defecto se le pueden pasar 9 argumentos, desde $1 a $9. Si fuesen necesarios más se puede redefinir pero no es lo común.

EJEMPLO

```shell
./ejemplo.sh arg1 arg2 arg3....
```

- Con el parámero $"numero" recogemos el valor de cada uno de los argumentos dentro del scrip.

```shell
./ejemplo.sh arg1 arg2 arg3....

$ $1 -> tendría el valor de arg1
$ $2 -> tendría el valor de arg2
$ $3 -> tendría el valor de arg3
```

- Valores por defecto
	- Con la expresión ${variable:-"valor por defecto"} podemos definir un valor por defecto en caso de que no se reciba dicho argumento

```shell
#suma los números que se introducen como argumento, si no se introduce argumento coge el valor 0 que es lo que hemos definido por defecto
suma=$((${1:-0}+${2:-0}+${3:-0}))
```


# CONDICIONALES

## - Comparadores
- - -> resta
- ! -> Negación
- <= -> Menor que
- >= -> Mayor que
- == -> Igual
- != -> Distinto
- && -> Se cumplan condición 1 y condición 2
- || -> Se cumpla condición 1 ó condición 2

## - If

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

- Ejemplo

```shell
#!/bin/bash
# Siempre dejar espacio en blanco en los corchetes de la condición
if [ $# -eq 1 ]
then
	echo "hago mi script"
	echo "ejecuntando el script"
else
	echo "error, debes proporcionar un argumento"
fi
```

## - Case
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

- Ejemplo

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


## - For in

```shell
items="1 2 3 4 5 6 7 8 9 10"

for item in $items
do 
	echo $item
done
```

- Las variables toma en cada iteración uno de los valores que hay en la lista, de forma ordenada
- Se puede emplear como lista la salida de una orden
- La variable del for va sin $ porque sobreescribimos el valor en cada iteración, no queremos mostrarlo
- La variable lista si que va con $ porque queremos leer el valor en cada iteración
- El separador por defecto será el espacio en blanco

- SEPARADOR
	 - Por defecto el separador por defecto es el " ", para modificar este sepador haremos uso de la variable $IFS
		 - **IFS** ="separador"
		 - **IFS**=$\'\n' ->(separador por salto de línea)
		 - **IFS**=$\'\t' -> (separador por tabulación)

- Ejemplos

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

## - For
- Las estructuras for son adecuadas siempre que sepamos el número de repeticiones necesarias en el bucle.

```shell
#/bin/bash

#En este caso se trataria la cadena "1 2 3 4 Hola Adios" como un único elemento de la lista

for ((x=1;x<=$lineas;x++))
do
	echo $x
	linea=`head -n $x nombres.txt | tail -n 1`
	nombre=`echo $linea | cut -d ' ' -f 1`
	# adduser $nombre
	echo "$nombre añadido como usuario"
done
```

## - While
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

- Ejemplo

```shell
#!/bin/bash
x=1
while [ $x -lt 10 ]
do
	echo $x
	if [ $x -eq 4 ]
	then
		echo “ahora x=4”
	fi
	echo "voy a incrementar x"
	let x=$x+1
done
echo $x
```

- Podemos leer contenido de un archivo con el comando **<** utilizando los operadores de los ficheros

```shell
while read -r
do
	printf "%s\n" "$REPLY"
done < nombres.txt
```

## -Until

- Funcionamiento opuesto al de la función while
- Until ejecuta las instrucciones mientras la expresión es falsa y hasta que sea verdadera.

```shell
#!/bin/bash
x=1
until [ $x -gte 10 ] do # Se ejecuta, mientras no se cumpla la condición
	echo $x
	if [ $x -eq 4 ]
	then
		echo “ahora x=4”
	fi
	echo "voy a incrementar x"
	let x=$x+1
done
echo $x
```

# EXPRESIONES ARITMETICAS

## - Expr

- Realiza operaciones matemáticas, tiene una complejidad alta
- Hay que escapar los caracteres especiales

EJEMPLOS

```shell
#Suma
$ expr 3 + 4
7

# Longitud de una variable
$ expr length "hola"
4

# Obtiene 2 caracteres a partir de la posición 3
expr substr "Extintor" 3 2
ti

# Da error porque hay que escapar el *
$ expr 3 * 4
expr: syntax error: unexpected argument «Descargas»

# Multiplicación escapando el *
$ expr 3 \* 4
12

# Asignar operación a variable
$ var=`expr 3+4`
$ echo $var
$ 7
```

## - Let

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

# FUNCIONES 

- Elementos que agrupamos para reutilizarlas más de 1 vez
- Definición () indica que es función y las {} para el contenido.
- Le podemos enviar parámetros con $1, $2, $3. Si se le pasa un argumento esta función no va a poder acceder a los parámetros iniciarles del script

- Ejemplo

```shell
#!/bin/bash
# Aquí sólo estamos definiendo la función,
# no se ejecutará hasta que se la llame
funcion () {
	echo "Soy una función"
}
echo "Vamos a llamar a la función..."
funcion
```

- Conceptos:
	- El código de las funciones se pone al principio, antes de los comandos del script.
	- Normalmente se le da un nombre representativo de lo que hace.
	- Igual que un script puede recibir parámetros y se accede a ellos de forma idéntica $1, $2, $3, $* para la lista de parámetros, $# para el número de parámetros, etc.
	- La función tendrá acceso a los parámetros que le pasemos a ella directamente y no tendrá acceso a los parámetros que se le hayan pasado al programa principal.
	- Las funciones tienen una instrucción return similar al exit en el script, sale de la función devolviendo un valor entre 0 y 255.
	- Cuando la función termina se accede al valor que ha devuelto mediante la variable $?

- Ejemplo

```shell
#!/bin/bash
declare -r CORRECTO=0
declare -r ERROR=1

# Esta función comprueba si un archivo existe.Si existe devuelve 0->Verdadero, y si no 1->Falso
existe () {
if [[ -e $1 ]] 
then
	return $CORRECTO
else
	return $ERROR
fi
}
existe "archivo1.txt"

# Comprobamos el valor devuelto por la función
if [[ $? -eq $CORRECTO ]]
then
	echo "El archivo existe."
else
	echo "El archivo NO existe."
fi
```

- Las funciones tienen una instrucción return similar al exit en el script, sale de la función devolviendo un valor entre 0 y 255.
- Si lo último que ejecuta la función es un comando, y la salida de la función va a depender de si el comando falla o no, podríamos ahorrarnos la instrucción return, ya que la salida de ese comando se guardará en la variable global $? igualmente.

- Ejemplos

```shell
#!/bin/bash
# Función que crea un fichero
crear_fichero () {
	touch $fichero
}
read -p "Dime nombre de fichero: " fichero
if crear_fichero
then
	echo "Fichero $fichero creado";
exit 0;
else
	echo "Error en función crear_fichero";
exit 1;
fi
```

```shell
#!/bin/bash
# Función que crea un fichero
crear_fichero () {
	touch $fichero
}
read -p "Dime nombre de fichero: " fichero
if crear_fichero
then
	echo "Fichero $fichero creado";
	exit 0;
else
	echo "Error en función crear_fichero";
	exit 1;
fi
```

- Por defecto todas las variables que usemos en una función son globales. Eso quiere decir que cuando la función termine seguirán existiendo en el script.
- Para indicar que una variable es local a la función, pondremos la palabra local o declare delante de la misma la primera vez que le demos valor. De esta forma la variable dejará de existir cuando acabe la función.

```shell
#!/bin/bash
suma () {
	local num1=$1
	declare num2=$2
	let "resultado = $num1+$num2"
}
suma 4 6
# num1 y num2 no existen fuera de la función al ser locales
# así que no los mostrará por pantalla. Resultado sin embargo
# no ha sido definida como local, así que estará accesible desde fuera.
echo "$num1 + $num2 = $resultado"
```


# ARRAYS 

- Un vector o array es una variable que en lugar de contener un solo valor, contiene varios. Se define igual que una variable normal, pero encerrando los valores entre paréntesis y separados por espacios.

```shell
miarray=(a b c d) (sin espacios en el igual)
```

- Los índices del array van desde 0 hasta el número de valores-1. En este caso de 0 a 3
- Para acceder a los elementos del array usaremos la siguiente notación:
	- miarray[0] -> “a”
	- miarray[2] -> “c”
	- ${miarray[*]} -> devuelve todos los valores que contiene
	- ${miarray[@]} -> devuelve todos los valores que contiene
	- ${#miarray[*]} -> devuelve el número de elementos que contiene
	- ${#miarray[@]} -> devuelve el número de elementos que contiene
	- ${!miarray[@]} -> devuelve los índices del array

- Podemos modificar o añadir elementos mediante el operador [ ]. p.e miarray[15]=”test 1”
- Para eliminar un elemento usaremos unset nombre_array[posicion_a_eliminar]
	- p.e unset miarray[1]
- Al eliminar, no desaparecen las posiciones, simplemente quedan vacías.

- Podemos llenar el array con la salida de un comando, los espacios y saltos de línea actuarán como separadores de elementos:

```shell
array=($(cat /etc/passwd | cut -d ':' -f 1))
```

- En caso de tener un salto de línea como separador, podemos recorrerlo haciendo uso de IFS, como vimos anteriormente.

```shell
#!/bin/bash
IFS=$'\n' # Necesario el símbolo $, de otro modo lo interpreta de forma literal
a=($(cat /etc/passwd | cut -d ':' -f1))
echo "${a[*]}"
```

- Ejemplos

```shell
#!/bin/bash
vector=( a b Cambiado d )
echo "Primer elemento: ${vector[0]}"
echo "Segundo elemento: ${vector[1]}"
echo "Tercer elemento: ${vector[2]}"
echo "Ultimo elemento: ${vector[3]}"
echo "Elemento no existente: ${vector[5]}“
```

```shell
#!/bin/bash
ficheros=( `ls` )
echo ${ficheros[*]}
echo “Hay ${#ficheros[*]} ficheros
```

```shell
#!/bin/bash
vector=( uno dos tres cuatro cinco seis )
for valor in ${vector[@]}
do
	echo "$valor "
done
for i in ${!vector[@]}
do
	echo "${vector[$i]}"
done
```

```shell
#!/bin/bash
vector=( uno dos tres cuatro cinco seis )
# De esta manera debemos saber que hay 6 elementos
for (( i = 0; i < 6; i++ ))
do
	echo "Elemento ${i}: ${vector[$i]} "
done
# Aquí no hace falta saber cuántos elementos hay
for (( i = 0; i < ${#vector[*]}; i++ ))
do
	echo "Elemento ${i}: ${vector[$i]} "
done
```



# STRING

- Manipulación de strings
	 - Extraer subcadena
		 - con $(cadena:posicion:longitud) podemos extraer una subcadena de otra
		 - echo $(string:0) -> sin longitud, extrae una cadena entrea
	-  Reemplazar subcadena
		- con $(cadena/buscar/reemplazar) podemos reemplazar la primera coincidencia de 'buscar' por 'reemplazar' y con $(cadena//buscar//reemplazar) reemplazaremos todas
		- echo $(string/abc/xyz) -> reemplaza abc por xyz en la primera coincidencia
		- echo $(string//abc//xyz) -> reemplaza abc por xyz en todas las coincidencias
	- Borrar prefijo
		- $(cadena#subcadena) podemos borrar la coincidencia más corta de subcadena desde el principio
		- $(cadena##subcadena) podemos borrar la coincidencia más larga de subcadena desde el principio
	- Borrar sufijo -> igual que el prefijo pero utilizando % en vez de # 
		- $(cadena%subcadena) podemos borrar la coincidencia más corta de subcadena desde el final
		- $(cadena%\%subcadena) podemos borrar la coincidencia más larga de subcadena desde el final

- Ejemplos

```shell
# Extraer la ruta del archivo
# borra desde la última barra hasta el final (*)
echo”${myfile%/*}” /home/marina/scripts/0_Teoria_ejemplos
```

```shell
# Extraer el nombre del archivo
# borra la cadena más larga desde el principio hasta /
echo "${myfile##*/}” prueba.txt
```

```shell
# Extraer el nombre sin la extensión
filename=“${myfile##*/}” prueba.txt
echo ${filename%.*} prueba
```

```shell
# Obtén la extensión del archivo
echo ${myfile##*.}
```

# CRONTAB

- Herramienta del sistema para ejecutar tareas automáticamente
- Para ver las tareas que hay configuradas utilizaremos el comando **crontab -l**
- Para modificar las tareas utilizaremos el comando **crontab -e**
- A continuación se muestra una imagen donde se explica el formato que se tiene que utilizar

![[Pasted image 20230122195349.png]]

- Ejemplos

![[Pasted image 20230122195520.png]]

- Existen herramientas para generarlos automáticamente.
[Generador Cron]https://crontab-generator.org/
![[Pasted image 20230122195820.png]]

# COMANDOS ÚTILES

## - Bc

- Consiste en una calculadora que facilita algunas tareas como el cálculo con decimales:
	- Script que calcula un promedio de 3 números y devuelve el resultado con 2 decimales:

```shell
#!/bin/bash
echo “scale=2; ($1+$2+$3)/3” | bc
```

	- Script que calcula la raíz cuadrada de un número con 20 decimales:

```shell
#!/bin/bash
squareroot=$(echo“scale=20; sqrt($1)”|bc)
echo $squareroot
```



## - Cut
 - Se emplea para extraer segmentos de líneas de texto de un fichero de texto o de la entrada estándar.
- Los parámetros que admite son:
	- -c rango: obtiene el rango indicado de caracteres sueltos
	- -f rango: obtiene el rango indicado de campos separados por el delimitador -d
	- -d “delimitador“
- Ejemplos:

```shell
#!/bin/bash
# Obtiene los 5 primeros caracteres de cada línea de texto del fichero.
cut -c1-5 /etc/passwd
```

```shell
#!/bin/bash
# Obtiene los textos de las columnas 1 y 3 de cada línea del texto de entrada, tomando como separador de columna el carácter ':’. La salida serán los usuarios y sus identificadores
cut -d ':' -f1,3 /etc/passwd
```

## - Tr

- Elimina o reemplaza caracteres de una cadena de entrada con las opciones siguientes:
	- -d cadena1: elimina las ocurrencias de cadena1 en el texto de entrada
	- -s cadena1 cadena2: sustituye las ocurrencias de la cadena1 por la cadena2.

Si hubiera varias cadena1 seguidas, sólo sustituye 1.

- Ejemplo:

```shell
#!/bin/bash
# Elimina los espacios en blanco
ls -l | tr -d " "
```

```shell
#!/bin/bash
# Muestra por pantalla el resultado del comando ls -l, pero cambiando todas las letras por mayúsculas
ls -l | tr -s "[az]" "[AZ]"
```

```shell
#!/bin/bash
# obtiene el tamaño de los elementos que contiene tu directorio empleando ls
ls -l | tr -s ‘ ’ | cut -d ‘ ’-f5
```

## - Seq y {}

- Comando seq y rango numérico {} nos permiten crear secuencias:
	- seq 1 9 → Genera los números del 1 al 9
	- seq 1 2 9 → Igual, pero de 2 en 2 (números impares sólo).
	- seq 0.1 0.1 1 → Desde 0.1 a 1 incrementando en 0.1 cada vez.
	- seq -s '-' 1 9 → Utiliza el carácter '-' para separar los números (por defecto → \n)
	- seq -w 1 19 → Todos los números ocupan lo mismo (rellena con 0 a la izquierda)
	- seq -f '%.2f' 1 2.5 21 → Con -f indicas el formato decimal al estilo de printf
	- {1..9} → Parecido a seq 1 9. Probad con echo {1..9}, y echo “Num: “{1..9}
	- {01..19} → Números de 2 cifras
	- {0..9..2} → Equivale a seq 1 2 9
	- for i in {1..9}
	- for i in $(seq 1 9)

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
# Si coincide, elimina el valor de la variable HOME desde el principio al valor de la variable PWD

echo ${PWD}
/home/bootuser/Documentos/Scripting
echo ${HOME}
/home/bootuser

echo ${PWD#$HOME}
/Documentos/Scripting
```