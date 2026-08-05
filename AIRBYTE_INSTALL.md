# Guia de Instalação do Airbyte no WSL2

> **Referência oficial:** [docs.airbyte.com/using-airbyte/getting-started/oss-quickstart](https://docs.airbyte.com/using-airbyte/getting-started/oss-quickstart)

---

## ⚠️ Aviso Importante

O método de instalação via **Docker Compose** foi **oficialmente depreciado** pelo Airbyte.
O método atual e recomendado utiliza o **`abctl`** (Airbyte Control), que gerencia automaticamente um cluster Kubernetes local dentro do Docker.

---

## ✅ Pré-requisitos

| Requisito | Detalhe |
|---|---|
| **Sistema Operacional** | WSL2 com Ubuntu (ou outra distro Linux) |
| **RAM** | Mínimo **8 GB** alocados para o WSL2 |
| **CPUs** | Mínimo **2 CPUs** (4+ recomendado para melhor desempenho) |
| **Docker Desktop** | Instalado no Windows com **integração WSL2 habilitada** |
| **Git** | Para clonar o repositório do Airbyte |

### Configurar memória do WSL2 (se necessário)

Crie ou edite o arquivo `%USERPROFILE%\.wslconfig` no Windows:

```ini
[wsl2]
memory=8GB
processors=4
```

Reinicie o WSL2 após salvar:
```powershell
wsl --shutdown
```

---

## 📦 Parte 1 — Clonar o repositório do Airbyte (GitHub)

Abra o terminal do WSL2 e execute:

```bash
git clone https://github.com/airbytehq/airbyte.git
cd airbyte
```

> O repositório contém configurações de conectores, exemplos e documentação.
> A instalação em si é feita via `abctl`, mas o clone é útil como referência.

---

## 🛠️ Parte 2 — Instalar o `abctl`

O `abctl` é a ferramenta de linha de comando oficial do Airbyte para gerenciar instâncias locais.

### Método rápido (recomendado para WSL2/Linux):

```bash
curl -LsfS https://get.airbyte.com | bash -
```

Quando solicitado, informe sua senha de usuário.
Ao final, você verá a mensagem: `abctl install succeeded.`

### Verificar a instalação:

```bash
abctl version
```

---

## 🚀 Parte 3 — Instalar e Iniciar o Airbyte

Certifique-se de que o **Docker Desktop está aberto e rodando** no Windows.

### Instalação padrão:

```bash
abctl local install
```

### Instalação em modo de baixo recurso (2 CPUs / 8 GB RAM):

```bash
abctl local install --low-resource-mode
```

### Com logs detalhados (para debug):

```bash
abctl local install -v
```

> ⏳ O processo pode levar de **5 a 15 minutos** dependendo da velocidade da internet e do hardware.
> O `abctl` irá criar automaticamente um cluster Kubernetes dentro do Docker via `kind`.

---

## 🔐 Parte 4 — Obter Credenciais de Acesso

Após a instalação concluir, recupere as credenciais geradas automaticamente:

```bash
abctl local credentials
```

A saída será algo como:

```
Email:    admin@example.com
Password: <senha-gerada>
```

---

## 🌐 Parte 5 — Acessar a Interface do Airbyte

Abra o navegador no Windows e acesse:

```
http://localhost:8000
```

Use as credenciais obtidas no passo anterior para fazer login.

---

## 🔌 Parte 6 — Configurar Conectores para este Projeto

### Conector de Origem (Source) — PostgreSQL Fonte

Configure no Airbyte com os seguintes parâmetros:

| Campo | Valor |
|---|---|
| **Host** | `host.docker.internal` |
| **Porta** | `5432` |
| **Database** | `alfamaq_dw` |
| **Username** | `alfamaq_admin` |
| **Password** | `alfamaq_pass` |
| **Replication Method** | `Logical Replication (CDC)` ou `Standard` |
| **SSL** | `disable` |

### Conector de Destino (Destination) — PostgreSQL Staging

| Campo | Valor |
|---|---|
| **Host** | `host.docker.internal` |
| **Porta** | `5433` |
| **Database** | `alfamaq_staging` |
| **Username** | `alfamaq_admin` |
| **Password** | `alfamaq_pass` |
| **SSL** | `disable` |

> **Nota:** O `host.docker.internal` permite que o Airbyte (rodando no cluster Kubernetes dentro do Docker) acesse os containers do PostgreSQL do seu projeto.

---

## 🔧 Comandos Úteis do `abctl`

```bash
# Verificar status da instalação
abctl local status

# Parar o Airbyte
abctl local uninstall

# Reiniciar o Airbyte
abctl local install

# Verificar pods do Kubernetes
kubectl get pods -n airbyte-abctl

# Verificar logs de um pod específico
kubectl logs -n airbyte-abctl <nome-do-pod>
```

---

## 🩺 Solução de Problemas

### ❌ Erro: `Readiness probe failed: HTTP probe failed with statuscode: 503`

Aguarde a instalação continuar — esse aviso é comum e normalmente se resolve sozinho.
Se persistir, considere usar o `--low-resource-mode`.

### ❌ Não consigo acessar `localhost:8000`

Verifique se o port-forward está ativo:

```bash
kubectl get svc -n airbyte-abctl
```

Reinicie o port-forward manualmente se necessário:

```bash
kubectl port-forward svc/airbyte-airbyte-webapp-svc 8000:80 -n airbyte-abctl
```

### ❌ Airbyte não conecta ao PostgreSQL

1. Confirme que os containers estão rodando:
   ```bash
   docker ps
   ```
2. Use `host.docker.internal` como host (não `localhost`).
3. Verifique se o `wal_level=logical` está ativo no `postgres-fonte`:
   ```sql
   SHOW wal_level;
   ```

---

## 📁 Estrutura do Projeto

```
Projeto-4-DW-em-Amb-Local-Modelagem-e-Implement/
├── docker-compose.yml          # Infraestrutura PostgreSQL (Fonte + Staging)
├── AIRBYTE_INSTALL.md          # Este guia
├── README.md                   # Documentação do projeto
├── dw_schema.md                # Esquema dimensional
├── Projeto4/
│   └── 02-modelo-fisico-projeto1.sql  # DDL das tabelas do DW
└── sql/                        # Scripts SQL adicionais
```

---

## 🔗 Referências

- [Documentação Oficial Airbyte OSS Quickstart](https://docs.airbyte.com/using-airbyte/getting-started/oss-quickstart)
- [Repositório abctl no GitHub](https://github.com/airbytehq/abctl)
- [Repositório Airbyte no GitHub](https://github.com/airbytehq/airbyte)
- [Documentação Docker Desktop WSL2](https://docs.docker.com/desktop/wsl/)
