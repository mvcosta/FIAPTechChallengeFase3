# FiapTechChallenge

Olá, bem-vindo ao repositório do projeto da FIAP!

Este arquivo README irá orientar você sobre como baixar e executar o aplicativo por meio do Kubernetes.

## Pré-requisitos

Antes de rodar o projeto, será necessário ter um cluster do Kubernetes rodando em sua máquina.

## Inicie um cluster do Kubernetes

### Utilizando Docker Desktop

1. Instale o Docker Desktop:  
   Siga as instruções específicas para o seu sistema no [site oficial de download do Docker Desktop](https://www.docker.com/products/docker-desktop/).

2. Habilitando o Kubernetes no Docker Desktop:

   - Abra as configurações do Docker Desktop.
   - Navegue até a seção "Kubernetes".
   - Marque a opção "Enable Kubernetes".
   - Clique em "Apply & Restart" para aplicar as configurações.

3. Verificando a Instalação:  
    Abra o terminal do PowerShell ou do Prompt de Comando e execute o seguinte comando para verificar se o Kubernetes está em execução:  
   `kubectl cluster-info`

### Usando Minikube

1. Instale o Minikube:  
   Siga as instruções de instalação para o seu sistema no [site oficial do Minikube](https://minikube.sigs.k8s.io/docs/start/).

2. Instale o kubectl ou utilize o próprio minikube:  
   O kubectl é a ferramenta de linha de comando para gerenciar clusters Kubernetes. Você pode optar por instalar o kubectl separadamente ou utilizar o kubectl integrado ao Minikube. Exemplo de uso com o Minikube:
   `minikube kubectl --`

3. Inicie o Cluster com Minikube:  
    Abra um terminal e execute o seguinte comando para iniciar um cluster Kubernetes com o Minikube:
   `minikube start`

4. Verificando a Instalação:  
   Após a inicialização, você pode verificar o status do cluster usando:  
   `kubectl cluster-info` ou `minikube kubectl -- cluster-info`

## Baixando o Repositório

Primeiro, vamos clonar o repositório para a sua máquina local. Abra o terminal e execute o seguinte comando:

`git clone https://github.com/negospo/FiapTechChallengeFase2.git`

Isso irá baixar o repositório para a pasta `FiapTechChallengeFase2` em seu diretório atual.

## Realize o deployment

1. Navega até a pasta correta:  
   Certifique-se de estar no diretório raiz do projeto. Onde você possa visualizar a pasta /kubernetes com os arquivos YAML.

2. Aplicando os Arquivos YAML:  
   Use o comando `kubectl apply -f kubernetes` para aplicar os arquivos YAML no cluster.

3. Verificando o Estado:  
   Você pode verificar o estado dos recursos recém-criados usando comandos como `kubectl get all`, `kubectl get pods`, `kubectl get services`, etc.

## Acessando a aplicação

Após a inicialização dos pods, você poderá acessar a aplicação.

- Caso você esteja utilizando **Docker Desktop**:  
  Acesse a aplicação em 127.0.0.1 ou localhost (A API e o Database podem levar até 2 minuto para ficarem disponíveis após o kubectl apply)

- Caso você esteja utilizando **minikube**:  
  Acesse a aplicação com o comando: `minikube service app-service`
