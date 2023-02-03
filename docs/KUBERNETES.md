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

# CARGAS DE TRABAJO

## - Pods

- Los Pods son las unidades de computación desplegables más pequeñas que se pueden crear y gestionar en Kubernetes

- Son un grupo de uno o más contenedores, con almacenamiento/red compartidos, y unas especificaciones de cómo ejecutar los contenedores. Modelan un “host lógico”

- Permiten el intercambio de datos y la comunicación entre los contenedores que lo constituyen

- Todas las aplicaciones en un Pod utilizan el mismo namespace de red (la misma IP y puerto) y, por lo tanto, pueden "encontrarse" entre sí y comunicarse utilizando localhost. Debido a esto, las aplicaciones en un Pod deben coordinar su uso de puertos

https://kubernetes.io/docs/concepts/workloads/pods/

## - Pods Lifecycle

- Los Pods se crean, se les asigna un identificador único (UID) y se planifican en nodos donde permanecen hasta su finalización (según la política de reinicio) o supresión.
	- Si un nodo muere, los Pods programados para ese nodo se programan para su eliminación después de un período de tiempo de espera

- Un Pod dado (definido por su UID) no se "replanifica" a un nuevo nodo; en su lugar, puede reemplazarse por un Pod idéntico, con incluso el mismo nombre si lo desea, pero con un nuevo UID

- La fase en un Pod es un resumen simple y de alto nivel como se encuentra el Pod en su ciclo de vida.
	- Pending: El clúster de Kubernetes aceptó el Pod, pero uno o más de los contenedores no se configuraron ni prepararon para ejecutarse.
	- Running: El Pod se ha vinculado a un nodo y se han creado todos los contenedores. Al menos un contenedor todavía se está ejecutando o está en proceso de iniciarse o reiniciarse
	- Succeeded: Todos los contenedores en el Pod finalizaron correctamente y no se reiniciarán.
	- Failed: Todos los contenedores en el Pod terminaron y al menos un contenedor terminó con fallo.
	- Unknown: Por alguna razón no se pudo obtener el estado del Pod. Esta fase generalmente ocurre debido a un error en la comunicación con el nodo donde se debe ejecutar el Pod.

https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/

## - Replicaset

- Su objetivo es el de mantener un conjunto estable de réplicas de Pods ejecutándose en todo momento. Así, se usa en numerosas ocasiones para garantizar la disponibilidad de un número específico de Pods idénticos

- A diferencia del caso en que un usuario crea Pods de forma directa, un ReplicaSet sustituye los Pods que se eliminan o se terminan por la razón que sea, como en el caso de fallo de un nodo o una intervención disruptiva de mantenimiento, como una actualización de kernel. Por esta razón, se recomienda que se use un ReplicaSet incluso cuando la aplicación sólo necesita un único Pod.

- Entiéndelo de forma similar a un proceso supervisor, donde se supervisa múltiples Pods entre múltiples nodos en vez de procesos individuales en un único nodo. Un ReplicaSet delega los reinicios del contenedor local a algún agente del nodo (por ejemplo, Kubelet o Docker)

https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/

## - Deployments

- Un controlador de Deployment proporciona actualizaciones declarativas para los Pods y los ReplicaSets

- Cuando describes el estado deseado en un objeto Deployment, el controlador del Deployment se encarga de cambiar el estado actual al estado deseado de forma controlada

- Un Deployment es un objeto que puede poseer ReplicaSets y actualizar a estos y a sus Pods. Aunque que los ReplicaSets puede usarse independientemente, hoy en día se usan principalmente a través de los Deployments como el mecanismo para orquestar la creación, eliminación y actualización de los Pods

	![[Pasted image 20230203181122.png]]

https://kubernetes.io/docs/concepts/workloads/controllers/deployment/

## - StatefulSet
- Se usa para gestionar aplicaciones con estado

- Al igual que un Deployment, un StatefulSet gestiona Pods que se basan en una especificación idéntica de contenedor.

