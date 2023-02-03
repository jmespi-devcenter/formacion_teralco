- Kubernetes (también conocida como k8s o "kube") es una plataforma open source para la organización en contenedores que automatiza muchos de los procesos manuales involucrados en la implementación, la gestión y el ajuste de las aplicaciones que se alojan en ellos (orquestador).
- Creado por los ingenieros de Google.
- Google donó el proyecto a la organización Cloud Native Computing Foundation (CNCF) en 2015.
- El nombre Kubernetes proviene del griego y significa timonel o piloto. K8s es una abreviación que se obtiene al reemplazar las ocho letras "ubernete" con el número 8.

# ARQUITECTURA

![[Pasted image 20230203165528.png]]

## - Control Plane

- Es el encargado de mantener el estado deseado del clúster, como las aplicaciones que se ejecutan y las imágenes de contenedores que se utilizan.
- El plano de control de Kubernetes recibe las instrucciones del administrador (o del equipo de DevOps) y las transmite a las máquinas informáticas.
- Esta transferencia trabaja con una gran cantidad de servicios para decidir automáticamente cuál es el nodo más adecuado para la tarea. Luego, distribuye los recursos y asigna los pods que se encuentran en ese nodo para cumplir con la tarea solicitada.
- Los componentes que forman el plano de control toman decisiones globales sobre el clúster (por ejemplo, la planificación) y detectan y responden a eventos del clúster
- Por ejemplo: la creación de un nuevo pod cuando la propiedad réplicas de un controlador de replicación no se cumple
- Estos componentes pueden ejecutarse en cualquier nodo del clúster.
- El plano de control se ejecuta en varios nodos para garantizar la alta disponibilidad

## - Kube-apiserver
- Componente del plano de control que expone la API de Kubernetes
- Se trata del frontend de Kubernetes, recibe las peticiones y actualiza  cordemente el estado en etcd
- Principal implementación de la API
- Implementación preparada para ejecutarse en alta disponibilidad y puede escalar horizontalmente para balancear la carga entre varias instancias

## - etcd

- Almacén de datos persistente, consistente y distribuido de clave-valor utilizado para almacenar toda a la información del clúster de Kubernetes

## - Kube-scheduler

- Componente del plano de control que está pendiente de los Pods que no tienen ningún nodo asignado y selecciona uno donde ejecutarlo
- Un pod es la unidad mínima de computación en Kubernetes y representa uno o más contenedores ejecutándose en el clúster
- Para decidir en qué nodo se ejecutará el pod, se tienen en cuenta diversos factores: requisitos de recursos, restricciones de hardware/software/políticas, afinidad y anti-afinidad, localización de datos dependientes,...

## - Kube-controller-manager

- Componente del plano de control que ejecuta los controladores de Kubernetes
- Los controladores son bucles de control que observan el estado del cluster, y ejecutan o solicitan los cambios que sean necesarios para alcanzar el estado deseado
- Estos controladores incluyen:
	- Controlador de nodos: es el responsable de detectar y responder cuándo un nodo deja de funcionar
	- Controlador de replicación: es el responsable de mantener el número correcto de pods para cada controlador de replicación del sistema
	- Controlador de endpoints: construye el objeto Endpoints, es decir, hace una unión entre los Services y los Pods
	- Controladores de tokens y cuentas de servicio: crean cuentas y tokens de acceso a la API por defecto para los nuevos Namespaces

## - Cloud-controller-manager

- Componente del plano de control que ejecuta controladores que interactúan con proveedores de la nube
- Permite que el código de Kubernetes y el del proveedor de la nube evolucionen de manera independiente. Anteriormente, el código de Kubernetes dependía de la funcionalidad específica de cada proveedor de la nube. En el futuro, el código que sea específico a una plataforma debería ser mantenido por el proveedor de la nube y enlazado a cloud-controller-manager al correr Kubernetes

## - Componentes del nodo

- Corren en cada nodo, manteniendo a los pods en funcionamiento y proporcionando el entorno de ejecución de Kubernetes

### - Kubelet

- Agente que se ejecuta en cada nodo de un clúster. Se asegura de que los contenedores estén corriendo en un pod
- El agente kubelet toma un conjunto de especificaciones de Pod, llamados PodSpecs, que han sido creados por Kubernetes y garantiza que los contenedores descritos en ellos estén funcionando y en buen estado

### - Kube-proxy

- Permite abstraer un servicio en Kubernetes manteniendo las reglas de red en el anfitrión y haciendo reenvío de conexiones 

### - Runtime de contenedores

- El runtime de los contenedores es el software responsable de ejecutar los contenedores. Kubernetes soporta varios de ellos: Docker, containerd, cri-o, rktlet y cualquier implementación de la interfaz de runtime de contenedores de Kubernetes, o Kubernetes CRI

## - Addons

- Los addons son pods y servicios que implementan funcionalidades del clúster. Estos pueden ser administrados por Deployments, ReplicaSet y otros. Los addons asignados a un espacio de nombres se crean en el espacio kube-system

- Algunos ejemplos son:
	- DNS
	- Interfaz Web (Dashboard)
	- Monitor de recursos de contenedores
	- Logging de los clusters
	- ...

# OBJETOS

- Los Objetos de Kubernetes son entidades persistentes dentro del sistema de Kubernetes. Kubernetes utiliza estas entidades para representar el estado de tu clúster. Específicamente, pueden describir:
	- Qué aplicaciones corren en contenedores (y en qué nodos)
	- Los recursos disponibles para dichas aplicaciones
	- Las políticas acerca de cómo dichas aplicaciones se comportan, como las políticas de reinicio, actualización, y tolerancia a fallos

