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



## - Meta argumentos (provider)

- Indica la configuración de proveedor que será usado para la creación del recurso.
- Sobreescribe el comportamiento de Terraform.
- Se referencia mediante proveedor alias

```shell
provider "google" {
	region = "us-central1"
}
provider "google" {
	alias = "europe"
	region = "europe-west1"
}
resource "google_compute_instance"
"ejemplo" {
	provider = google.europe
}
```

## - Meta argumentos (depends_on)

- Se utiliza el meta-argumento “depends_on” para establecer dependencias internas a la hora de la ejecución, más allá de las detectadas por Terraform.
- Podemos forzar a que unos recursos dependan de la creación de otros aunque entre ellos no exista relación.
- Solo es necesario en caso en que un recurso (A) dependa de otro (B) pero no utilice ninguno de los datos de (B) para dar valor a sus argumentos
- Puede forzar la dependencia con uno ó más recursos.

```shell
resource "aws_iam_instance_profile" "p" {
	role = aws_iam_role.example.name
}
resource "aws_iam_role_policy" "example" {
	 name = "example"
	 role = aws_iam_role.example.name
	 policy = jsonencode({
		 "Statement" = [{
			 "Action" = "s3:*",
			 "Effect" = "Allow",
		 }],
	 })
}

resource "aws_instance" "example" {
	 ami = "ami-a1b2c3d4"
	 instance_type = "t2.micro"
	 iam_instance_profile = aws_iam_instance_profile.p
	 depends_on = [
	 aws_iam_role_policy.example,
	 ]
}
```

## - Meta argumentos (bucles)

### - Count

-  Por defecto, un bloque resource solo despliega un recurso. Terraform nos proporciona dos formas de crear más de un recurso por bloque mediante los meta-argumentos count y for_each. No es posible utilizar ambas en el mismo bloque.
- El meta-argumento “count” tendrá como valor un entero e indicará el número de recursos que se crearán.
- Cada uno de los recursos creados será independiente del resto, se crearán, modificarán y eliminarán de forma separada.
- En los bloques en los que se defina “count”, será posible acceder al objeto “count”, el cual tiene una propiedad “index” que indica el número de instancia creada.
- Para referirnos a cada uno de los recursos, usarmos [], aws_instance.server o aws_instance.server[0]

```shell
resource "aws_instance" "server" {
	count = 4
	ami = "ami-a1b2c3d4"
	instance_type = "t2.micro"
	tags = {
		Name = "Server ${count.index}"
	}
}
```

### - For_each

- Si un bloque contiene un argumento “for_each” cuyo valor es un diccionario (map) o lista (set) de cadenas, Terraform creará una instancia para cada uno de los items que contenga el map o set.
- En cada uno de los bloques donde se utilice “for_each”, se podrá acceder a un objeto “each” que contendrá los valores de cada iteración.
- El objeto each tendrá dos atributos: key y value
- El valor de “for_each” debe se ser conocido antes de la ejecución

```javascript
azurerm_resource_group.rg => bloque, 
azurerm_resource_groupt.rg[each.key] => instancia (a_group, another_group)
```

```shell
resource "azurerm_resource_group" "rg" {
	for_each = {
		 a_group = "eastus"
		 another_group = "westus2"
	}
	name = each.key
		location = each.value
	}
resource "aws_iam_user" "the-accounts" {
	for_each = toset(["Todd", "James", 	"Alice"])
		name = each.key
}
```

## - Meta-argumentos (life_cycle)

-  Los bloques “resource” pueden incluir un argumento llamado “life_cycle”. Este modifica del ciclo de vida normal de un recurso, alterando el comportamiento ante una actualización o un borrado del mismo.
- “life-cycle” es a su vez un bloque que puede incluir los siguientes argumentos:
	- create_before_destroy (bool): Cuando un recurso no puede ser modificado, Terraform por defecto elimina el recurso y lo vuelve a crear. Con este argumento podemos cambiar el orden.
	- prevent_destroy (bool): Evita que un recurso se elimine. Terraform mostrará un error durante el “plan”. ¿Qué ocurre si eliminamos el recurso de la configuración?
	- ignore_changes (list): Por defecto Terraform detecta diferencias entre la infraestructura real y la configuración deseada y planifica los cambios necesarios para alinearlas. Este argumento contendrá una lista con los atributos que se deben ignorar en caso de sufrir cambios. Se utiliza cuando se va a desplegar un recurso en el que se especifican datos que se van a cambiar en el futuro (secretos de un key vault)

```shell
resource "aws_instance" "ej1"
{
	lifecycle {
		 ignore_changes = [
		 tags,
	 ]
	}
}
```

## - Provisioners

- Los Provisioners se pueden utilizar para ejecutar acciones en la máquina local donde esté corriendo Terraform o en máquinas remotas, con el fin de preparar los servidores para operar