- A diferencia de un Deployment, un StatefulSet mantiene una identidad asociada a sus Pods. Estos pods se crean a partir de la misma especificación, pero no pueden intercambiarse; cada uno tiene su propio identificador persistente que mantiene a lo largo de cualquier re-programación

- Los StatefulSets son valiosos para aquellas aplicaciones que necesitan:
	- Identificadores de red estables, únicos
	- Almacenamiento estable, persistente
	- Despliegue y escalado ordenado, controlado
	- Actualizaciones en línea ordenadas, automatizadas

- Si una aplicación no necesita ningún identificador estable(persistencia entre (re)programaciones de Pods) o despliegue, eliminación, o escalado ordenado, deberías desplegar tu aplicación con un controlador que proporcione un conjunto de réplicas sin estado, como un Deployment o un ReplicaSet, ya que están mejor preparados para tus necesidades sin estado

https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/

## - DaemonSets

- Un DaemonSet garantiza que todos (o algunos) de los nodos ejecuten una copia de un Pod. Conforme se añade más nodos al clúster, nuevos Pods son añadidos a los mismos. Conforme se elimina nodos del clúster, dichos Pods se destruyen. Al eliminar un DaemonSet se limpian todos los Pods que han sido creados

- Algunos casos de uso típicos de un DaemonSet son:
	- Ejecutar un proceso de almacenamiento en el clúster
	- Ejecutar un proceso de recolección de logs en cada nodo
	- Ejecutar un proceso de monitorización de nodos en cada nodo

https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/

## -Jobs y CronJobs

- Un Job crea uno o más pods y continuará reintentando la ejecución de los pods hasta que un número específico de ellos finalice con éxito. A medida que los pods finalizan con éxito, el Job realiza un seguimiento de las finalizaciones exitosas. Cuando alcanza un número específico de finalizaciones correctas, el Job se completa (finaliza)
	- Eliminar el Job borrará los pods que creó. Y la suspensión del Job borrará sus pods activos hasta que el trabajo se reanude de nuevo

- Un caso simple es crear un Job para ejecutar de manera confiable un pod hasta su finalización. El Job iniciará un nuevo Pod si el primer Pod falla o se elimina (por ejemplo, debido a un fallo del hardware del nodo o un reinicio del nodo)

- Un CronJob crea Jobs en un horario repetitivo, es como una línea de un archivo crontab. Ejecuta un trabajo periódicamente en un horario determinado, escrito en formato Cron

# SERVICIOS

- Un Servicio enruta el tráfico a través de un conjunto de Pods. Los servicios son la abstracción que permite que los pods mueran y se repliquen en Kubernetes sin afectar a las aplicaciones. El descubrimiento y el enrutamiento entre pods dependientes (como componentes frontend y backend en una aplicación) son manejados por los servicios.

![[Pasted image 20230203182557.png]]

## - Publicar Servicios

- En algunas partes de la aplicación (por ejemplo, frontends) puede que se necesite exponer un Service a una dirección IP externa, que está fuera del clúster local

- Los valores Type y sus comportamientos son:
	- ClusterIP: Expone el Service en una dirección IP interna del clúster. Al escoger este valor el Service solo es alcanzable desde el clúster. Este es el ServiceType por defecto
	- NodePort: Expone el Service en cada IP del nodo en un puerto estático (el NodePort)
	- LoadBalancer: Expone el Service externamente usando el balanceador de carga del proveedor de la nube
	- ExternalName: Mapea el Service al contenido del campo externalName (ej. foo.bar.example.com), al devolver un registro CNAME con su valor. No se configura ningún tipo de proxy

## - Ingress

- Ingress expone las rutas HTTP y HTTPS desde fuera del clúster a los servicios dentro del clúster. El enrutamiento del tráfico está controlado por reglas definidas en el recurso Ingress

