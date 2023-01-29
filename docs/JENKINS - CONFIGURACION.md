# CONFIGURACIÓN

## - Primer Login

- Una vez funcionando nuestro jenkins, en primer lugar deberemos ejecutar los comandos que aparecen en la terminal para conocer la ip y contraseña que tendrá nuestro servicio.

```shell
1. Get your 'admin' user password by running:
  kubectl exec --namespace jenkins-project -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo
  
2. Get the Jenkins URL to visit by running these commands in the same shell:

  export NODE_PORT=$(kubectl get --namespace jenkins-project -o jsonpath="{.spec.ports[0].nodePort}" services jenkins)
  export NODE_IP=$(kubectl get nodes --namespace jenkins-project -o jsonpath="{.items[0].status.addresses[0].address}")
  echo http://$NODE_IP:$NODE_PORT

3. Login with the password from step 1 and the username: admin

5. Configure security realm and authorization strategy
   
6. Use Jenkins Configuration as Code by specifying configScripts in your values.yaml file, see documentation: http://$NODE_IP:$NODE_PORT/configuration-as-code and examples: https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos
```

- Una vez dentro nos centraremos en los puntos a tratar para la configuración de nuestro Jenkins.

## - Estructura de directorios

- La ruta principal de Jenkins viene indicada en la variable de entorno $JENKINS_HOME.
- La clave del controlador es utilizada para encriptar los datos existentes en el directorio de secretos, el cual contiene las credenciales. Se almacena en en el fichero 

```shell
$JENKINS_HOME/secrets/hudson.util.Secret. 
```

- Si necesitamos recuperar el sistema desde una copia de seguridad, necesitaremos este fichero. Cualquiera que posea este fichero, podrá desencriptar nuestros secretos desde un backup.
	- Por tanto, el fichero master.key debe ser respaldado en una sitio distinto al donde se respalde el resto del sistema.
- En caso de que debamos restaurar el sistema al completo, primero restauraremos el resto del sistema y por último la clave
- JENKINS_HOME: Respaldando este directorio completamente estaremos guardando toda la instancia de Jenkins. Para restaurarlo simplemente tendremos que copiar el backup en el nuevo sistema.
	- No obstante, la carpeta JENKINS_HOME contiene gran cantidad de ficheros que no son necesarios respaldar.
	- Los ficheros de configuración (config.xml y *.xml) se encuentran directamente en $JENKINS_HOME.
	- Podemos hacer una copia de todos ellos. Una práctica común consiste en respaldarlos en un repositorio SCM.
