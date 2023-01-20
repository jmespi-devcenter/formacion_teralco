 
--------------------------------------------  
SSH  
--------------------------------------------  
Cifrado Simetrico: Una misma clave compartida que conocen los 2 equipos  
  
Cifrado Asimetrico: Par de claves privada/pública. En el servidor se instala la clave pública y el cliente almacena la clave privada.  
  
Una vez se realiza la conexión el cliente envía la clave privada al servidor y éste junto con la clave pública autoriza la conexión.  
  
Crear claves:  
ssh-keygen -t ed25519  
  
ed25519 -> protocolo más seguro y moderno que RSA  
  
para autorizar a un cliente hay que incluir el contenido del .pub  
en .ssh/authorized_keys  
  
Para acceder a ssh -> ssh usuario@ip -i "certificado privado"  
  
Para copiar la clave pública a un servidor remoto utilizaremos el comando  
  
ssh-copy-id -f -i "clave publica" usuario@ip -> hay que conocer la contraseña del servidor  
-f -> opción para forzar, a priori no sería necesario pero no hemos podido ejecutarlo.  
  
También podemos conectarnos al servidor con usuario y contraseña y editar el fichero authorized_keys y añadir nuestra clave publica.  
  
  
SCP -i "clave privada" "archivo o directorio a copiar" usuario@ip:"ruta destino"  
  
Parámetros:  
-P especificar puerto  
-c especifigar el algoritmo de cifrado  
-o se especifica el protocolo de intercambio de clave publica  
  
SFTP  
subsistema de SSH para transferencia de ficheros  
  
COMANDOS  
Los comandos que comienzan por l se ejecutan en local mientras está habilitada la conexión sftp  
lls - ls  
lcd - cd  
lpwd - pwd  
get - mget -> Obtener ficheros o directorios desde el equipo remoto (mget) multiples peticiones  
put - mput -> envía ficheros o directorios desde el equipo local al remoot (mput) multiples peticiones  
  
--------------------------------------------  
JSON  
--------------------------------------------  
Ficheros que se utilizan para intercambio de datos  
Clave - valor  
Delimitados por {}  
  
Para el tratamiento de datos de JSON en linux utilizamos jq  
  
< ejemplo.json jq '.colors[0].color'  
cat ejemplo.json | jq '.colors[0].color'  
  
  
EJEMPLOS VARIOS  
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
  
--------------------------------------------  
CURL Y WGET  
--------------------------------------------  
wget -> solo admite protocolos http, https, ftp y sftp. Por defecto descarga los documentos  
  
curl -> permite muchos más protocolos, por defecto muestra los datos por pantalla.  
  
wget -i example.txt -> permite descargar multiples ficheros  
  
Descargar una página web completa (staticos y prerequisitos)  
wget --mirror --convert-links --page-requisites --no-parent -P /devcenter/ [https://devcenter.es](https://devcenter.es/)  
  
Comprobar errores 404 en una página web  
wget -O -wget-log -r -l 5 --spider [https://devcenter.es](https://devcenter.es/)  
  
XARGS -> ejecuta el comando para cada uno de los elementos que se le pasan a la función. Por defecto el delimitador es el espacio, se puede modificar con -d  
  
EJEMPLO: xargs -n1 curl -o listaurls.txt  
  
echo fichero2.txt fichero3.txt | xargs touch -> crea tanto ficheros como devuelva el comando echo  
  
who | awk '{print $1}' | xargs -I x last -3 x -> lista los tres últimos accesos para el usuario que devuelve el comando who