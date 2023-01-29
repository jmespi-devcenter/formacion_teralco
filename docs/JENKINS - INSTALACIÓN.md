# INSTALACIÓN

- Existen varias formas de realizar la instalación de un servidor Jenkins
	- Desde un archivo war
	- Mediante Docker
	- Mediante Kubernetes

## - War File
- Descargamos el fichero war desde 
	- https://www.jenkins.io/download/
- Ejecutamos el comando 

	```java
	java -jar jenkins.war
	```

- Accedemos a localhost:8080
	- Nuestro servidor está desplegado

## Docker

- Para instalar nuestro servidor Jenkins en docker lo primero que debemos hacer es instalar docker.

### - Pasos de instalación

Ejecutamos los siguientes comandos en el equipo donde vayamos a instalar docker

- Añadimos la GPG Key oficial de Docker

```shell
$ sudo mkdir -p /etc/apt/keyrings
```

```shell
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

- Configuramos el repository de docer

```shell
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

- Instalamos Docker Engine

```shell
sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose
```

- Configuramos que docker inicie con el sistema

```shell
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```

- Configuramos permisos para nuestro usuario
```shell
sudo usermod -aG docker "nombre de usuario"
newgrp docker
```

- Probamos la instalación

```shell
docker run hello-world
curl --unix-socket /var/run/docker.sock http://localhost/version
```

- Una vez docker instalado y funcionando en nuestro equipo, procedemos a desplegar Jenkins
- Creamos un directorio para hacer persistentes nuestros datos

```shell
mkdir $HOME/jenkins_home
```

- Comprobamos el id de nuestro usuario para ver la identificación de los grupos a los que esta asignado

```shell
id
uid=1000(lifecycle) gid=1000(lifecycle) grupos=1000(lifecycle),…,998(docker)
```

- Revisamos los permisos del sistema base del socket de Docker. Deben ser usuario root y grupo docker y permiso de lectura y escritura para el usuario y el grupo

```shell
ls -l /var/run/docker.sock
srw-rw---- 1 root docker 0 ago 13 11:59 /var/run/docker.sock
```

- En caso contrario los definimos

```shell
sudo chown root:docker /var/run/docker.sock
sudo chmod 660 /var/run/docker.sock
```

- Una vez hecho esto, procedemos a crear nuestro **dockerfile** para personalizar nuestra imagen docker de la que partiermos *jenkins/jenkins:lts-jdk11*
- Cambiaremos el gid obtenido del grupo docker al ejecutar el comando anterior (en nuestro caso es 999)

```shell
FROM jenkins/jenkins:lts-jdk11


ARG gid_docker=999
ARG uid_user=1001
ARG gid_user=1001


USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
 https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
 signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
 https://download.docker.com/linux/debian \
 $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin build-essential curl vim ssh netcat
RUN systemctl enable docker.service
RUN systemctl enable containerd.service
RUN groupmod -g ${gid_docker} docker # gid grupo docker
RUN usermod -aG docker jenkins


RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs


USER jenkins
RUN jenkins-plugin-cli --plugins "docker-workflow:521.v1a_a_dd2073b_2e docker-plugin:1.2.9 docker-build-step:2.8"
USER root
RUN usermod -u $uid_user jenkins # uid usuario equipo base
RUN groupmod -g $gid_user jenkins # gid grupo principal usuario base
RUN chown -R jenkins:jenkins /usr/share/jenkins/
RUN chown -R jenkins:jenkins /var/jenkins_home/
USER jenkins
```

- Contruimos la imagen

```shell
docker build -f dockerfile -t myjenkins .
```

- Una vez ya tenemos nuestra imagen personalizada la lanzamos
	- Con el comando -v le especificamos el directorio jenkins_home que hemos creado anteriormente para que nuestros datos sean persistentes.

```shell
docker run --name jenkins-bootcamp -d -p 8080:8080 -p 50000:50000 -v $HOME/jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock myjenkins
```

- Una vez llegado a este punto nuestro sistema jenkins estaría levantado y funcionando en el puerto 8080 de localhost
![[Pasted image 20230128110438.png]]

- Para conocer la contraseña podemos utilizar los siguientes comandos

```shell
docker exec jenkins-bootcamp cat /var/jenkins_home/secrets/initialAdminPassword
```

- o a través del volumen compartido

```shell
cat $HOME/jenkins_home/secrets/initialAdminPassword
```

### - Añadir nodo 

- Para el nodo partiremos de la imagen docker/docker, que personalizamos con el siguiente archivo dockerfile.nodo
- Hay que añadirle la clave pública ssh del contenedor de jenkyns para que la comunicación servidor-nodo sea exitosa

