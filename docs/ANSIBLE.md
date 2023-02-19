# - Conceptos Básicos

- Ansible es una herramienta libre que permite automatizar la administración de un conjunto de equipos.
- Toma el nombre de un dispositivo de comunicación interestelar instantánea.
- Usado para mantener en el estado deseado los equipos que debemos administrar. Así, por ejemplo, cuando se desea instalar un nuevo paquete o definir un nuevo usuario basta con añadir la tarea para que se lleve a cabo en todos aquellos equipos donde sea necesario.
- Es suficiente con tener una máquina en la que esté instalado Ansible, no es necesario instalar nada en los host que debamos configurar.
- Ansible utiliza SSH para establecer la comunicación con los hosts remotos que administra y no necesita que se instale en ellos ningún agente o software especial (únicamente Python que en el caso de GNU/Linux ya suele formar parte de la instalación).
- Entendemos el concepto “estado” como la configuración que tiene un host en un momento determinado. Esta configuración incluye tanto ficheros como procesos, es decir, no se limita a la instalación y configuración de paquetes sino que determina si un proceso debe permanecer corriendo o no.
- Con Ansible definimos cual es el estado deseado para un conjunto de host.
- Ansible determinará cuales son las diferencias entre el estado actual de un host y el requerido y ejecutará las tareas necesarias para alcanzarlo.

- Para empezar a trabajar con Ansible, es necesario que nos vayamos familiarizando con algunos conceptos:
	- Servidor Ansible: La máquina donde está instalado Ansible y desde la cual se ejecutarán todas las tareas y playbooks.
	- Módulo: Básicamente, un módulo es un comando o conjunto de comandos similares de Ansible destinados a ejecutarse en el lado del cliente.
	- Tarea: Una tarea es una sección que consta de un único procedimiento a completar.
	- Role:Una forma de organizar tareas y archivos relacionados para luego llamarlos en un ‘playbook’.
	- Fact: Información extraída del sistema cliente de las variables globales con la operación de recopilación de datos.
	- Inventario: Archivo que contiene datos sobre los servidores del cliente ansible. Definido en ejemplos posteriores como archivo de hosts.
	- Play: Ejecución de un playbook.
	- Handler: Tarea que se llama solo si hay un notificador presente
	- Notifier: Sección atribuida a una tarea que llama a un controlador (handler) si se cambia la salida
	- Tag: Nombre establecido para una tarea que se puede usar más adelante para emitir solo esa tarea específica o grupo de tareas.

# - Inventario

- En el fichero de inventario tendremos la lista de hosts que necesitamos administrar.
- Este fichero puede ser de varios tipos, aunque los más habituales son INI y YAML.
- Un fichero de inventario en formato INI tendría el siguiente aspecto:

```shell
mail.example.com

[webservers]
foo.example.com
bar.example.com

[dbservers]
one.example.com
two.example.com
three.example.com
```

- El texto entre corchetes indican nombres de agrupaciones. Se usan para clasificar los host según su propósito, de esta forma podemos acotar el grupo de hosts sobre los cuales queremos realizar alguna configuración.

- Un fichero de inventario en formato YAML tendría el siguiente aspecto:
```shell
all:
  hosts:
    mail.example.com
  children:
    webservers:
      hosts:
        foo.example.com
        bar.example.com
    webservers:
      hosts:
        one.example.com
        two.example.com
        three.example.com
```

- Hay dos grupos por defecto: 
	- all: contiene todos los hosts.
	- ungrouped: contiene aquellos hosts que no pertenecen a ningún otro grupo salvo a all.
- Cualquier host pertenecerá al menos a 2 grupos: all y ungrouped o bien all y cualquier otro grupo creado por nosotros.
- Es posible que all y ungrouped no aparezcan en el fichero, pueden estar implícitos.

## - Rangos

- En caso de tener muchos hosts cuyos nombres siguen un patrón, podemos añadirlos de forma rápida haciendo uso de “rangos”:

![[Pasted image 20230219140652.png]]

## - Variables

- Podemos definir variables relativas a un host o a un grupo de ellos.
- Las variables se pueden añadir al propio fichero de inventario o bien crear ficheros de variables para una mejor gestión.
- Asignación de variables a un host:

