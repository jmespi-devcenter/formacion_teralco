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

Hay multiples editores:
- Vim
- Nano
- Sublime
- Visual Estudio Code

## - Vim
- Nos centraremos en los comandos más utiles del editor Vim ya que este es el que seguro existe en todos los sistemas operativos tanto modernos como antiguos.

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

## Stdin , Stdout, Stderr  
  
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
zip archivo_comprimido.zip ./Documentos/prueba_comprimir  
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

# GESTION DE PERMISOS

Se establecen en 3 bloques **usuario - grupo - otros**  

```shell 
Usuario  Grupo  Otros
rwx      rwx    r-x
```

Cada uno de los bloques cuenta con 8 bits de estado :
- 0 -> sin acceso ---  
- 1-> ejecución --x  
- 2-> escritura -w-  
- 3-> escritura y ejecución -wx  
- 4-> lectura r--  
- 5 -> lectura y ejecución r-xls  
- 6 -> lectura y escritura -> rw-  
- 7 -> lectura, escritura y ejecución -> rwx  
  
## - Umask

Son los permisos que se otorgan por defecto al crear ficheros y direcctorios. Se definen los  que no se van a dar, se calculan los que se van a dar restandolos del completo  

**OJO!!**-> no tiene en cuenta el permiso de ejecución 
  
Lo podemos modificar de manera persistente en:  
```shell
$HOME/.profile  
/etc/profile  
/etc/login.defs  
```
- Para ficheros:  
	- 666 - umask (0002) -> 664  
  
- Para directorios  
	- 777 - umask (0002) -> 775

- Para poder hacer cd en un directorio, éste tiene que tener permiso de ejecución
  
## - Manejo de Permisos:  
- chmod -> Cambio de permisos sobre un fichero o directorio  
	- -r -> recursivo, aplica a subdirectorios y ficheros dentro del directorio  
	- -v -> verbose  
	- +x -> permiso de ejecución  

- chown -> cambio de propietario de un archivo o directorio
	- -c -> muestra la información de los directorios y ficheros donde se han cambiado los permisos

```shell
#cambia el usuario propietario de archivo.txt
chown root /ruta/archivo.txt
#cambia el usuario y grupo para archivo.txt
chown root:web /var/home/archivo.txt
#cambia el usuario propietario de los directorios y ficheros dentro de home
chown -R root /var/home  
```
  
**OJO!!** -> la opción -R no modifica el propietario de la ruta en la que te encuentras, modifica el propietario de los ficheros de este directorio y los directorios internos pero no la carpeta padre.  

- chgrp -> cambiamos el grupo del fichero o directorio  
	- -c -> muestra la información de los directorios y ficheros donde se han cambiado los permisos 

```shell
#cambia el grupo del archivo ejemplo.txt
chgrp root ejemplo.txt
#cambiar grupo a directorios y ficheros dentro de home
chgrp -R root /etc
```
  
OJO!!! -> la opción -R no modifica el propietario de la ruta en la que te encuentras, modifica el propietario de los ficheros de este directorio y los directorios internos pero no la carpeta padre.  
  

## - Añadir usuario y grupos

adduser o useradd -> buscar distribución, varía en función del sistema operativo  

# SSH

- Protocolo para realizar conexiones remotas a otros sistemas. 
- Existen dos tipos de autenticación:
	- Cifrado Simetrico: Una misma clave compartida que conocen los 2 equipos  
	- Cifrado Asimetrico: Par de claves privada/pública. En el servidor se instala la clave pública y el cliente almacena la clave privada. Una vez se realiza la conexión el cliente envía la clave privada al servidor y éste junto con la clave pública autoriza la conexión.  
- Para crear una clave de conexión, deberemos ejecutar este comando en nuestra máquina

```shell
# Crear claves:  
ssh-keygen -t ed25519  
```

- Los protocolos de seguridad más comunes son:
- RSA
- ed25519 -> protocolo más seguro y moderno que RSA  

- Una vez ejecutado el comando anterios deberemos copiar el contenido de nuestro certificado público (.pub) en la máquina destino. Concretamente en el fichero

```shell
 ~/.ssh/authorized_keys  
```

También se puede copiar desde nuestra máquina, siempre y cuando conozcamos la contraseña de conexión al servidor destino

```shell
ssh-copy-id -f -i "clave publica" usuario@ip 
#-f -> opción para forzar, a priori no sería necesario pero no hemos podido ejecutarlo.
#Con esta opción especificamos el certificado privado que queremos utilizar en la conexión, si no se especifica escoge el que está con nombre por defecto
Para acceder a ssh -> ssh usuario@ip -i "certificado privado"  
```
  
## -Scp
- Herramienta para transferencia de ficheros utilizando protocolo de conexión shh.

- Para copiar fichero utilizaremos el siguiente comando:
```shell
SCP -i "clave privada" "archivo o directorio a copiar" usuario@ip:"ruta destino"  
```

- Parámetros:  
	- -P especificar puerto  (22 es el puerto por defecto)
	- –c cipher te da la posibilidad de especificar el algoritmo de cifrado que utilizará el  cliente.
	- -o se especifica el protocolo de intercambio de clave publica  
	- –r es para copia recursiva, que incluirá todos los subdirectorios.
	- –u borrará el archivo fuente después de que se complete la transferencia.
  
## -Sftp  
- Subsistema de SSH para transferencia de ficheros  
  
- Comandos útiles:
- Los comandos que comienzan por l se ejecutan en local mientras está habilitada la conexión sftp  
- Local - Remoto
	- lls - ls  
	- lcd - cd  
	- lpwd - pwd  
	- get - mget -> Obtener ficheros o directorios desde el equipo remoto (mget) multiples peticiones  
	- put - mput -> envía ficheros o directorios desde el equipo local al remoot (mput) multiples peticiones  

