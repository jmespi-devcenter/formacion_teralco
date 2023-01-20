# COMANDOS DE SISTEMA

Listamos los comandos de sistemas más comunes

Sistema operativo

```shell
uname -a
```

Consola en uso
```shell
echo $SHELL 
```

Entorno de ventanas

```shell
ps -a
```

Historial de comandos utilizados

```shell
history
```

Con **! + número** de comando mostrado en el historial volvemos a lanzar su ejecución

## - Shell

Podemos visualizar la shell por defecto en el fichero /etc/passwd, por defecto utilizaremos bash. Si modificamos el archivo passwd podemos decidir cual es nuestra terminal por defecto.

Las consolas disponibles en el sistema nos aparecen en /etc/shells

## - Listado de ficheros y directorios

El comando utilizado será **ls**


 - ordenar por fecha  
 ```shell
 ls - ltr
 ```
 - ordenar por tamaño
  ```shell
 ls - ltr
 ```
- Mostrar archivos ocultos
 ```shell
 ls - la
 ```


Argumentos ls  
- a ocultos  
- l lista  
- F te da información acerca del tipo de archivo  
- S ordenación de tamaño  
- tr ordenación por fecha  
- R recursivo  
- h 

## - Alias
- Crear alias
```shell
alias bcat=batcat
```
- Borrar alias
```shell
unalias bcat
```

- Crear alias de manera permanente
	- /home/"user"/.bashrc -> editamos el fichero y añadimos el alias (solo para el usuario donde se realice la modificación)

## - Grep

Este comando sirve para filtrar el valor devuelto por otro comando, generalmente se utiliza junto a otro comando precedido de pipe |

Algunos de los parametros más utilizados son:

- -v -> negación  
- -i -> excluir compartarita entre mayúsculas y minúsculas  
- -n -> mostrar nº de linea  
- --exclude-dir=* -> escluir los directorios de los resultados mostrados por grep  

Ejemplo 
```shell
grep -inv linea1 prueba.txt  
```

## - Pipe





## - Procesos

- ps -> procesos de tu terminal  
- ps -ef -> todos los procesos  
- ps -u user -> procesos del usuario
- ps -p id ->muestra procesos con un id
- ps -C nombre_proceso -> muestra procesos por nombre
- ps -ef | grep "" -> para buscar servicios en todos los procesos  
  
TOP  
Ver procesos, por defecto ordenados por uso de CPU  
 - top -d segundos -> reflesca los procesos cada x segundos

Para ordenar la tabla tenemos los siguientes flags  
  
- P -> ordenar por CPU  
- N -> ordenar por PID  
- M -> ordenar por Memoria  
- T -> ordenar por tiempo  
  
Pulsando **xb** destacamos la columna por la que se esta ordenando  
  
Podemos eliminar un proceso pulsando **k** y escribimos el **nº de pid** , de igual manera también podemos eliminar con **kill -9 "pid"**  
  
