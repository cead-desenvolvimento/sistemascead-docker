## Introdução

Este é um tutorial para implantação do sistema do CEAD com Docker. São 3 _containers_:

-   PostgreSQL 17
-   _Backend_ Django, executado via gunicorn
-   _Frontend_, servido via nginx

Há um _proxy_ reverso no _host_, via nginx, que encaminha as requisições para o _frontend_ e será responsável também pelo _site_ do CEAD.

## Antes de começar

Alguns arquivos com informações sensíveis não estão neste projeto:

-   `.env` da pasta `sistemascead-docker` (criação de senha da base de dados)
-   `.env` da pasta `sistemascead-docker/sistemascead-backend/backend/cead/` (configurações sensíveis do Django)

O certificado SSL para o _proxy_ reverso é necessário, e deve ser copiado do ambiente de produção.

## Instalação dos pacotes necessários

Depois de instalar o GNU/Linux Alpine, descomente a linha com `community` em `/etc/apk/repositories`

```bash
vi /etc/apk/repositories
```

Atualize e baixe os pacotes necessários

```bash
apk update
apk add docker docker-compose dma git logrotate nfs-utils nginx
rc-update add docker boot
rc-update add nginx boot
service docker start
```

## Clonar os repositórios

Clonar, na ordem indicada, os repositórios:

-   Este repositório (este README.md + Dockerfiles + compose para _deploy_ dos sistemas CEAD);
-   _Backend_ (aplicação sistemas CEAD);
-   _Frontend_ (_front_ do sistemas CEAD).

```bash
cd /srv
git clone https://github.com/cead-desenvolvimento/sistemascead-docker.git
cd /srv/sistemascead-docker/backend
git clone https://github.com/cead-desenvolvimento/sistemascead-backend.git
cd /srv/sistemascead-docker/frontend
git clone https://github.com/cead-desenvolvimento/sistemascead-frontend.git
```

## Cópia dos `.env`

Coloque o primeiro `.env` na pasta `/srv/sistemascead-docker`. Exemplo do arquivo:

```conf
DB_USER=sistemascead
DB_PASSWORD=secreto
DB_NAME=sistemascead
```

Coloque o segundo `.env` na pasta `/srv/sistemascead-docker/backend/sistemascead-backend/backend/cead/`. Exemplo do arquivo:

```conf
DJANGO_DEBUG=False
DJANGO_SECRET_KEY=secreto
ALLOWED_HOSTS=127.0.0.1
POSTGRES_USER=sistemascead
POSTGRES_PASSWORD=secreto
POSTGRES_DB=sistemascead
POSTGRES_HOST=sistemascead-database
POSTGRES_PORT=5432

EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=naoresponda.cead@ufjf.br
EMAIL_HOST_PASSWORD=secreto
DEFAULT_FROM_EMAIL=naoresponda.cead@ufjf.br
```

## Criar os _containers_

-   Para a criação de um _container_ **zerado**, copiando um _dump_ inicial, copie `sistemascead.sql` para a pasta `/srv/sistemascead-docker/database`, e então:

```bash
cd /srv/sistemascead-docker
docker compose build
docker compose up -d
```
