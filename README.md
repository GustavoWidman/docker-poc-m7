# docker-poc-m7

![Python](https://img.shields.io/badge/python-3.13-blue?logo=python&logoColor=white)
![Docker Hub](https://img.shields.io/badge/dockerhub-r3dlust%2Fdocker--poc--m7-blue?logo=docker&logoColor=white)
![Sanic](https://img.shields.io/badge/sanic-25.3.0-ff0080?logo=sanic&logoColor=white)
![Nix](https://img.shields.io/badge/nix-flakes-5277C3?logo=nixos&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green)

## descrição do projeto

este projeto consiste em uma aplicação web desenvolvida em python utilizando o framework sanic para servir uma página html estática contendo meu currículo profissional. a aplicação foi containerizada utilizando docker, com uma imagem baseada em alpine linux e o gerenciador de pacotes uv para instalação de dependências. além disso, foi desenvolvido um toolkit em nushell (toolkit.nu) que facilita o build, execução local e push da imagem para o dockerhub. o projeto demonstra conhecimentos em desenvolvimento web, containerização, automação de processos com shell scripting e publicação de imagens em registries públicos. a interface do currículo possui um tema moderno e escuro, com animações suaves e design responsivo, utilizando gradientes amarelo-laranja para destacar elementos importantes.

## link da imagem no dockerhub

[https://hub.docker.com/r/r3dlust/docker-poc-m7](https://hub.docker.com/r/r3dlust/docker-poc-m7)

---

## como executar a aplicação

### opção 1: executar com a imagem do dockerhub (recomendado)

esta é a forma mais rápida de executar a aplicação. você só precisa ter o docker instalado.

```bash
docker run -p 8080:80 r3dlust/docker-poc-m7:latest
```

após executar o comando, acesse [http://localhost:8080](http://localhost:8080) no seu navegador.

**nota:** você pode alterar a porta `8080` para qualquer outra porta disponível no seu sistema.

---

### opção 2: executar com nushell (toolkit)

se você possui [nushell](https://www.nushell.sh/) instalado, pode utilizar o toolkit para facilitar o gerenciamento do container:

#### 2.1. clonar o repositório

```bash
git clone https://github.com/GustavoWidman/docker-poc-m7.git
cd docker-poc-m7
```

#### 2.2. dar o "use" no toolkit

```bash
overlay use -p toolkit.nu as toolkit
```

#### 2.3. executar com toolkit

```bash
# comandos de auxilio
toolkit --help
toolkit run --help

# executar em modo interativo (foreground)
toolkit run

# executar em segundo plano (background)
toolkit run --detach

# executar em porta customizada
toolkit run --port 3000
```

acesse [http://localhost:8080](http://localhost:8080) (ou a porta que você especificou) no seu navegador.

#### comandos adicionais do toolkit

```bash
# apenas construir a imagem
toolkit build

# construir e fazer push para o dockerhub
toolkit push --registry seu-usuario/docker-poc-m7:latest
```

---

### opção 3: executar sem nushell (build manual)

se você não possui nushell instalado, pode executar os comandos docker manualmente:

#### 3.1. clonar o repositório

```bash
git clone https://github.com/GustavoWidman/docker-poc-m7.git
cd docker-poc-m7
```

#### 3.2. construir a imagem

```bash
docker build -t docker-poc-m7:latest .
```

#### 3.3. executar o container

```bash
docker run -p 8080:80 docker-poc-m7:latest
```

acesse [http://localhost:8080](http://localhost:8080) no seu navegador.

---

### opção 4: executar sem docker (desenvolvimento local)

se você não possui docker instalado mas quer testar a aplicação localmente:

#### 4.1. pré-requisitos

- python 3.13 ou superior
- pip ou uv (gerenciador de pacotes python)

#### 4.2. clonar o repositório

```bash
git clone https://github.com/GustavoWidman/docker-poc-m7.git
cd docker-poc-m7
```

#### 4.3. instalar dependências

usando pip:
```bash
pip install -r requirements.txt
```

ou usando uv (recomendado):
```bash
# instalar uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# criar venv
uv venv .venv

# ativar venv
source .venv/bin/activate

# ativar venv (nushell)
# overlay use .venv/bin/activate.nu

# instalar dependências
uv pip install -r requirements.txt
```

#### 4.4. executar a aplicação

```bash
# usando uv
uv run sanic -H 0.0.0.0 -p 8080 src.main

# ou usando sanic diretamente
sanic -H 0.0.0.0 -p 8080 src.main
```

acesse [http://localhost:8080](http://localhost:8080) no seu navegador.

---

### opção 5: executar com nix (ambiente de desenvolvimento)

se você usa [nix](https://nixos.org/) com flakes habilitado, pode entrar em um ambiente de desenvolvimento com todas as dependências necessárias:

#### 5.1. clonar o repositório

```bash
git clone https://github.com/GustavoWidman/docker-poc-m7.git
cd docker-poc-m7
```

#### 5.2. entrar no devshell

```bash
nix develop
```

isso irá criar um ambiente isolado com:
- python 3.13
- nushell
- docker
- uv (gerenciador de pacotes python)

#### 5.3. executar a aplicação

após entrar no devshell, você pode usar qualquer uma das opções anteriores (toolkit, docker manual ou execução local).

**exemplo com toolkit:**
```bash
nu # entrar em uma shell de nushell
overlay use -p toolkit.nu as toolkit # ativar toolkit
toolkit run # rodar
```

**exemplo sem docker:**
```bash
uv venv .venv # criar venv
source .venv/bin/activate # ativar venv
# overlay use .venv/bin/activate.nu # ativar venv (nushell)
uv pip install -r requirements.txt # baixar dependências
uv run sanic -H 0.0.0.0 -p 8080 src.main # rodar aplicação
```

---

## estrutura do projeto

```
docker-poc-m7/
├── Dockerfile              # definição da imagem docker
├── requirements.txt        # dependências python
├── toolkit.nu              # script nushell para automação
├── flake.nix               # configuração nix para devshell
├── .dockerignore           # arquivos ignorados no build
├── .gitignore              # arquivos ignorados pelo git
├── LICENSE                 # licença MIT
├── src/
│   └── main.py             # aplicação sanic (servidor web)
└── public/
    └── index.html          # currículo em html
```

## tecnologias utilizadas

- **python 3.13** - linguagem de programação
- **sanic** - framework web assíncrono
- **docker** - containerização
- **alpine linux** - imagem base leve
- **uv** - gerenciador de pacotes python moderno e rápido
- **nushell** - shell moderno para automação (opcional)
- **nix** - gerenciador de pacotes e ambiente de desenvolvimento reproduzível (opcional)

## sobre o dockerfile

a imagem docker utiliza:
- imagem base: `ghcr.io/astral-sh/uv:python3.13-alpine`
- porta exposta: 80
- gerenciador de pacotes: uv (mais rápido que pip)
- comando de inicialização: `uv run sanic -H 0.0.0.0 -p 80 src.main`

## licença

este projeto está licenciado sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para mais detalhes.