```shell
FROM docker:dind
ENV SSH_PUBLIC_KEY="<INYECTAR AQUÍ EL CONTENIDO DE LA CLAVE PÚBLICA lifecycle.pub>"
ENV RUTA="/root"
RUN apk update
RUN apk add --update unzip curl wget shadow


#RUN groupmod -g 998 docker
RUN mkdir $RUTA/workspace && chmod 777 $RUTA/workspace


# Opcional, instalamos utilidades que necesitaremos más adelante
RUN apk add ansible aws-cli


RUN apk add nodejs-current npm


#Install JDK11 and Groovy
RUN apk add openjdk11
RUN wget https://www.apache.org/dyn/closer.lua/groovy/4.0.4/distribution/apache-groovy-binary-4.0.4.zip?action=download -O $RUTA/apache-groovy-binary-4.0.4.zip && unzip $RUTA/apache-groovy-binary-4.0.4.zip -d $RUTA/ && rm $RUTA/apache-groovy-binary-4.0.4.zip
COPY ./java.sh /etc/profile.d/java.sh


#Enable ssh login
RUN apk add --update --no-cache openssh
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo -n 'root:zeus2022' | chpasswd
RUN mkdir -p $RUTA/.ssh && chmod 755 $RUTA/.ssh && touch $RUTA/.ssh/authorized_keys && chmod 644 $RUTA/.ssh/authorized_keys
RUN echo $SSH_PUBLIC_KEY >> $RUTA/.ssh/authorized_keys
COPY ./entrypoint.sh $RUTA/entrypoint.sh
RUN chmod +x $RUTA/entrypoint.sh


ENTRYPOINT ["/root/entrypoint.sh"]
```

- Contruimos la imagen, la lanzamos

```shell
docker image build -f dockerfile.nodo . -t dockernodo
```

```shell
docker run --name nodo01 -d -p 2022:22 -v $HOME/workspace:/root/workspace -v /var/run/docker.sock:/var/run/docker.sock --network jnetwork --network-alias nodo dockernodo
```

**Tenemos un documento en el projecto donde se detallan mucho mejor todos estos pasos**

## - Kubernetes

- Para instalar Jenkins desde Kubernetes deberemos instalar minikube

```shell
sudo apt install minikube
```

- Una vez instalado lo ejecutamos
	- Con esta ejecución estamos limitando la memoria y cpus que va a utilizar el cluster

```shell
minikube --memory 4096 --cpus 2 start -p jenkins
```

- Instalamos kubectl

```shell
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Una vez descargado ejecutamos el binario
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Si nos falla la ejecución podemos hacer lo siguiente y volver a ejecutar
chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl

# Comprobamos la versión instalada
```

- Una vez instalado kubectl creamos un volumen y un namespace
	- Para ello utilizaremos los 2 archivos .yaml que hay en el directorio jenkins

```shell
kubectl create -f minikube/jenkins-namespace.yaml
kubectl create -f minikube/jenkins-volume.yaml
```

- Montamos el volumen
	- Para ello nos creamos un directorio data, donde se almacenaran los datos de nuestro jenkins de manera persistente

```shell
minikube mount ./data:/data/jenkins-volume
```
 
- Instalamos helm
	- Helm es un repositorio de imagenes de contenedores desde donde personalizaremos nuestra imagen de Jenkins

```shell
sudo snap install helm --classic
```

- Añadimos el repositorio de jenkins en helm

```shell
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm search repo jenkins
helm pull jenkins/jenkins
```

- Una vez instalado helm y añadido el repositorio, con el siguiente comando nos traemos un archivo yaml con todas las propiedades que podemos asignar a nuestro pod

```shell
helm show values jenkins/jenkins > values.yaml
```

- Modificaremos los siguientes valores en el fichero

```text
- helm show values jenkins/jenkins > values.yaml
- serviceType: ClusterIP → NodePort (línea 129)
- nodePort: 32000 (descomentar línea ~146)
- volumes [] →
volumes: (línea ~647)
- type: HostPath
hostPath: /var/run/docker.sock
mountPath: /var/run/docker.sock
- storageClass: → jenkins-pv (línea 818)
```

- Creamos nuestra imagen de jenkins personalizada con los valores anteriores modificados en values.yaml

```shell
helm upgrade --install jenkins jenkins/jenkins -n jenkins -f helm/jenkins-values.yaml --namespace jenkins-project

helm list --namespace jenkins-project
```

Nuestro jenkins debería estar funcional

