## COMANDOS DE SISTEMA

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

Con **$ + número** de comando mostrado en el historial volvemos a lanzar su ejecución

### Shell

Podemos visualizar la shell por defecto en el fichero /etc/passwd, por defecto utilizaremos bash. Si modificamos el archivo passwd podemos decidir cual es nuestra terminal por defecto.

Las consolas disponibles en el sistema nos aparecen en /etc/shells

### Listado de ficheros y directorios

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

### Alias
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

### Grep

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
  
### Procesos completar documentación
ps -> procesos de tu terminal  
  
ps -ef -> todos los procesos  
  
ps -ef | grep "" -> para buscar servicios en todos los procesos  
  
TOP  
ver procesos, por defecto ordenados por uso de CPU  
  
Para ordenar tenemos los siguientes flags  
  
P -> ordenar por CPU  
N -> ordenar por PID  
M -> ordenar por Memoria  
T -> ordenar por tiempo  
  
Pulsando xb destacamos la columna por la que se esta ordenando  
  
Para poder eliminar el proceso pulsamos k y escribimos el nº de pid  
  
también podemos eliminar con kill -9 "pid"  
  
URL CON MÁS INFORMACIÓN: [https://geekland.eu/usar-entender-monitor-de-recursos-top/](https://geekland.eu/usar-entender-monitor-de-recursos-top/)  
## EDICIÓN DE CARACTERES

### SED

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

### CUT COMPLETAR DOCUMENTACIÓN

Muestra caracteres del contenido de los ficheros  
URL CON MÁS INFORMACIÓN: [https://geekland.eu/uso-del-comando-cut-en-linux-y-unix-con-ejemplos/](https://geekland.eu/uso-del-comando-cut-en-linux-y-unix-con-ejemplos/)  
  
### AWK COMPLETAR DOCUMENTACIÓN

realiza algo parecido a cut pero mucho más dinámico y completo  
  
URL CON MÁS INFORMACIÓN: [https://geekland.eu/uso-del-comando-awk-en-linux-y-unix-con-ejemplos/](https://geekland.eu/uso-del-comando-awk-en-linux-y-unix-con-ejemplos/)  
  