# JSON
- Tipo de ficheros que se utilizan para intercambio de datos. Tienen una estructura de
	- Clave - valor  
	- Delimitados por {} 
  
- Para el tratamiento de datos de JSON desde linux utilizamos la herramienta jq  
```shell
# ejemplo.json
{
"colors": [
	{
	 "color": "black",
	 "category": "hue",
	 "type": "primary",
	 "code":{
	 	"rgba":[
			255,
			255,
			255,
			1
		],
		"hex": "#000"
	 }
	},
	{
	 "color": "white",
	 "type": "primary",
	 "code": {
		 "rgba": [
			 101,
			 104,
			 117,
			 1
		 ],
		 "hex": "#FFF"
	 }
	}
]
}
```

- Los comandos para utilizar la herramienta jq son los siguientes:
	- < ejemplo.json jq '.colors[0].color'
	- cat ejemplo.json | jq '.colors[0].color'  
  
- Basandonos en el fichero, estos son unos ejemplos que podemos utilizar

```shell
# EJEMPLOS VARIOS  
cat ejemplo1.json | jq 'dell(.colors[1].category) | implode'  
cat ejemplo1.json | jq 'del(.colors[1].category) | implode'  
cat ejemplo1.json | jq 'del(.colors[1].category)'  
cat ejemplo1.json | jq 'del(.colors[0].category)'  
cat ejemplo1.json | jq 'add(.colors[].category)'  
cat ejemplo1.json | jq 'addvalue(.colors[].category)'  
cat ejemplo.json | jq '.colors[].category=="hue"'  
cat ejemplo.json | jq '.colors[].category=="huee"'  
cat ejemplo.json | jq '.colors[].category=="hue"'  
cat ejemplo.json | jq 'if .colors[].category=="hue" then echo "existe" else echo "no existe"'  
cat ejemplo.json | jq 'if .colors[].category=="hue" then eco "existe" else "no existe" end'  
cat ejemplo.json | jq 'if .colors[].category=="hue" then "existe" else "no existe"'  
cat ejemplo.json | jq 'if .colors[].category=="hue" then "existe" else "no existe" end'  
```

# CURL Y WGET

- Son herramientas para obtener datos desde una máquina remota
	- wget -> solo admite protocolos http, https, ftp y sftp. 
		- Por defecto descarga los documentos  
	- curl -> permite muchos más protocolos.
		- Por defecto muestra los datos por pantalla.  

- Instalación

	- Ubuntu / Debian

```shell
sudo apt install curl
sudo apt install wget
```

	- CentOS

```shell
sudo yum install curl
sudo yum install wget
```

## - Curl

- Protocolos compatibles:
	- HTTP y HTTPS
	- FTP y FTPS
	- IMAP e IMAPS
	- POP3 y POP3S
	- SMB y SMBS
	- SFTP
	- SCP
	- TELNET
	- GOPHER
	- LDAP y LDAPS
	- SMTP y SMTPS

- Sintaxis:
	- curl \[OPTIONS] \[URL]
		- curl https://devcenter.es
		- curl https://devcenter.es > fichero.txt

- Opciones, Hay comandos Curl que nos dan la opción de descargar archivos de forma remota, lo podemos hacer de dos maneras:
	- -O -> Guardará el archivo en el directorio de trabajo actual con el mismo nombre que tiene el archivo remoto.
	- -o -> Permite especificar el nombre de archivo o ubicación diferente.
	- -C -> Permite reaunar una descarga en caso de que esta se haya cortado.
- Multiples descargas: 
	- Para ello haremos uso del comando **xargs** deberemos especificarle un archivo al comando con las rutas que queremos descargar

```sehll
xargs –n1 curl -O < listaUrls.txt
```

- Cookies -> Es posible a través de comando cURL descargar las cookies de un sitio web y luego verlas, para ello, usaremos el siguiente comando con el fin de guardarlas en un archivo .txt. y luego será posible usar el  comando cat para ver el archivo generado:

```shell
curl --cookie-jar Mycookies.txt https://www.samplewebsite.com/index.html -O
```

- Ftp
	- Descargar archivos

```shell
curl -u username:password -O ftp://Nombre_o_ip_FTP/fichero
```

		- Descargar archivos

 ```shell
 curl -u username:password -T fichero ftp://Nombre_o_ip_FTP
```

## - Wget

- Herramienta informática creada por el Proyecto GNU.
- Puedes usarlo para recuperar contenido y archivos de varios servidores web. El nombre es una  combinación de World Wide Web y la palabra get. Admite descargas a través de FTP, SFTP, HTTP y HTTPS.
- Wget se crea en C portátil y se puede usar en cualquier sistema Unix/linux. También es posible implementarlo en Mac OS X, Microsoft Windows, y otras plataformas.

 ```shell
 wget "url"
```

- Parámetros:
	- -O -> especificar nombre de fichero
	- --limit-rate=XXX -> establecer un límite de velocidad de descarga
	- --tries=XXX -> establecer número de reintentos
	- -b -> descarga en segundo plano
	- wget-log -> fichero de log (aparecerá en el directorio de trabajo)
		- Se puede visualizar con *tail -f wget-log*
- Enlaces rotos:
	- Podemos comprobar si existen enlaces rotos en una url determinada

```shell
wget -o wget-log -r -l 5 --pider http://example.com
```

- -o -> Recopila la salida en un archivo
- -l -> Especifica el número de recurencia
- -r -> Hace que la descarga sea recurrente
- -spider -> Configura wget en modo araña. 