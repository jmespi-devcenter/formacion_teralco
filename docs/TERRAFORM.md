# - ¿Qué es terraform?

- Herramienta escrita en GO con la que podemos desplegar infraestructura, actualizarla o eliminarla.
-  Propiedad de HashiCorp.
- Utiliza HCL (HashiCorp Configuration Language) como lenguaje.
- Lenguaje declarativo, no imperativo.
-  Los ficheros de configuración de Terraform describen la infraestructura como código (IaC).
-  Proporciona un plan detallado de los cambios a realizar antes de llevarlos a cabo.
- Capaz de generar un gráfico con la infraestructura desplegada.
- Ventajas:
- versionado de infraestructura
	- rapidez de despliegue 
	- wrapper de la API del proveedor (AWS, Azure, GCP,...) 
	- basado en plugins
	- Open Source, aunque tiene versión empresarial
- OJO: Sigue siendo dependiente del proveedor: la infraestructura codificada para un proveedor cloud no es válida para el resto.

# - Lenguaje HCL

- Describe el resultado y no los pasos para lograrlo. 
- El elemento más importante del lenguaje de Terraform son los recursos, ya que estos describen los componentes de la infraestructura. 
- Todas las demás características del lenguaje existen única y exclusivamente para especificar los recursos. Son tres los elementos con un papel central:
	- Bloques: los bloques son contenedores para contenido. En esta función, proporcionan espacio para las configuraciones de cualquier objeto, especialmente para recursos configurados. Cada bloque cuenta con un bloque tipo, una o más etiquetas y un área para el cuerpo. Este último contiene tantos argumentos y sub-bloques como se requieran.
	- Argumentos: sirven para asignar un valor a un nombre. Los argumentos siempre se declaran dentro de bloques.
	- Expresiones: las expresiones representan un valor. Se puede tratar de un valor concreto o de una referencia a uno o más valores. Una expresión actúa como un valor de un argumento o dentro de otros argumentos.
- Con HCL como lenguaje declarativo, la secuencia de los bloques no es, en principio, relevante. Terraform procesa automáticamente los recursos descritos en la secuencia correcta, basándose en relaciones predefinidas.

# - Estado

- Con el fin de asignar recursos reales a la configuración, realizar un seguimiento de los metadatos y mejorar continuamente el rendimiento de las grandes infraestructuras, Terraform almacena el estado de los recursos y la configuración. 
- Por defecto, el software almacena el archivo terraform.tfstate creado para este propósito en un directorio local, aunque también es posible seleccionar una ubicación diferente, lo que sobre todo se recomienda para el trabajo en equipo. 
- Con objeto de sincronizar este estado con la infraestructura actual, Terraform lleva a cabo una actualización automática en la CLI antes de cada operación del programa.
- Con la versión free de Terraform, somos nosotros los encargados de almacenar el fichero de estado. Lo normal es guardar los ficheros de estado en la nube, Bucket S3 en AWS, Storage Account en Azure,.. Cualquier miembro del equipo podrá acceder al fichero de estado.
- Es posible “importar” infraestructura existente al fichero de estado, de tal manera que a partir de ese momento, podremos gestionarla desde Terraform.
- Evitar por todos los medios hacer cambios en la infraestructura si no es con Terraform.

# - Terraform CLI

- Interfaz de línea de comandos para poder evaluar y utilizar los archivos de configuración que se 
han creado. 
- Esta interfaz define la sintaxis y la estructura general del lenguaje de Terraform y coordina todos los cambios necesarios para implementar la infraestructura configurada. 
- Carece del conocimiento sobre los tipos específicos de recursos de infraestructura, sino que obtiene esta información a través de extensiones “provider” especiales.
- La interfaz sabe cómo debe definirse y gestionarse cada tipo de recurso en los proveedores de servicios cloud que soporta y puede pasar a las diferentes API de la nube las instrucciones formuladas de forma universal en los archivos de configuración de Terraform.
- Descargar de https://www.terraform.io/downloads
	- curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
	- sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
	- sudo apt-get update && sudo apt-get install terraform
- Una vez instalado el CLI de Terraform, tendremos acceso al comando terraform, el cual acepta una serie de sub-comandos, siendo los más importantes:
	
```shell
#inicializa el entorno descargando la información necesaria de los providers indicados. Es el primer comando que debemos lanzar.
$terraform init

#presenta una lista detallada con la planificación de los cambios a realizar en la infraestructura. Indicará los recursos nuevos a crear con un símbolo + verde, las actualizaciones con el caracter ~ amarillo y los recursos a eliminar con el carácter - rojo.

#Este comando es inocuo, no realiza ningún cambio ni en la infraestructura ni en el fichero de estado.
$terraform plan

# Si la planificación es correcta, lanzaremos este comando para aplicar el plan. De nuevo, muestra los cambios y nos pide confirmación. Admite un parámetro –-auto-approve, con el que se aplicarán los cambios sin pedir confirmación.
$terraform apply: 

#Elimina toda la infraestructura que desplegada.
$terraform destroy: 

# Importa infraestructura existente.
$terraform import: 

#Genera un gráfico con la infraestructura desplegada.
$terraform graph: 

#Chequea estilo y $terraform validate Valida que el código sea correcto
$terraform fmt: 
```

# - Resources

- Los bloques representan recursos se declaran mediante la palabra reservada “resource” seguida el tipo de recurso y su “local name”. La configuración del recurso irá entre {}.
```shell
resource "aws_instance" "web" {
 ami = "ami-a1b2c3d4"
 instance_type = "t2.micro"
}
```

- El tipo de recurso determina la infraestructura que se desplegará y local name permitirá referirnos al recurso.
- El primer “token” del tipo de recurso indica el “local name” del proveedor a utilizar.
- Los recursos pueden llevar un argumento “provider” para el caso de que manejemos un provider con varias configuraciones. 
- Existe una serie de “meta-argumentos” que pueden ser utilizados dentro de un bloque resource y que modifican su comportamiento: depends_on, count, for_each, life_cycle, provider y provisioner.
- Se permite establecer unos límites de tiempo para la implementación de un recurso con “timeouts”

```shell
timeouts {
 create = "60m"
 delete = "2h"
}
```

## - Meta argunmentos (provider)

- Indica la configuración de proveedor que será usado para la creación del recurso.
- Sobreescribe el comportamiento de Terraform.
- Se referencia mediante <proveedor>.<alias>.
