# Walkthrough de Implementação - Data Warehouse AlfaMaq S.A.

Implementamos com sucesso a infraestrutura do Data Warehouse local utilizando Docker Compose com PostgreSQL 18, e executamos a criação do esquema dimensional completo para a **AlfaMaq Manufatura S.A.**.

## O que foi realizado

1. **Infraestrutura Docker (`docker-compose.yml`)**
   - Configuração de um banco de dados PostgreSQL 18 rodando em ambiente local.
   - Criação de volumes de dados locais (`pgdata`) para garantir a persistência das informações.
   - Mapeamento da pasta `./sql` para a inicialização do banco (`/docker-entrypoint-initdb.d`), o que automatiza a criação do esquema físico.

2. **Esquema Dimensional (`sql/create_tables.sql`)**
   - Criação física de **9 dimensões** (`Dim_Regiao`, `Dim_Tempo`, `Dim_Produto`, `Dim_Materia_Prima`, `Dim_Cliente`, `Dim_Fornecedor`, `Dim_Equipamento_Processo`, `Dim_Canal_Vendas`, `Dim_Tipo_Manutencao`).
   - Criação física de **6 tabelas fato** (`Fato_Producao`, `Fato_Vendas`, `Fato_Compras_Insumos`, `Fato_Estoque_Snapshot`, `Fato_Manutencao`, `Fato_Financeiro`).
   - Definições estritas de Primary Keys (PKs), Foreign Keys (FKs) e restrições de integridade.

## Como foi verificado

Rodamos a validação de criação física das tabelas dentro do container PostgreSQL com o comando `\dt`. O banco de dados retornou todas as 15 tabelas criadas no schema `public` sob propriedade do usuário administrador:

```
 Schema |           Name           | Type  |     Owner     
--------+--------------------------+-------+---------------
 public | dim_canal_vendas         | table | alfamaq_admin
 public | dim_cliente              | table | alfamaq_admin
 public | dim_equipamento_processo | table | alfamaq_admin
 public | dim_fornecedor           | table | alfamaq_admin
 public | dim_materia_prima        | table | alfamaq_admin
 public | dim_produto              | table | alfamaq_admin
 public | dim_regiao               | table | alfamaq_admin
 public | dim_tempo                | table | alfamaq_admin
 public | dim_tipo_manutencao      | table | alfamaq_admin
 public | fato_compras_insumos     | table | alfamaq_admin
 public | fato_estoque_snapshot    | table | alfamaq_admin
 public | fato_financeiro          | table | alfamaq_admin
 public | fato_manutencao          | table | alfamaq_admin
 public | fato_producao            | table | alfamaq_admin
 public | fato_vendas              | table | alfamaq_admin
(15 rows)
```

## Como Conectar ao Banco de Dados

* **SGBD:** PostgreSQL (v18)
* **Host:** `localhost` (ou `127.0.0.1`)
* **Porta:** `5432`
* **Database (Banco):** `alfamaq_dw`
* **Usuário:** `alfamaq_admin`
* **Senha:** `alfamaq_pass`
