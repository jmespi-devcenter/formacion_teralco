Grovvy es un lenguaje orientado a objetos, basado en Java. Permite el uso de secuencias de comandos (Scripts).
El código de Groovy se compila en JVM lo que permite que se pueda ejecutar en cualquier plataforma que cuente con Java

# INSTALACIÓN
- Instalar java jdk versión 8

```shell
sudo apt install default-jdk -y
```

- Instalar Groovy

```shell
wget https://www.apache.org/dyn/closer.lua/groovy/4.0.8/distribution/apache-groovy-binary-4.0.8.zip?action=download -O apache-groovy-binary-4.0.8.zip

unzip apache-groovy-binary-4.0.8.zip
```

- Configurar variables de entorno
	- Para configurar las variables de entorno deveremos introducir los siguientes valores en la ruta /etc/profiles
	- Dependerá de la versión de Java que tengamos instalada y de la ruta donde hayamos descargado Groovy

```shell
export JAVA_HOME="/usr/lib/jvm/java-1.11.0-openjdk-amd64"
export PATH=$JAVA_HOME/bin:$PATH

export GROOVY_HOME="$HOME/groovy/groovy-4.0.8"
export PATH=$GROOVY_HOME/bin:$PATH

```

- Comprobar correcta ejecución
	- Para comprobar que ejecutamos correctamente desde terminal, nos crearemos un fichero .groovy y ejecutaremos el siguiente comando

```groovy
groovy condicionales_switch.groovy 
```


# SINTAXIS

- La sintaxis de Groovy es una simplificación de java, se define lo estrictamente necesario para que no existan ambigüedades.

- Ejemplo Java tradicional

	![[Pasted image 20230128092053.png]]

- Ejemplo Groovy

	![[Pasted image 20230128092116.png]]


## - Convenciones

- Existen una serie de convenciones que debemos tener en cuenta a la hora de escribir Groovy
	- El ; al final es opcional, se utiliza para separar variables definidas en una misma línea
	- Los () para llamar a una función son opcionales
		- Son obligatorios cuando la función no tiene argumentos, para que se diferencie de una variable
	- Las funciones son *public* por defecto
	- El *return* al final de la función es opcional, por defecto se devuelve el último comando ejecutado
	- No es necesario declarar el tipo de una variable
	- Todo elemento es tratado como un objeto, se permite sobrecargar algunos operadores
	- Los *getters y setters* se crean por defecto
	- Todas las expresiones numéricas con *BigDecimal* por defecto
	- El concepto *true/false* se extiende a multiples situaciones
		- P.e. -> si evaluamos un string vacio o array con longitud 0 se obtiene **false**, en cualquier otro caso se obtiene **true**

- Existe un operador de referencia segura, este hace que en caso de obtener la expepción *nullPointerException* la ejecución del código continue

## - Strings
- Con tres comillas, ya sean simples o dobles, podemos definir strings de varias líneas
- Existen 2 clases para tratar los strings
	- java.lang.String -> se construyen por defecto con comillas simples o dobles
	- GString -> cadenas interpoladas, reemplazan el marcador de posición por su valor *${}, $* , para expresiones inequivocas

## - Clousures
- Son bloques de código independiente, puede tomar argumentos y devolver valores.
- Son asignables a variables

```groovy
{[clousureParameters ->] statements}
```

- ClousureParameters -> lista opcional de parámetros separados por comas
- statemens -> declaraciones, con cero o más declaraciones
- -> si hay lista de parámetros deberemos utilizar la flecha para separarla de los argumentos

### - Ejemplos

```groovy
//Clousure con un parámetro
def saludaPlaneta ={} { nombre -> 
	printl "Hola ${nombre}!"
}

saludaPlaneta 'Venus'

//Precarga del parámetro
def planeta = saludaPlaneta.curry('Mercurio')
planeta()
```


```groovy
//Clousure con dos parámetros
def multiplicar = ~{factor01, factor02 ->
	factor01 * factor02
}
```


# - Colecciones de datos

### - Rangos 
- Cualquier clase que implemente una interfaz comparable, así como los métodos *next() y previous()* puede ser usuada como valor de un ranto, Date y String

### - Listas
- Colecciones cuyos elementos pueden ser accedidos mediante un índice. Definidas con una relación de valores separados por comas entre corchetes. Instacias de la clase *java.util.list*

### - Maps
- Colecciones de valores referenciados por una clave, pareja calve-valor

### - Métodos
- Hay un gran número de métodos disponibles para trabajar con Rangos, Listas y Mapas
- Documentación -> https://groovy-lang.org/gdk.html

**Hay ejemplos de cada una de estas opciones en los scripts de groovy dentro de la carpeta en el proyecto**


## - Estructuras de control

- Como en cualquier otro lenguje de programación existen las estructuras de control condicionales, blucles y en este caso también tenemos manejo de excepciones.
- Tenemos ejemplo de todas las estructuras de control en la carpeta de groovy en el proyecto

	![[Pasted image 20230128102750.png]]
	
## - Operadores
- Existen operadores de varios tipos
	- Aritméticos
	- De asignación
	- Relacionales
	- Lógicos
	- Binarios
	- Condicionales
	- De objetos
	- Expresiones regurales

A continuación se dejan algunos de ellos
![[Pasted image 20230128103657.png]]  ![[Pasted image 20230128103710.png]] ![[Pasted image 20230128103723.png]]![[Pasted image 20230128103738.png]]
![[Pasted image 20230128103759.png]]  ![[Pasted image 20230128103816.png]]
![[Pasted image 20230128103834.png]] ![[Pasted image 20230128103841.png]]


#COMPLETAR 