![[Pasted image 20230219140739.png]]

- El puerto de conexión SSH, en caso de no usar el standard (22), se puede añadir en el fichero de inventario, justo después del nombre del host

![[Pasted image 20230219140843.png]]

- Ocurre lo mismo con algunas variables de conexión:

![[Pasted image 20230219140858.png]]

- ALIAS
	- Podemos definir alias para cada host directamente en el fichero de inventario. De esta forma será más sencillo referirnos a un host en concreto

![[Pasted image 20230219140914.png]]

- Asignación de variables a varios host:
- Si todos los hosts de un grupo comparten el mismo valor de variable, podemos asignarla a la vez
![[Pasted image 20230219140942.png]]

## - Herencia y agrupaciones

- Los hosts y grupos pueden formar parte de una agrupación superior mediante el sufijo “:children” o “children:”
 - La variables de estos “grupos de grupos” se definirán con el sufijo “:vars” o “vars:”

![[Pasted image 20230219141301.png]]

- Un host miembro de un grupo hijo es, a su vez, miembro del grupo padre.
- Las variables de un grupo hijo sobreescribirán a las del grupo padre.
- Un grupo puede tener varios padres y varios hijos, la única restricción es que no existan relaciones circulares.
- Un host puede formar parte de varios grupos pero sólo se considerará una instancia del host al mezclar los datos de varios grupos

## - Variables y grupos

 - Conviene separar variables de host y grupo en ficheros independientes para claridad y mantenimiento.
 - Ansible cargará todos los ficheros de variables de host y grupo que encuentre dentro de la carpeta donde se halle el fichero de inventario.
 - Si un inventario situado en /etc/ansible/hosts contiene un host llamado “foosball” que pertenece a los grupos “webservers” y “westeu”, ansible automáticamente buscará las variables de este host en:

![[Pasted image 20230219141447.png]]

- El orden de evaluación de variables es el siguiente:
	- all group
	- parent group
	- child group
	- host
- Por defecto, Ansible mezcla las variables de los grupos del mismo nivel siguiendo un orden ASCII.
- Este comportamiento se puede cambiar mediante la variable de configuración de grupo ‘ansible_group_priority’, que por defecto se establece a 1.

![[Pasted image 20230219141635.png]]

- Si los grupos tuvieran idéntica prioridad, testvar=b, en este caso se ha incrementado la prioridad de a_group, por lo que se mezclará después y por tanto, testvar=a

## - Multiples inventarios

- Podemos incluir varios inventarios a la vez utilizando el parámetro -i
![[Pasted image 20230219141729.png]]
- También podemos incluir todos los inventarios que existan en un directorio

![[Pasted image 20230219141738.png]]

# - Comandos ad-hoc

## - Conceptos

- Los comandos ad-hoc de Ansible son aquellos que ejecutamos desde nuestra consola y son capaces de realizar una acción sobre un servidor o  grupo de ellos (identificados en nuestro fichero de inventario), sin necesidad de escribir un fichero playbook. 
- Normalmente son usados para realizar alguna tarea sencilla de forma puntual.
- Un ejemplo de comando ad-hoc puede ser el reinicio de una máquina o el copiado de un fichero.
- Comenzaremos por añadir los servidores que necesitemos administrar a nuestro fichero de inventario por defecto (/etc/ansible/hosts) o a uno que creemos nosotros

![[Pasted image 20230219142344.png]]

## - Módulos

- Con los comandos ad-hoc podemos ejecutar módulos de Ansible:
	- Los módulos son las unidades de trabajo en Ansible. 
	- Cada módulo puede estar escrito en diferentes lenguajes de programación y cada uno se puede utilizar de forma individual sin necesidad de instalar ninguna librería en Ansible. La característica principal y por lo que se utilizan módulos es que son idempotentes. Significa que si una operación se ejecuta con éxito, al volver a ejecutar la misma operación, si continúa en el mismo estado, no se vuelve a ejecutar.
	- Hay más de 5.000 módulos distintos, cada uno con su tarea específica. Se puede encontrar una lista completa aquí
	- No hay que memorizarlos :)

## - Ansible


# - Módulos
# - Yaml
# - Playbooks
# - Roles
# - Buenas prácticas