URL CON MÁS INFORMACIÓN: [https://geekland.eu/usar-entender-monitor-de-recursos-top/](https://geekland.eu/usar-entender-monitor-de-recursos-top/)  
FREE  
- free -th -> muestra información de la memoria completo  
  
COMANDOS DE ESPACIO  
- df -> disk free  
- du -> disk used  
- du -sh * | sort -hr | head -5 -> muestra los 5 directorios más ocupados ordenados de mayor a menor  

## - Redes
- hostname -i -> información de la ip del equipo a nivel de DNS  
- netstat -pltn -> que puertos están en escucha en el equipo
- ip route show -> muestra información de la tabla de rutas  
- mostrar el GW -> ip route show | grep "default via" | awk {'print $3'}  
- mostrar IP del dns -> cat /etc/resolv.conf | grep "nameserver" | awk {'print $2'}  
- Para consultar nuestra ip pública podemos utilizar una de estas opciones
	- curl [ifconfig.com](http://ifconfig.com/)
	- wget -qO - [ifconfig.co](http://ifconfig.co/)  
  
# EDICIÓN DE CARACTERES

## - Sed

Este comando se utiliza para reemplazar carácteres. Si no se utiliza la opción **-i** la modificación **SOLO** se realizará en pantalla

Ejemplo:

```shell
sed 's/Linea1/linea1/' prueba.txt  
```

Cuando realizamos un cambio sin la opción -i solo se modifica en pantalla, para modificar el fichero deberemos utilizar la opción -i  
```shell
sed -i 's/Linea1/linea1/' prueba.txt  
```
  
Con /g modificamos todas las coincidencias del fichero  

```shell  
sed -i 's/Linea1/linea1/g' prueba.txt  
```
  
Reemplazar urs por u en el fichero /etc/shells  
```shell  
cat /etc/shells | sed 's/usr/u/g'  
``` 
  
Sustituir varias expresiones en la misma línea  
```shell
cat /etc/shells | sed 's/bin/b/g' | sed 's/usr/u/g'  
cat /etc/shells | sed -e 's/bin/b/g' -e 's/usr/u/g' -e 's/bash/b/g' -e 's/dash/d/g'  
  ``` 
Mismo que el anterior sin contar con la opción -e  
```shell
cat /etc/shells | sed -e 's/bin/b/g' -e 's/usr/u/g' -e 's/bash/b/g' -e 's/dash/d/g'  
  ``` 

URL CON MÁS INFORMACIÓN
[https://geekland.eu/uso-del-comando-sed-en-linux-y-unix-con-ejemplos/](https://geekland.eu/uso-del-comando-sed-en-linux-y-unix-con-ejemplos/)  

## - Cut

Su principal utilidad es la de borrar secciones, campos o caracteres de la salida de un comando o de cada una de las líneas de un fichero de texto.  

```shell
#Muestra el caracter número 4 de cada línea del fichero / 
cut -c 4 fichero 
#el 4 y el 5
cut -c 4,5 fichero
# del 4 al 6
cut -c 4-6 fichero
#Muestra el tercer elemento utilizando como delimitador el "espacio"
echo "estoy escribiendo una línea" | cut -d ' ' -f3
```

URL CON MÁS INFORMACIÓN: [https://geekland.eu/uso-del-comando-cut-en-linux-y-unix-con-ejemplos/](https://geekland.eu/uso-del-comando-cut-en-linux-y-unix-con-ejemplos/)  
  
## - Awk

Los usos básicos que podemos dar al comando Awk son los siguientes:
- Buscar palabras y patrones de palabras y reemplazarlos por otras palabras y/o patrones.
- Hacer operaciones matemáticas.
- Procesar texto y mostrar las líneas y columnas que cumplen con determinadas condiciones.

Algunos de los parámetros que podemos utilizar son:
- -F -> establecer el delimitador

```shell
#Muestra una columna determinada de la salida del comando “ps”
ps | awk '{print $num_columna}'
#Extrae la columna “num_colum” del fichero “/etc/passwd” usando como delimitador de columnas “delimitador”
cat /etc/passwd | awk -F ":" '{print $1}'
```

URL CON MÁS INFORMACIÓN: [https://geekland.eu/uso-del-comando-awk-en-linux-y-unix-con-ejemplos/](https://geekland.eu/uso-del-comando-awk-en-linux-y-unix-con-ejemplos/)  

# EDICIÓN DE TEXTO

Mostramos algunos de los comandos más útiles del edito Vi/Vim
- :q! -> salir sin guardar  
- :wq -> guardar y salir  
- gg -> ir al inicio  
- G -> ir al final  
- y -> copiar (linea en vim, caracter en vi)  
- Y -> copiar linea en vi  
- d -> cortar  
- p -> pegar  
- u -> desacer  
- dd - > borrar la línea  
- x -> borrar caracter  
- $ -> ir al final de la linea  
- nº linea + gg -> para ir a una línea en concreto  
- :set nu -> mostrar números de línea en el editor  
- :g/cadena1/s//cadena2/gp -> reeplazar cadena  
- /"texto" -> buscar  
- n -> siguiente coincidencia  
- N --> anterior coincidencia  
  
URL DE REFERENCIA: [https://apunteimpensado.com/guia-empezar-vim-linux/](https://apunteimpensado.com/guia-empezar-vim-linux/)  

# GESTIÓN DE ERRORES

## STDIN , STDOUT, STDERR  
--------------------------------------------  
Son las entradas y salidas del sistema, se representan con 0, 1 y 2 respectivamente  
- stdin-> se corresponde con el 0 y es la entrada estándar. Por lo general, la entrada de datos estándar es el teclado. Es decir, lo que tecleas será la información usada. Tiene un dispositivo especial asociado que es /dev/stdin.
- stdout-> identificado con 1, es la salida estándar. Por lo general se corresponde con el  monitor o pantalla de tu equipo, que es donde puedes ver la información. Por ejemplo, cuando  jecutas un comando ls el listado de contenido se mostrará en la pantalla El dispositivo asociado es /dev/stdout.
- stderr: identificada con 2, es la salida estándar de error, para cuando sucede algún error  en algún programa. El dispositivo asociado es /dev/stderr.

Normalmente se utilizan **STDOUT** y **STDERR** para capturar las salidas exitosas y erroneas de los comandos.  

Para redirigir estas salidas a un fichero podemos utilizar:

```shell
#stdout
1>/"dir"/"fichero"
#stderr
2>/"dir"/"fichero_log"
```

# COMPRIMIR Y DESCOMPRIMIR

## - Tar
Con esta herramienta comprimimos todos los elementos en un mismo fichero.

- Comprimir -> tar -czvf comprimir.tar texto.txt  
- Descomprimir -> tar -xzvf comprimir.tar  

Algunos parámetros que podemos utilizar son:
- v -> verbose  
- c -> crear archivo  
- z -> comprimir archivo  
- f -> permite especificar el nombre de salida del fichero  
- p -> conserva los permisos de los ficheros al comprimir y descomprimir  

Para visualizar el contenido que hay dentro de un archivo comprimido podemos utilizar el siguiente comando:
- tar -tf "nombre fichero tar.gz" 

## - Zip - Unzip
Esta herramienta comprime los ficheros uno por uno.
- Comprimir -> zip "nombre archivo comprimido" "ruta archivo o carpeta a comprimir" 

```shell
#zip "nombre archivo comprimido" "ruta archivo o carpeta a comprimir"
zip archivo_comprimido.zip ./documentos/prueba_comprimir  
```

- Descomprimir -> unzip [archivo_comprimido.zip](http://archivo_comprimido.zip/)  

```shell
#zip "nombre archivo comprimido" "ruta archivo o carpeta a comprimir"
unzip archivo_comprimido.zip
```

- Visualizar contenido de un archivo comprimido

```shell
#zip "nombre archivo comprimido" "ruta archivo o carpeta a comprimir"
unzip -l archivo_comprimido.zip
```