- Los pods no resuelven dns (https://github.com/kubernetes/minikube/issues/1340) Troubleshooting
- Si tuviesemos algún problema para acceder hay que ejecutar el siguiente comando

```shell
$kubectl edit configmap coredns -n kube-system
# Cambiar
forward . /etc/resolv.conf {
max_concurrent 1000
}
# Por
forward . 8.8.8.8 8.8.4.4
```

## - Información Adicional

El problema más pertinaz encontrado ha sido Jenkins process is stuck,  las siguientes recomendaciones han servido de ayuda. 

This error means the Jenkins process is stuck on some command. Some suggestions:
- Upgrade all of your plugins and re-try.
- Make sure you've the right number of executors and jobs aren't stuck in the queue.
- If you're pulling the image (not your local), try adding alwaysPull true (next line to image).
- When using agent inside stage, remove the outer agent. See: JENKINS-63449.
- Execute org.jenkinsci.plugins.durabletask.BourneShellScript.LAUNCH_DIAGNOSTICS=true in Jenkins's Script Console to debug.
- When the process is stuck, SSH to Jenkins VM and run docker ps to see which command is running.
- Run docker ps -a to see the latest failed runs. In my case it tried to run cat next to custom CMD command set by container (e.g. ansible-playbook cat), which was the invalid command. The cat command is used by design. To change entrypoint, please read JENKINS-51307.
- If your container is still running, you can login to your Docker container by docker exec -it -u0 $(docker ps -ql) bash and run ps wuax to see what's doing.
- Try removing some global variables (could be a bug), see: parallel jobs not starting with docker workflow.

Ha sido de especial ayuda ejecutar:

**org.jenkinsci.plugins.durabletask.BourneShellScript.LAUNCH_DIAGNOSTICS=true** 

en la consola de scripts de Jenkins, la ejecución del comando ha permitido mostrar errores que antes permanecían ocultos, determinando que la ejecución del pipeline whalesay se detenía al no haber correspondencia al workspace entre servidor y nodo.  Para solucionar el problema se ha preparado un volumen para el workspace entre ambos contenedores.

- Los problemas derivados de los permisos de archivos se corrigen si establecemos correctamente UID y GID en el archivo dockerfile de la imagen Jenkins. El único requisito previo es crear el directorio $HOME/jenkins_home antes de lanzar los contenedores.

### Configurando un alias de host para SSH

- Para solucionar problemas de identificación con clave privada al acceder a servidores remotos mediante SSH o a repositorios  GIT con protocolo SSH, podemos establecer alias de host remotos indicando sus credenciales de acceso en el archivo config en el directorio .ssh de nuestro directorio de usuario. $HOME/.ssh/config, ejemplo
```shell
Host github.com
    Hostname github.com
    IdentityFile ~/.ssh/lifecycle.pem
    IdentitiesOnly yes
```

- No olvidar copiar la clave privada en la ruta indicada en IdentityFile y establecerle permisos de archivo 400.
- Con Host github.com establecemos un alias al host indicado en Hostname, en el ejemplo al dejar los valores igual no establecemos ningún alias. IdentityFile indica la ruta a la clave privada. Con IdentitiesOnly yes cambiamos el comportamiento de SSH, al iniciar una identificación renuncia a establecer la conexión probando primero con la clave privada por defecto, usualmente id_rsa

## - Instalación herramientas adicionales

### - OpenLens

- Software para visualizar de manera gráfica nuestros cluster de kubernetes. Permite cierta gestión de una manera mucho más comoda y rápida.

- Para instalar open lens debemos ir al github de open lens
https://github.com/MuhammedKalkan/OpenLens

- Una vez allí buscaremos el binario de la última versión estable
	- Nos dirigimos a assets y descargamos el paquete [OpenLens-6.3.0.amd64.deb](https://github.com/MuhammedKalkan/OpenLens/releases/download/v6.3.0/OpenLens-6.3.0.amd64.deb)

- Una vez descargado el paquete lo instalamos

```shell
sudo dpkg -i OpenLens-6.3.0.adm64.deb
```

### - Terminator

- Terminal con mucha más funcionalidad que la terminal tradicional
- Para instalarlo

```shell
sudo apt install terminator
```

- Comandos
	- Ctrl + Shift + E ->  nueva terminal a la derecha
	- Ctrl + Shift + O -> nueva terminal debajo
	- Ctrl + Shift + W -> cerrar terminal
	- Alt + Flecha dirección -> desplazarse entre terminales
	- Ctrl + Shift + Flecha dirección -> hacer ese terminal más grande o pequeño

### - Screen

- Utilidad para mandar procesos a segundo plano, esto nos permite poder cerrar terminal e incluso la sesión sin que esos procesos mueran

- Para instalarlo utilizaremos el siguiente comando

```shell
sudo apt install screen
```

- Una vez instalado ejecutamos el comnado screen -> comando a mandar a segundo plano -> Ctrl + A + D para enviar el proceso

- Con screen -r vemos los procesos que hay en segundo plano
- Con screen -r + "id proceso" -> recuperamos este proceso

### - LocalTunnel

- Utilidad que nos permite publicar un puerto de nuestra máquina a internet, para poder instalarla en primer lugar instalaremos npm

- Instalación npm

```shell
sudo apt install npm
```

- Desde npm instalamos la utilidad lt

```shell
sudo npm install -g localtunnel
```

- Con el siguiente comando publicamos nuestro puerto a internet

```shell
sudo npm install -g localtunnel
```
