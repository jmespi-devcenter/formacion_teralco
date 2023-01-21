 
   
CURL Y WGET  
  
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