- Es un "registro de intención"; Una vez que has creado el objeto, el sistema de Kubernetes se pondrá en marcha para asegurar que el objeto existe. Al crear un objeto, en realidad le estás diciendo al sistema de Kubernetes cómo quieres que sea la carga de trabajo de tu clúster; esto es, el estado deseado de tu clúster. (spec - status)

- Para crearlos, modificarlos, o borrarlos se usa la API de Kubernetes. Cuando utilizas el interfaz de línea de comandos kubectl, por ejemplo, este  realiza las llamadas necesarias a la API de Kubernetes en tu lugar.

https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/

## - Gestión de objetos

![[Pasted image 20230203171321.png]]

- Comandos:
	- Comandos imperativos
		- kubectl create deployment nginx --image nginx
	- Configuración de objetos imperativos
		- kubectl create -f nginx.yaml
	- Configuración de objetos declarativos
		- kubectl apply -f configs/

## - Namespaces

- Kubernetes soporta múltiples clústeres virtuales respaldados por el mismo clúster físico. Estos clústeres virtuales se denominan espacios de nombres (namespaces)

- El alcance es aplicable solo para objetos con espacio de nombres (por ejemplo, Deployments, Services, etc.) y no para objetos de todo el clúster 
	- (por ejemplo, StorageClass, Nodes, PersistentVolumes, etc)

- Los espacios de nombres están pensados para utilizarse en entornos con muchos usuarios distribuidos entre múltiples equipos, o proyectos. Para aquellos clústeres con unas pocas decenas de usuarios, no deberías necesitar crear o pensar en espacios de nombres en absoluto

- Namespaces iniciales:
	- default: El espacio de nombres por defecto para aquellos objetos que no especifican ningún espacio de nombres
	- kube-system: El espacio de nombres para aquellos objetos creados por el sistema de Kubernetes
	- kube-public: Este espacio de nombres se crea de forma automática y es legible por todos los usuarios

## - Labels

- Las etiquetas son pares de clave/valor que se asocian a los objetos

- El propósito de las etiquetas es permitir identificar atributos de los objetos que son relevantes y significativos para los usuarios, pero que no tienen significado para el sistema principal

- Se puede usar las etiquetas para organizar y seleccionar subconjuntos de objetos

- Las etiquetas permiten consultar y monitorizar los objetos de forma más eficiente

- Al contrario que los nombres y UIDs, las etiquetas no garantizan la unicidad. En general, se espera que muchos objetos compartan la(s) misma(s) etiqueta(s)

- Se pueden adjuntar a los objetos en el momento de la creación o más tarde. Se pueden modificar en cualquier momento

- Ejemplos de etiquetas:
	- "release" : "stable", "release" : "canary"
	- "environment" : "dev", "environment" : "qa", "environment" : "production"
	- "tier" : "frontend", "tier" : "backend", "tier" : "cache"
	- "partition" : "customerA", "partition" : "customerB"
	- "track" : "daily", "track" : "weekly"

## - Selectors

- A través del selector de etiqueta, el cliente/usuario puede identificar un conjunto de objetos. El selector de etiqueta es la primitiva principal de  agrupación en Kubernetes

- La API actualmente soporta dos tipos de selectores: basados en igualdad y basados en conjunto. Un selector de etiqueta puede componerse de múltiples requisitos separados por coma. En el caso de múltiples requisitos, todos ellos deben ser satisfechos de forma que las comas actúan como operadores AND (&&) lógicos

- Basados en Igualdad o Desigualdad: permiten filtrar por claves y valores de etiqueta. Los objetos coincidentes deben satisfacer todas y cada una de las etiquetas indicadas, aunque puedan tener otras etiquetas adicionalmente. Se permiten tres clases de operadores =,\==,!=. Los dos primeros representan la igualdad (son sinónimos), mientras que el último representa la desigualdad

- Basados en Conjuntos: permiten el filtro de claves en base a un conjunto de valores. Se puede utilizar tres tipos de operadores: in, notin y exists (sólo el identificador clave)  

https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/

## - Annotations

- Las anotaciones sirven para adjuntar metadatos arbitrarios a los objetos

- La diferencia principal con las etiquetas es que estas sirven para seleccionar objetos y las anotaciones no

- Ejemplos de anotaciones:
	- Información acerca de la construcción, entrega, o imagen como marcas de fecha, IDs de entrega, rama de Git, número de PR, funciones hash de imágenes, y direcciones de registro
	- Referencias a los repositorios de trazas, monitorización, analíticas, o auditoría
	- Número de teléfono o contacto de las personas a cargo, o entradas de directorio que especifican dónde puede encontrarse dicha información, como la página web de un equipo de trabajo
	- Directivas del usuario final a las implementaciones para modificar el comportamiento o solicitar funcionalidades no estándar

		![[Pasted image 20230203173546.png]]
			
				
https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/

## - Containers

- Cada contenedor que se ejecuta es repetible; la estandarización de tener las dependencias incluidas significa que obtienes el mismo comportamiento

- Los contenedores desacoplan las aplicaciones de la infraestructura de host subyacente
- Una imagen de contenedor es un paquete de software listo para ejecutar que contiene todo lo necesario para ejecutar una aplicación: el código y cualquier runtime que requiera, librerías de aplicaciones y sistemas, y valores predeterminados para cualquier configuración esencial

- Un contenedor es inmutable: no puede cambiar el código de un contenedor que ya se está ejecutando. Si tenemos una aplicación en un contenedor y se quieren hacer cambios, se debe crear una nueva imagen que incluya el cambio y luego volver a crear el contenedor para comenzar desde la imagen actualizada

- El container runtime es el software responsable de ejecutar los contenedores

https://kubernetes.io/docs/concepts/containers/

