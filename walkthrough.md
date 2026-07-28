# Walkthrough de Implementação - Infraestrutura Docker Multi-Banco e DW

Implementamos com sucesso a nova infraestrutura multi-banco local utilizando o Docker Compose e o PostgreSQL 18, configurando um ambiente pronto para integração e pipelines de movimentação de dados via Airbyte.

---

## O que foi realizado

1. **Infraestrutura Docker (`docker-compose.yml`)**
   *   Configuração de dois servidores de banco de dados PostgreSQL rodando em isolamento e conectados na mesma rede virtual bridge (`dw-network`).
   *   Mapeamento de volumes distintos para persistência dos dados: `pgdata_fonte` e `pgdata_destino`.
   *   Exposição da porta `5432` no host local para a base de origem e porta `5433` para a base de destino, evitando quaisquer conflitos de portas locais.
   *   Automatização da inicialização do banco de origem (`postgres-fonte`) através da montagem direta do script de criação física do modelo estrela em `/docker-entrypoint-initdb.d/`.

2. **Criação do Modelo Dimensional**
   *   O script físico de criação de tabelas [02-modelo-fisico-projeto1.sql](GitHub/Projeto-4-DW-em-Amb-Local-Modelagem-e-Implement/Projeto4/02-modelo-fisico-projeto1.sql) inicializa e cria a estrutura do schema `dw`.
   *   O modelo estrela simplificado é composto por:
       *   **4 Dimensões**: `dw.dim_produto`, `dw.dim_canal`, `dw.dim_data`, `dw.dim_cliente`.
       *   **1 Tabela Fato**: `dw.fato_venda`.

---

## Como foi verificado

1. **Validação de Sintaxe do Compose**
   ```bash
   docker compose config
   ```
   A configuração foi validada com sucesso, gerando o arquivo de saída sem erros estruturais ou de indentação do arquivo YAML.

2. **Status dos Containers**
   Após subir os containers, a execução foi validada listando os serviços ativos:
   ```bash
   docker compose ps
   ```
   Os containers `alfamaq_postgres_fonte` (porta `5432`) e `alfamaq_postgres_destino` (porta `5433`) foram inicializados no estado `Up` com sucesso.

---

## Como Conectar aos Bancos de Dados

*   **Banco de Origem (Fonte)**
    *   **Host:** `localhost` (ou `127.0.0.1`)
    *   **Porta:** `5432`
    *   **Database:** `alfamaq_dw`
    *   **Usuário / Senha:** `alfamaq_admin` / `alfamaq_pass`

*   **Banco de Destino (Staging Area)**
    *   **Host:** `localhost` (ou `127.0.0.1`)
    *   **Porta:** `5433`
    *   **Database:** `alfamaq_staging`
    *   **Usuário / Senha:** `alfamaq_admin` / `alfamaq_pass`

---

## Instalação e Acesso ao Airbyte OSS

A plataforma **Airbyte OSS** foi instalada e implantada com sucesso via Docker Compose em ambiente WSL2.

*   **URL da Interface Web:** [http://localhost:8000](http://localhost:8000)
*   **Usuário Padrão:** `airbyte`
*   **Senha Padrão:** `password`
*   **Serviços Ativos em Execução:**
    *   `airbyte-proxy` (Portas `8000`, `8001`)
    *   `airbyte-server`
    *   `airbyte-webapp`
    *   `airbyte-worker`
    *   `airbyte-cron`
    *   `airbyte-db` (PostgreSQL interno da Airbyte)
    *   `airbyte-temporal` (Engine de orquestração de workflows)

### Comandos de Controle do Airbyte
No terminal WSL2, acesse o diretório `/home/dataengineer2025/airbyte`:
*   **Verificar status dos contêineres:** `docker compose ps`
*   **Verificar logs em tempo real:** `docker compose logs -f`
*   **Parar o Airbyte:** `docker compose stop`
*   **Reiniciar o Airbyte:** `docker compose start`