- Dentro de JENKINS_HOME encontramos el directorio ‘jobs’, donde se guarda toda la información de los josb ejecutados en el sistema.
	- ./builds — Contains build records
	- ./builds/archive — Contains archived artifacts!!!!
	- ./workspace — Contiene fichero obtenidos a partir de SCM, probablemente no necesitemos respaldar esta carpeta.
	- ./plugins/*.hpi — Plugin packages with specific versions used on your system
	- ./plugins/*.jpi — Plugin packages with specific versions used on your system
- No necesitamos respaldar las siguientes carpetas:
	- ./war — Exploded war file. To restore a system, download the latest war file.
	- ./cache — Downloaded tools. To restore a system, download the current version of the tools.
	- ./tools — Extracted tools. To restore a system, extract the tools again.
	- ./plugins/xxx — Subdirectories of installed plugins. These will be automatically populated on the next resta
- Para chequear que hemos realizado correctamente la copia de seguridad del sistema, basta con apuntar la variable de entorno JENKINS_HOME a la carpeta donde se encuentra nuestro backup.
- A continuación debemos lanzar de nuevo la instancia de Jenkins.

```shell
java -jar jenkins.war ---httpPort=9999
```

# PLUGINS

- Para un correcto funcionamiento de jenkins deberemos instalar complementos adicionales. 
- Para ello dentro de la administración de Jenkins hay un apartado de plugins

![[Pasted image 20230129162755.png]]

- Desde este mismo portal podremos buscar en los repositorios los plugins disponibles así como actualizar los que ya tenemos instalados.

- La mayoría de los plugins añaden ciertas configuraciones dentro de Jenkins y la posibilidad de utilizar librerias relacionadas con la funcionalidad del plugin en nuestro Pipelines.

- Vamos a detallar algunos de los que hemos utilizado durante estas prácticas

## - Folders

- (https://docs.cloudbees.com/docs/admin-resources/latest/plugins/folder)

- Permite organizar nuestros pipeline en carpetas, los pipelines almacenados en una carpeta pueden invocar otros pipelines que estén en su mismo directorio o en directorios padre, pero nunca pipelines que esten en otro directorio del mismo nivel.

## - Azure Key Vault
 (https://plugins.jenkins.io/azure-keyvault/)

- Este plugin recupera los secretos existentes en un Azure Key Vault. Una vez finalizada la configuración, los secretos aparecerán en nuestro Jenkins, indicando mediante un icono diferente, que se han recuperado de un Key Vault de Azure
	- Este tipo de credenciales son Read-Only. Los metadatos se sincronizan cada ~10min.
	- Los secretos que se creen en el KV no aparecerán inmediatamente.
	- Podemos forzar el refresco de la caché desde el panel de configuración del sistema.


	![[Pasted image 20230129164406.png]]

	![[Pasted image 20230129164432.png]]

- Aqui tenemos un ejemplo de uso desde un pipeline

```groovy
pipeline {
	agent any
	stages {
		stage(‘Secret’) {
			options {
				azureKeyVault([[envVariable: 'MY_SECRET', name: 'my-secret', secretType: 'Secret']])
			}
			steps {
				sh "echo $SECRET"
				}
		}
		stage('Certificate') {
			options {
				azureKeyVault([[envVariable: 'CERT_LOCATION', name: 'my-cert-name', secretType: 'Certificate']])
			}
			steps {
				sh "openssl pkcs12 -in $CERT_LOCATION -nodes -password 'pass:' -out keyvault.pem"
			}
		}
	}
}
```

## - Azure AD
(https://plugins.jenkins.io/azure-ad/)

- Autenticación basada en Azure Active Directory
- Autorización basada en Grupos/Roles de Active Directory
- Existen alternativas para utilizar LDAP (https://plugins.jenkins.io/active-directory/)

![[Pasted image 20230129171811.png]]

## - Sonarqube
(https://plugins.jenkins.io/sonar/)

- Integración con servidor SonarQube
- Permite centralizar la configuración de la conexión a distintos servidores Sonar existentes, por ejemplo, podemos mantener la configuración de uno para entornos de desarrollo y otro adicional para producción.
- La configuración de este plugin se encuentra dentro de la Configuración Global de Jenkins.
- Existen distintas formas de lanzar el análisis:
	- Sonarqube CLI (sonar-scanner-cli)
	- Maven (Plugin de sonar para maven)
	- Configuración en pom.xml y en settings.xml
- La credencial debe ser añadida a Jenkins Credentials como una credencial de tipo Secret Text

![[Pasted image 20230129172210.png]]

- Desde nuestro pipeline, usaremos la función proporcionada por el plugin ‘withSonarQubeEnv’, indicando el nombre que le dimos a la configuración al darla de alta en Jenkins.

```groovy
withSonarQubeEnv('My SonarQube Server', envOnly: true) {
// This expands the evironment variables SONAR_CONFIG_NAME, SONAR_HOST_URL,
// SONAR_AUTH_TOKEN that can be used by any script.
println ${env.SONAR_HOST_URL}
}

withSonarQubeEnv('SONAR_DEV') {
	sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.7.0.1746:sonar'
}
```

# PIPELINES

# SECRETOS

- Mediante el módulo de secretos gestionamos las credenciales para que nuestro Jenkins pueda acceder a los distintos servicios a los que tiene que enviar y recibir información. Generalmente las conexiones se realizan mediante ssh con los distintos servicios.
	-  La gran mayoría de los pipelines que ejecutamos requieren de algún tipo de credencial para poder hacer su trabajo.
	- Todos los secretos deben quedar fuera del repositorio de código, por tanto, se necesita de un lugar donde guardar todos los secretos.
	- Jenkins proporciona un sistema de almacenamiento de credenciales. No es seguro. Cualquiera que tenga acceso a Jenkins podría tener acceso a todas las credenciales guardadas.
	- No se pueden usar algoritmos de encriptación one-way como bcrypt, ya que los pipelines necesitan obtener y utilizar la clave desencriptada. Por tanto, Jenkins debe encriptar las credenciales y asegurarse que será capaz de desencriptarlas en el futuro. Guarda la clave de encriptado en su sistema.

- Jenkins guarda la información relativa a las credenciales en los siguiente ficheros:

```shell
$JENKINS_HOME/credentials.xml (incluye la lista de credenciales existentes)
$JENKINS_HOME/secrets/master.key (Clave que desencripta el fichero hudson.util.Secret)
$JENKINS_HOME/secrets/hudson.util.Secret (desencripta el fichero credentials.xml
```

```shell
 println hudson.util.Secret.decrypt("{AQAAABAAAAAgPT7JbBVgyWiivobt0CJEduLyP0lB3uyTj+D5WBvVk6jyG6BQFPYGN4Z3V
JN2JLDm}")
```

**Tenemos varios pipelines donde podemos obtener los secretos que tenemos almacenados**

![[Pasted image 20230129163854.png]]

### - Buenas prácticas

- Mantener actualizado Jenkins. :D
- Seguir el principio de “Menor privilegio”. ReadOnly / ReadWrite
- Limitar el acceso. Cuando un pipeline solo necesite un subconjunto de credenciales,crear las credenciales dentro del ámbito del Folder/Carpeta. El plugin Folders nos ayuda en este sentido.
- Intentar evitar el uso de credenciales. Los proveedores cloud permiten el acceso a los recursos asignando un rol o identidad (Azure Managed Identity) a una máquina (VM, Cluster Kubernetes, SQL Server, ...).
- Rotar los secretos. Los proveedores cloud proporcionan servicios para albergar secretos. Estos servicios son capaces de rotar las claves automáticamente cada cierto tiempo. Los secretos podrían filtrarse igual pero tendrían una vigencia limitada.

# OTRAS CONFIGURACIONES

## - Ejecución de scripts

- Jenkins permite ejecutar scripts directamente el el nodo master mediante su consola de scripts.

![[Pasted image 20230129172003.png]]

- Por seguridad, Jenkins tiene deshabilitado el uso de una buena cantidad de funciones y librerias que debemos desbloquear para poder usarlas en nuestros scripts

![[Pasted image 20230129172023.png]]

- Podeis encontrar gran cantidad de scrips en
	https://www.jenkins.io/doc/book/managing/script-console/


## - Consola de debug
## - Envío de emails

- Jenkins proporciona un informe enviado por email donde se indicará el estado de finalización del job

![[Pasted image 20230129161952.png]]

![[Pasted image 20230129162029.png]]

Hay un plugin llamado **email-ext** 
https://plugins.jenkins.io/email-ext/
- Proporciona versatilidad y envío de emails desde cada pipeline

```shell
agent any
stages {
	stage('Ok') {
		steps {
		echo "Ok"
		}
	}
}
post {
	always {
	emailext body: 'A Test EMail', recipientProviders: [[$class: 'DevelopersRecipientProvider'],
	[$class: 'RequesterRecipientProvider']], subject: 'Test'
	}
}

# recipientProviders: añadimos destinatarios adicionales. Por ejemplo para incluir a los desarrolladores implicados en los cambios del repositorio y a la persona que inició el job.
```