# Plano de Implementação - Infraestrutura Local e DDL do Data Warehouse

Este plano visa estruturar o ambiente local do Data Warehouse para a **AlfaMaq Manufatura S.A.** usando Docker Compose com PostgreSQL e criar os scripts DDL (Data Definition Language) correspondentes.

## User Review Required

> [!IMPORTANT]
> - Utilizaremos o **PostgreSQL 15+** como o SGBD padrão para o Data Warehouse devido ao seu suporte robusto a SQL, indexação e facilidade de deploy em Docker.
> - O container exporá a porta `5432` no host. Caso você já possua um serviço de PostgreSQL rodando localmente na porta `5432`, precisaremos alterá-la no host (ex: para `5433`). Por favor, confirme se a porta `5432` está livre.
> - As senhas e credenciais do banco serão expostas inicialmente em variáveis de ambiente padrão no `docker-compose.yml` para facilitar a execução local.

## Proposed Changes

### Infraestrutura Docker

#### [MODIFY] [docker-compose.yml](file:///c:/Users/karer/OneDrive/Documentos/GitHub/Projeto-4-DW-em-Amb-Local-Modelagem-e-Implement/docker-compose.yml)
- Configuração do Docker Compose contendo o serviço `postgres`.
- Volume mapeado para persistência local dos dados (`pgdata`).
- Mapeamento da pasta SQL local (`./sql`) para a pasta de inicialização do container (`/docker-entrypoint-initdb.d`), executando automaticamente nossos scripts de criação de tabelas na primeira inicialização.

---

### Estrutura do Banco de Dados (DDL e Scripts SQL)

#### [MODIFY] [create_tables.sql](file:///c:/Users/karer/OneDrive/Documentos/GitHub/Projeto-4-DW-em-Amb-Local-Modelagem-e-Implement/sql/create_tables.sql)
- Criação das tabelas de dimensão: `Dim_Regiao`, `Dim_Tempo`, `Dim_Produto`, `Dim_Materia_Prima`, `Dim_Cliente`, `Dim_Fornecedor`, `Dim_Equipamento_Processo`, `Dim_Canal_Vendas`, `Dim_Tipo_Manutencao`.
- Criação das tabelas fato: `Fato_Producao`, `Fato_Vendas`, `Fato_Compras_Insumos`, `Fato_Estoque_Snapshot`, `Fato_Manutencao`, `Fato_Financeiro`.
- Definição de chaves primárias, estrangeiras e restrições de integridade.

#### [MODIFY] [insert.sql](file:///c:/Users/karer/OneDrive/Documentos/GitHub/Projeto-4-DW-em-Amb-Local-Modelagem-e-Implement/sql/insert.sql)
- Scripts de carga estática de teste simulando dados sujos (dirty data) para validar o comportamento de ETL.
- Geração dinâmica da dimensão de tempo `Dim_Tempo` via stored procedure temporária de apoio.

#### [MODIFY] [procedure.sql](file:///c:/Users/karer/OneDrive/Documentos/GitHub/Projeto-4-DW-em-Amb-Local-Modelagem-e-Implement/sql/procedure.sql)
- Implementação das stored procedures de carga e população das tabelas de dimensões e fatos com regras matemáticas de negócio corretas.

---

## Verification Plan

### Automated Tests
- Validar se o arquivo `docker-compose.yml` está sintaticamente correto executando `docker-compose config`.
- Inicializar o ambiente local executando `docker compose up -d --build`.
- Verificar se as tabelas foram criadas com sucesso conectando ao container via `psql` e listando as tabelas (`\dt`).

### Manual Verification
- O usuário poderá se conectar ao banco de dados usando ferramentas visuais como DBeaver ou pgAdmin utilizando as credenciais definidas.
