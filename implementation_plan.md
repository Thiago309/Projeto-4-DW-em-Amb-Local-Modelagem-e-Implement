# Plano de Implementação - Infraestrutura Docker Multi-Banco e DW

Este plano visa estruturar o ambiente local do Data Warehouse para a AlfaMaq Manufatura S.A. utilizando o Docker Compose para gerar dois containers PostgreSQL (Origem/Fonte e Destino/Staging), permitindo a movimentação e transformação posterior de dados via Airbyte.

## User Review Required

> [!IMPORTANT]
> - Utilizaremos o **PostgreSQL 18-alpine** como padrão para os containers de banco de dados.
> - O container de origem (`postgres-fonte`) expõe a porta `5432` no host local.
> - O container de destino (`postgres-destino`) expõe a porta `5433` no host local para evitar qualquer conflito de portas no ambiente.
> - As senhas, usuários e credenciais estão definidos diretamente no arquivo [docker-compose.yml](GitHub/Projeto-4-DW-em-Amb-Local-Modelagem-e-Implement/docker-compose.yml).

## Proposed Changes

### Infraestrutura Docker

#### [MODIFY] [docker-compose.yml](GitHub/Projeto-4-DW-em-Amb-Local-Modelagem-e-Implement/docker-compose.yml)
*   Configuração de rede bridge comum (`dw-network`) para os dois bancos.
*   **postgres-fonte**:
    *   Container Name: `alfamaq_postgres_fonte`
    *   Porta: `5432:5432`
    *   Banco de dados: `alfamaq_dw`
    *   Volume persistente: `pgdata_fonte`
    *   Script de inicialização montado: [02-modelo-fisico-projeto1.sql](GitHub/Projeto-4-DW-em-Amb-Local-Modelagem-e-Implement/Projeto4/02-modelo-fisico-projeto1.sql) montado na pasta `/docker-entrypoint-initdb.d/` para criar a estrutura padrão de tabelas no banco de origem.
*   **postgres-destino**:
    *   Container Name: `alfamaq_postgres_destino`
    *   Porta: `5433:5432`
    *   Banco de dados: `alfamaq_staging` (área de staging inicial para cargas do Airbyte)
    *   Volume persistente: `pgdata_destino`

---

### Estrutura do Banco de Dados (DDL)

#### [MODIFY] [02-modelo-fisico-projeto1.sql](GitHub/Projeto-4-DW-em-Amb-Local-Modelagem-e-Implement/Projeto4/02-modelo-fisico-projeto1.sql)
*   Garante a criação do schema `dw`.
*   Criação das tabelas de dimensão: `dw.dim_produto`, `dw.dim_canal`, `dw.dim_data`, `dw.dim_cliente`.
*   Criação da tabela fato: `dw.fato_venda`.
*   Definição de chaves primárias e chaves estrangeiras garantindo a integridade referencial.

---

## Verification Plan

### Automated Tests
*   Validar a sintaxe do arquivo de composição executando:
    ```bash
    docker compose config
    ```
*   Subir o ambiente de banco local executando:
    ```bash
    docker compose up -d
    ```
*   Checar se os containers estão no status `Up` com o comando:
    ```bash
    docker compose ps
    ```

### Manual Verification
*   Utilizar um gerenciador de banco de dados (DBeaver, pgAdmin) para se conectar:
    *   Na porta **5432** (Fonte - banco `alfamaq_dw`) e listar as tabelas no schema `dw` para garantir a criação da estrutura.
    *   Na porta **5433** (Destino - banco `alfamaq_staging`) para validar o acesso da staging area.
