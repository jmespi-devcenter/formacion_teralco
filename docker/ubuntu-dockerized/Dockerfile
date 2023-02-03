ARG UBUNTU_VER=22.04
FROM ubuntu:${UBUNTU_VER}

ARG TERRAFORM_VER=1.3.3
ARG VELERO_VER=1.10.1
ARG AZURE_CLI_VER=2.44.1
ARG KUBECTL_VER=
ARG KUBE_LOGIN_VER=

#Actualizamos antes de comenzar a instalar
RUN apt update

RUN mkdir /app

#Prerequisitos
RUN apt install software-properties-common gnupg2 curl unzip apt-utils wget curl git podman -y

RUN apt update
#TERRAFORM
#Descarga versión terraform
RUN mkdir /app/terraform
WORKDIR /app/terraform

RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_amd64.zip
RUN unzip terraform_${TERRAFORM_VER}_linux_adm64.zip
RUN mv terraform /usr/local/bin/

#Borramos el .zip
RUN rm -r *.zip

#AZURE-CLI
#Descarga version azure cli
RUN mkdir /app/azure-cli
WORKDIR /app/azure-cli

#Prerequisitos
RUN apt install ca-certificates apt-transport-https lsb-release gnupg -y

RUN mkdir -p /etc/apt/keyrings
RUN curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/keyrings/microsoft.gpg > /dev/null
RUN chmod go+r /etc/apt/keyrings/microsoft.gpg
RUN AZ_REPO=$(lsb_release -cs) echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list

RUN apt update

#Descarga version 
RUN apt install azure-cli=${AZURE_CLI_vER}-1~jammy -y


#KUBE LOGIN
#mover el contenido del .zip a /usr/local/bin

#VELERO
RUN mkdir /app/velero
WORKDIR /app/velero
RUN wget https://github.com/vmware-tanzu/velero/releases/download/v${VELERO_VER}-rc.1/velero-v${VELERO_VER}-rc.1-linux-amd64.tar.gz