```shell
resource "aws_instance" "web" {
 # ...
	 provisioner "local-exec" {
	 command = "echo The server's IP address is ${self.private_ip}"
 }
 provisioner "local-exec-on-destroy" {
	 when = destroy
	 command = "echo 'Destroy-time provisioner'"
 }
 provisioner "local-exec" {
	 command = "echo The server's IP address is ${self.private_ip}"
	 on_failure = continue # fail
 }
}
```


# - Data

- Permiten a Terraform utilizar información definida fuera de la configuración actual.
- Cada proveedor dispone de una serie de datasources asociados a cada uno de los recursos que ofrece.
- Se accede mediante un bloque denominado “data”. ¡¡ Soportan count y for_each !!data <data_source_name> <local_name> {}
- Un bloque “data” solicita que Terraform interrogue al proveedor por un valor determinado de un recurso y lo almacene en una variable. El datasource y el nombre servirán de identificador.
- El body de un bloque “data” contendrá una serie de argumentos que definirá el datasource que estemos utilizando.

```shell
data "aws_ami" "example" {
	most_recent = true
	owners = ["self"]
	tags = {
		Name = "app-server"
		Tested = "true"
	}
}
```

# - Variables

## - Input

- Se utilizan como parámetros de Terraform, la idea es que se pueda customizar el despliegue de infraestructura simplemente modificando el valor de las variables, sin tocar el código.
- Nos referimos a ellas como “variables” o “variables de terraform”.
- Terraform también puede utilizar variables de entorno, extraídas del shell donde se ejecuta.
- Normalmente se declararán en un fichero llamado “vars.tf”
- El bloque utilizado para declarar una variable es: variable “<\nombre>” {}
- Los parámetros que admite son:
	- default: valor por defecto de la variable, si esta no se inicializa.
	- type: tipo de la variable, 
		- simple: string, number, bool
		- complejo: list(\<type>), set((\<type>), map((\<type>), tuple[(\<type>],object({(\<ATTR NAME> = (\<TYPE>, ... })
		- any
	- description: describe la variable
	- validation: regla de validación lógica. puede utilizar funciones, p.ej ip, mask, etc
	- sensitive (bool): si true, omite el valor de la variable en los logs. 
	- nullable (bool): indica si la variable admite ‘null’ como valor

```shell

variable "image_id" {
	type = string
	description = "The id of the machine image (AMI) to use for the server."
validation {
	 condition = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
	 error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
	}
 # Otra forma de validación mediante expresiones regulares
validation {
# regex(...) fails if it cannot find a match
	condition = can(regex("^ami-", var.image_id))
	error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
	}
}
```

- ¿Cómo asignamos valores a las variables declaradas?
	- línea de comando, mediante el parámetro de terraform -var

```shell
$terraform apply -var="image_id=ami-abc123"
$terraform apply -var='image_id_list=["ami-abc123","ami-def456"]' -var="instance_type=t2.micro"
$terraform apply -var='image_id_map={"us-east-1":"ami-abc123","us-east-2":"ami-def456"}'
```

- ficheros .tfvars, mediante el parámetro de terraform -var-file

```shell
$terraform apply -var-file="testing.tfvars"
```

- Terraform carga por defecto ficheros:
	- terraform.tfvars
	- *.auto.tfvars
- Variables de entorno: Terraform carga aquellas variables de entorno que comiencen por 
```shell
TF_VAR_*
$export TF_VAR_image_id='ami-abc123'
```

- Terraform carga las variables en el siguiente orden:
	- variables de entorno (TF_VAR_*)
	- terraform.tfvars
	- *.auto.tfvars
	- -var y -var-file: en el orden introducido
- Haremos referencia a las variables mediante var.<nombre_de_varible>

```shell
resource "aws_instance" "example" {
	instance_type = "t2.micro"
	ami = var.image_id
}
```

## - Output

- Disponibilizan información sobre la infraestructura desplegada.
- Esta información puede ser consumida desde la propia configuración de terraform. Como veremos más adelante, es la forma de intercambiar datos entre módulos.
- También puede ser consumida en la línea de comandos:

```shell
#muestra todas las variables de salida.
$terraform output

#muestra info sobre la variable solicitada. (param -raw)
$terraform output <nombre_de_variable>
```

- Se declaran mediante un bloque “output”: output “nombre_variable” {}
- Parámetros:
```shell
#valor de salida. referencia a algún atributo de recurso de la configuración.
value (obligatorio)

# (string): descripción del output
description

#indica si se debe ocultar su valor
sensitive (booleano)

#indica dependencias que impedirían consultar el valor, evitar su uso.
depends_on
```

● Normalmente se declaran en un fichero “output.tf”

```shell
output "db_password" {
	value = aws_db_instance.db.password
	description = "The password for logging in to the database."
	sensitive = true
}
output "instance_ip_addr" {
	value = aws_instance.server.private_ip
	description = "The private IP address of the main server instance."
	depends_on = [
	 # Security group rule must be created before this IP address could
	 # actually be used, otherwise the services will be unreachable.
	 aws_security_group_rule.local_access,
	]
}
```

## - Locals

- Las variables locales tienen el ámbito del fichero en el que se declaren.
- Su cometido no es otro que eliminar la necesidad de repetir un mismo valor a lo largo de un fichero .tf.
- Podríamos decir que son variables temporales.
- Se declaran y definen dentro de un bloque “locals”: locals {}
- En el body del bloque, incluimos parejas argumento=valor

```shell
locals {
	service_name = "forum"
	owner = "Community Team"
}
```

- Para definir el valor de los argumentos, podemos hacer uso de funciones.
- Nos referimos a estas variables locales con la palabra “local.<nombre_de_variable>”

```shell
resource "aws_instance" "example" {
	 # ...
	 tags = local.common_tags
}
```

# - Modulos

## - Conceptos

- Un módulo en Terraform es el equivalente a una función en un lenguaje de programación.
- Contiene una serie de recursos que trabajan juntos.
- Como cualquier función, tendrán unos parámetros de entrada, de salida y variables de función, cuyo ámbito se limita al propio módulo.
- Estos módulos podrán llamar a otros módulos o ser llamados desde otros módulos superiores, dando lugar a una jerarquía.
- Permiten la reusabilidad del código.
- Lanzar $terraform init para instalar, -upgrade para actualizar versión
- Se declaran con la palabra reservada “module”: module “<nombre_del_módulo>” {}
- Admite los siguientes argumentos:
	- source: Obligatorio, indica el path hacia nuestro módulo o la dirección de un módulo remoto albergado en un registro público o privado.
	- version: Recomendado
	- parámetros necesarios para la ejecución del módulo (input variables)
- Admite meta-argumentos: count, for_each, providers, depends_on
- Acceso a outputs: module.<nombre_de_modulo>.<nombre_de_output>

```shell
module "servers" {
 source = "./app-cluster"
 servers = 5
 }
 resource "aws_elb" "example" {
 # ...
 instances = module.servers.instance_ids
}
```

## - Origenes

- El argumento “source” de un bloque “module” indica a Terraform dónde tiene que ir a buscar el código fuente del módulo.

- local

``` shell
module "consul" {
	source = "./consul"
}
```

- registro público/privado de Terraform

``` shell
source = "hashicorp/consul/aws" 
source = "\<hostname>/example-corp/k8s-cluster/azurerm" 
```

- GitHub/BitBucket

``` shell
source = "github.com/hashicorp/example" ó con ssh "git@github.com:hashicorp/example.git"
source = "bitbucket.org/hashicorp/terraform-consul-aws"
```

- Git genérico

``` shell
source = "git::https://example.com/vpc.git" ó con ssh "git::ssh://user@host.com/storage.git"
```

- HTTPS

``` shell
source = "https://example.com/vpc-module.zip"
```

- S3

``` shell
source = "s3::https://s3-eu-west-1.amazonaws.com/examplecorp-terraform-modules/vpc.zip"
```

## - Meta-argumentos

- El bloque “module” acepta los siguientes meta-argumentos:
	- providers
		- https://developer.hashicorp.com/terraform/language/meta-arguments/module-providers#the-module-providers-meta-argument
	- depends_on (ver resources)
		- https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on#the-depends_on-meta-argument
	- count (ver resources)
		- https://developer.hashicorp.com/terraform/language/meta-arguments/count#the-count-meta-argument
	- for_each (ver resources)
		- https://developer.hashicorp.com/terraform/language/meta-arguments/for_each#the-for_each-meta-argument

# - Expresiones

- Se utilizan para definir o calcular valores en una configuración de Terraform
- Una expresión en Terraform puede ser
	- literal: ej: un string o un número
	- referencias: datos exportados por bloques resource o data
	- operaciones aritméticas
	- evaluación de condicionales
	- funciones provistas por Terraform
- Las expresiones se pueden utilizar en multitud de sitios pero existen ciertas limitaciones en las que Terraform necesita conocer el valor antes de la planificación.
- Podemos evaluar expresiones desde un terminal, mediante el comando 

```shell
$terraform console
echo 'split(",", "foo,bar,baz")' | terraform console
```

## - Tipos

- Las expresiones dan como resultado un valor, y dicho valor será de un determinado tipo.
	- string: “hello”
	- number: 3.1416
	- bool: true
	- list (tuple): secuencia de valores identificados por 0…n. ["us-west-1a", "us-west-1c", 3]
		- valores de tipos heterogéneos
		- multilínea
		- separados por ,
		- está permitida una , al final
		- referenciados con [] => local.lista[0]
	- map (object): secuencia de valores identificados por etiquetas {name = "Mabel", age = 52}
		- valores de tipos heterogéneos
		- multilínea
		- separados por , o salto de línea
		- referenciados con notación de . ò [] =>local.cliente.nombre ó local.cliente[“nombre”]
- El valor null no tiene tipo

## - Strings

- Soporta la clásica declaración entrecomillada con “ y la ‘heredoc’ que facilita la declaración multilínea:

```shell
block {
	value = <<EOT
	hello
	world
	EOT
}
```

- Se usa \$\$\{ \ó \%\%{ como secuencia de escape,no funciona \ para escapar caracteres.
- Se pueden generar plantillas interpolando variables (${}) o directivas (%{}).
	- ${...}: Interpolamos el valor de una variable. “Hello, ${var.cliente.name}”
	- %{...}: Permite el uso de condicionales y bucles para la definición de una plantilla
		- condicionales: %{if \<BOOL>}/%{else}/%{endif}
		- bucles: %{for \<NAME> in \<COLLECTION>} / %{endfor}

```shell
 greeting = "Hello ${var.cliente.nombre} eres %{if var.cliente.edad >= 18} mayor %{else} 
 menor %{endif} de edad"
 ips=<<EOT
 %{ for ip in aws_instance.example.*.private_ip }
 server ${ip}
 %{ endfor }
 EOT
```

## - Aritmeticas

- Aritméticos: 
	- +, -: a + b, a - b, -a
	- *, /, %: a * b, a / b, a % b
- Igualdad:
	- == : a == b
	- != : a != b
- Comparación:
	- , >=
	- <, <=
- Lógicos:
	- &&: a && b
	- ||: a || b
	- ! : !a

## - Condicionales/Bucles

- Condicionales:
	- Utiliza el valor de una expresión para decidir entre dos valores. 
	- Operador ternario: condition ? true_val : false_val
- For:
	- Crea un valor de tipo complejo (list, map) a partir de otro valor complejo.
	- Puede dar como resultado:
		- una lista []: [for s in var.list : upper(s)]
		- un objeto {}: {for s in var.list : s => upper(s)}
	- Admite el filtrado de items que cumplan una condición: [for s in var.list : upper(s) if s != ""]
	- Puede convertir de tipos complejos no-ordenados (maps, objects, sets) en tipo complejos ordenados (lists, tuples). Terraform internamente ordena maps y objects léxicamente por nombre de atributo. En el caso de sets de strings, ordenará léxicamente por el valor de los strings.
- [*], .*:
	- Denominadas expresiones “splat”
	- Equivalentes a algunos bucles for sobre listas, tuplas o sets ids=[for o in var.list : o.id] => ids=var.list[*].id => legacy ids=var.list.*.id

## - Bloques dinámicos

- Construye de forma dinámica bloques anidados dentro de bloques: resource, data, provider y provisioner.
- Funciona de forma similar a for.
- Itera sobre un valor complejo (list, map) y genera un sub-bloque para cada uno de los elementos del valor complejo.

```shell
dynamic "setting" {
 for_each = var.settings
 content {
 namespace = setting.value["namespace"]
 name = setting.value["name"]
 value = setting.value["value"]
 }
}
```

- El bloque comienza con la palabra ‘dynamic’ seguida del nombre del argumento.
- for_each: indica la variable compleja sobre la que itera.
- content: indica el contenido que tendrá cada uno de los bloques generados dinámicamente.

# - Restricciones de tio

- object: { \<KEY> = \<TYPE>, \<KEY> = \<TYPE>, ... } => object({name=string, age=number}) => 
	- {name:”john”,age:21}. Podemos indicar que un atributo es opcional: b = optional(string)
- map: \<TYPE> => map(string) => { name: “John”, job: “developer” }
- tuple: [ \<TYPE>, \<TYPE>, …] => tuple([string, number]) => [“John”, 21]
- list: \<TYPE> => list(string) => [“John”, “Amanda”,”John”, ...]
- set: \<TYPE> => set(string) => [“John”, “Amanda”, ...] // Set elimina duplicados
- any: Es un tipo especial, Terraform trata de ajustarlo dinámicamente. Si no puede, lanzará un error. list(any)
- Conversiones de tipo:
- map => object: solo se pueden convertir si al menos tienen todas las keys requeridas en el esquema del objeto.
- list => tuple: solo se pueden convertir si la lista tiene exactamente el mismo número de items que la tupla
- list, tuple => set: se eliminan duplicados, se pierde el orden.
- set => list, tuple: si el set es de ‘strings’ el orden es lexicográfico. En cualquier otro caso no se garantiza un orden particular de los elementos.

# - Funciones

# - Backend









