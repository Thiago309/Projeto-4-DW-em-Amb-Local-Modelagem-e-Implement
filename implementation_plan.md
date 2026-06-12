# Plano de Implementação - Infraestrutura Local e DDL do Data Warehouse

Este plano visa estruturar o ambiente local do Data Warehouse para a **AlfaMaq Manufatura S.A.** usando Docker Compose com PostgreSQL e criar os scripts DDL (Data Definition Language) correspondentes.

## User Review Required

> [!IMPORTANT]
> - Utilizaremos o **PostgreSQL 15** como o SGBD padrão para o Data Warehouse devido ao seu suporte robusto a SQL, indexação e facilidade de deploy em Docker.
> - O container exporá a porta `5432` no host. Caso você já possua um serviço de PostgreSQL rodando localmente na porta `5432`, precisaremos alterá-la no host (ex: para `5433`). Por favor, confirme se a porta `5432` está livre.
> - As senhas e credenciais do banco serão expostas inicialmente em variáveis de ambiente padrão no `docker-compose.yml` para facilitar a execução local.

## Proposed Changes

### Infraestrutura Docker

#### [NEW] [docker-compose.yml](file:///c:/Users/thiago.batista/Documents/GitHub/Projeto-4-DW-em-Amb-Local-Modelagem-e-Implement/docker-compose.yml)
Criar a configuração do Docker Compose contendo:
- Serviço `postgres` (PostgreSQL 15).
- Volume mapeado para persistência local dos dados (`pgdata`).
- Mapeamento da pasta SQL local (`./sql`) para a pasta de inicialização do container (`/docker-entrypoint-initdb.d`), o que executará automaticamente nossos scripts de criação de tabelas na primeira inicialização.

### Estrutura do Banco de Dados (DDL)

#### [NEW] [create_tables.sql](file:///c:/Users/thiago.batista/Documents/GitHub/Projeto-4-DW-em-Amb-Local-Modelagem-e-Implement/sql/create_tables.sql)
Criar o script DDL no diretório `sql/` contendo:
- Criação das tabelas de dimensão: `Dim_Regiao`, `Dim_Tempo`, `Dim_Produto`, `Dim_Materia_Prima`, `Dim_Cliente`, `Dim_Fornecedor`, `Dim_Equipamento_Processo`, `Dim_Canal_Vendas`, `Dim_Tipo_Manutencao`.
- Criação das tabelas fato: `Fato_Producao`, `Fato_Vendas`, `Fato_Compras_Insumos`, `Fato_Estoque_Snapshot`, `Fato_Manutencao`, `Fato_Financeiro`.
- Definição de chaves primárias, estrangeiras e restrições de integridade.

## Verification Plan

### Automated Tests
- Validar se o arquivo `docker-compose.yml` está sintaticamente correto executando `docker-compose config`.
- Inicializar o ambiente local executando `docker compose up -d --build`.
- Verificar se as tabelas foram criadas com sucesso conectando ao container via `psql` e listando as tabelas (`\dt`).

### Manual Verification
- O usuário poderá se conectar ao banco de dados usando ferramentas visuais como DBeaver ou pgAdmin utilizando as credenciais definidas.
