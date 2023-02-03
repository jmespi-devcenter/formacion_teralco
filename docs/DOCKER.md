# COMANDOS BÁSICOS

### - Ejecutar contenedor

```shell
docker run "nombre del contenero"
```

### - Descargarse una imagen

```shell
docker pull "nombre de la imagen"
```

### - Borrar Imagen

```shell
docker rmi "nombre de la imagen:tag"
```

### - Visualizar procesos

```shell
docker ps
```


### - Historial de una imagen

```shell
docker describe "nombre de la imagen"
```

### - Configuración de una imagen

- Una imagen es una plantilla de solo lectura con instrucciones para crear un contenedor Docker
- Muchas veces, una imagen se basa en otra imagen, con alguna personalización adicional
	- Por ejemplo, se puede crear una imagen que se base en la imagen de ubuntu, pero instalar el servidor web Apache y nuestra aplicación configurada

- Se pueden crear imágenes propias o se pueden usar sólo las creadas por otros y publicadas en un registro

- Las imágenes se crean mediante un fichero llamado Dockerfile, con una sintaxis simple para definir los pasos necesarios para crear la imagen y ejecutarla
	- Cada instrucción en un Dockerfile crea una capa en la imagen. Cuando cambia el Dockerfile y reconstruye la imagen, solo se reconstruyen las capas que han cambiado

```shell

```


### - Parar un contenedor

```shell
docker stop "nombre del contenedor"
```

### - Acceso interactivo a un contenedor

```shell
docker exec -it "nombre del contenedor" bash
```

### - Ver logs de un contenedor

```shell
docker logs "nombre del contenedor"
```



# MAPEO DE PUERTOS

- Por defecto cuando se ejecuta un contenedor no tenemos acceso por lo que no podemos interaccionar, esto ocurre porque cada contenedor tiene su propia red y sus propios puertos. 
- Con la opción -p mapeamos un puerto local con un puerto del contenedor

```shell
docker run -d --name servidorNginx -p 8080:80 nginx
```


# PERSISTENDIA DE DATOS (VOLUMENES)

- Los cambios realizados en los contenedores de Docker mueren al finalizar dicho contenedor. 
- Para solucionar este problema utilizaremos los **volumenes**
- Almacenan la información fuera del contenedor y por lo tanto permanecen aunque los borremos
- Docker almacena por defecto los volumenes en la ruta
	- "_/var/lib/docker/volumes/nombre_del_volumen/_data_"

- Vemos un ejemplo de creación de un volumen


```shell
docker run -d -it --name nombre_contenedor -v nombre_del_volumen:/var/lib/mysql ubuntu
```

- Crear volumenes

```shell
docker volume create "Nombre_volumen"
```

- Listar volumenes

```shell
docker volume ls
```

- Montar volumenes

```shell
docker run -d --name db --mount src=nombre_del_volumen,dst=/data/db mongo
```

- Borrar volumenes

``` shell
docker volume rm nombre_del_volumen
```

- Limpiar volumenes
	- Eliminará los volumenes que no están asociados a ningún contenedor

``` shell
docker volume prune
--WARNING! This will remove all local volumes not used by at least one container.
--Are you sure you want to continue? [y/N] y
```

- Volumenes conectados
	- Nos permite especificar una carpeta concreta de nuestro sistema para interconectar con el contenedor

```shell
docker run --name mongoDB -d -v /home/usuario/basesDeDatos/miBaseDeDatosEnMongo:/data/db mongo
```

- Volumen de solo lectura

```
docker run --name mongoDB -d -v /Users/usuario/Dev/database:/data/db:ro mongo
```

# DOCKERFILE

- Es una forma de realizar todas las configuraciones que hemos visto de manera manual estructurada en un fichero de configuración
- Un Dockerfile es un archivo sin extensión donde especificaremos las características de nuestra imagen
	- Archivos de config personalizada
	- Código propio
	- Librerías extras
	- Abrir Puertos
	- Añadir volumenes

- Ejemplo de un archivo Dockerfile

```
FROM python:3.6
ENV PYTHONUNBUFFERED 1

ADD . /app/

WORKDIR /app/myDockerDjangoApp

RUN pip install -r /app/requirements.txt

EXPOSE 8000
ENV PORT 8000

CMD ["gunicorn", "myDockerDjangoApp.wsgi"]
```

-   **FROM python:3.6: Todos los Dockerfile necesitan una imagen de la cual partir**, en este caso esa imagen es python:3.6
-   **ENV PYTHONBUFFERED 1:** Permite que podamos leer los logs de Python en nuestra terminal
-   **ADD . /app/:** Agrega todos los archivos en la carpeta actual a la carpeta /app/. También sirve COPY, la diferencia radica en que APP acepta archivos comprimidos o una url.
-   **WORKDIR /app/myDockerDjangoApp:** Establece la carpeta /app/myDockerDjangoApp como la carpeta base a usar al correr comandos con CMD, RUN, ADD o COPY
-   **RUN pip install -r /app/requirements.txt:** RUN permite ejecutar comandos, los cuales se ejecutan al momento de compilar la imagen y quedan grabados como una capa nueva en la imagen. Usaremos RUN para instalar todas las dependencias que especificamos en el archivo requirments.txt (solo Django y Gunicorn).
-   **EXPOSE 8000:** Expone el puerto 8000 al exterior.
-   **ENV PORT 8000**: Crea una variable de entorno llamada PORT con el valor de 8000. Esto nos servirá para poder acceder al puerto.
-   **CMD ["gunicorn", "myDockerDjangoApp.wsgi"]:** CMD ejecuta un comando al momento de poner en marcha un contenedor a partir de una imagen, los comandos y los argumentos se separan como si fueran una lista de Python. En este caso, como mencioné arriba, gunicorn solo necesita saber donde está el archivo wsgi que generó django automáticamente.


- Para compilar un Dockerfile utilizaremos el comando:

```
docker build --tag djangocontainer:0.1 .
```