- Se puede configurar un Ingress para dar servicio de direcciones URL accesibles externas, balancear la carga del tráfico, encriptar SSL/TLS y ofrecer alojamiento virtual DNS

- Ingress no es un tipo de Service, pero actúa como el punto de entrada de tu clúster. Te permite consolidar tus reglas de enrutamiento en un único recurso, ya que puede exponer múltiples servicios bajo la misma dirección IP

![[Pasted image 20230203182719.png]]

https://kubernetes.io/docs/concepts/services-networking/ingress/

# ALMACENAMIENTO

## - Volumes

- El uso de volúmenes resuelve principalmente dos problemas:
	- El primero es la pérdida de archivos cuando el contenedor termina. Kubelet reinicia el contenedor con un estado limpio de nuevo
	- El segundo ocurre cuando compartimos ficheros entre contenedores corriendo juntos dentro de un Pod

- Kubernetes soporta muchos tipos de volúmenes. Un Pod puede utilizar cualquier número de tipos de volúmenes simultáneamente. Los tipos de volúmenes efímeros tienen el mismo tiempo de vida que un Pod, pero los volúmenes persistentes existen más allá del tiempo de vida de un Pod.
	 - Cuando un Pod deja de existir, Kubernetes destruye los volúmenes efímeros; sin embargo, Kubernetes no destruye los volúmenes persistentes. Para cualquier tipo de volumen en un Pod dado, los datos son preservados a lo largo de los reinicios del contenedor

- Docker provee también controladores de volúmenes, pero la funcionalidad es algo limitada

https://kubernetes.io/docs/concepts/storage/volumes/

## Persisten volumes

- Un PersistentVolume (PV) es una pieza de almacenamiento en el clúster. Es un recurso en el clúster al igual que un nodo es un recurso de clúster. 
	- Los PV son complementos de volumen como Volúmenes, pero tienen un ciclo de vida independiente de cualquier Pod individual que use el PV

- Un PersistentVolumeClaim (PVC) es una solicitud de almacenamiento por parte de un usuario. Es similar a un Pod. Los pods consumen recursos de nodos y los PVC consumen recursos de PV. Los pods pueden solicitar niveles específicos de recursos (CPU y memoria). Los claims pueden solicitar modos de acceso y tamaños específicos (por ejemplo, se pueden montar ReadWriteOnce, ReadOnlyMany o ReadWriteMany)

https://kubernetes.io/docs/concepts/storage/persistent-volumes/

# CONFIGURACIÓN

## - ConfigMaps

- Es un objeto de la API utilizado para almacenar datos no confidenciales en el formato clave-valor Los Pods pueden utilizar los ConfigMaps como variables de entorno, argumentos de la línea de comandos o como ficheros de configuración en un Volumen

- Un ConfigMap te permite desacoplar la configuración de un entorno específico de una imagen de contenedor, así las aplicaciones son fácilmente portables

https://kubernetes.io/docs/concepts/configuration/configmap/

## - Secrets

- Te permiten almacenar y administrar información confidencial, como contraseñas, tokens OAuth y llaves ssh. Poniendo esta información en un Secret es más seguro y más flexible que ponerlo en la definición de un Pod o en un ConfigMap

- Para usar un Secret, un Pod debe hacer referencia a este

https://kubernetes.io/docs/concepts/configuration/secret/


# COMANDOS KUBECTL Y MINIKUBE

```shell
- minikube start
- kubectl version -o yaml
- kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1
- kubectl get all -o wide
- kubectl describe TIPO_OBJETO NOMBRE_OBJETO
- kubectl logs NOMBRE_OBJETO
- kubectl exec --stdin --tty NOMBRE_POD -- /bin/bash
- kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080
- minikube ip
- kubectl scale deployments/kubernetes-bootcamp --replicas=4
- kubectl describe deployments/kubernetes-bootcamp
- kubectl get events
- minikube dashboard
- kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2
- kubectl rollout undo deployments/kubernetes-bootcamp
- minikube delete
```



