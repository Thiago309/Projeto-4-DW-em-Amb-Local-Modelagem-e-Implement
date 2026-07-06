-- Script DDL de Criação do Schema Dimensional para o Data Warehouse da AlfaMaq Manufatura S.A.
-- Banco de Dados de Destino: PostgreSQL 15+

-- ==========================================
-- 1. LIMPEZA DO SCHEMA (DROPS) - Garantia de Idempotência
-- ==========================================

DROP TABLE IF EXISTS Fato_Financeiro CASCADE;
DROP TABLE IF EXISTS Fato_Manutencao CASCADE;
DROP TABLE IF EXISTS Fato_Estoque_Snapshot CASCADE;
DROP TABLE IF EXISTS Fato_Compras_Insumos CASCADE;
DROP TABLE IF EXISTS Fato_Vendas CASCADE;
DROP TABLE IF EXISTS Fato_Producao CASCADE;

DROP TABLE IF EXISTS Dim_Regiao CASCADE;
DROP TABLE IF EXISTS Dim_Cliente CASCADE;
DROP TABLE IF EXISTS Dim_Fornecedor CASCADE;
DROP TABLE IF EXISTS Dim_Tempo CASCADE;
DROP TABLE IF EXISTS Dim_Produto CASCADE;
DROP TABLE IF EXISTS Dim_Materia_Prima CASCADE;
DROP TABLE IF EXISTS Dim_Equipamento_Processo CASCADE;
DROP TABLE IF EXISTS Dim_Canal_Vendas CASCADE;
DROP TABLE IF EXISTS Dim_Tipo_Manutencao CASCADE;

-- ==========================================
-- 2. CRIAÇÃO DAS TABELAS DE DIMENSÃO (DIM)
-- ==========================================

-- Dim_Regiao
CREATE TABLE Dim_Regiao (
    SK_Regiao SERIAL PRIMARY KEY,
    Cidade VARCHAR(100) NOT NULL,
    Estado VARCHAR(50) NOT NULL,
    Pais VARCHAR(100) NOT NULL,
    Macroregiao VARCHAR(100) NOT NULL
);

-- Dim_Tempo
CREATE TABLE Dim_Tempo (
    SK_Tempo INT PRIMARY KEY, -- Formato: AAAAMMDD
    Data DATE NOT NULL,
    Dia INT NOT NULL,
    Mes INT NOT NULL,
    Ano INT NOT NULL,
    Flag_Fim_Semana BOOLEAN NOT NULL
);

-- Dim_Produto
CREATE TABLE Dim_Produto (
    SK_Produto SERIAL PRIMARY KEY,
    NK_Produto VARCHAR(50) NOT NULL UNIQUE,
    Nome_Produto VARCHAR(150) NOT NULL,
    Descricao TEXT,
    Categoria VARCHAR(100) NOT NULL,
    Subcategoria VARCHAR(100) NOT NULL,
    Unidade_Medida VARCHAR(20) NOT NULL,
    Preco_Sugerido NUMERIC(12,2) NOT NULL,
    Custo_Padrao NUMERIC(12,2) NOT NULL
);

-- Dim_Materia_Prima
CREATE TABLE Dim_Materia_Prima (
    SK_Materia_Prima SERIAL PRIMARY KEY,
    NK_Materia_Prima VARCHAR(50) NOT NULL UNIQUE,
    Nome_Materia_Prima VARCHAR(150) NOT NULL,
    Descricao TEXT,
    Categoria_Insumo VARCHAR(100) NOT NULL,
    Unidade_Medida VARCHAR(20) NOT NULL
);

-- Dim_Cliente
CREATE TABLE Dim_Cliente (
    SK_Cliente SERIAL PRIMARY KEY,
    NK_Cliente VARCHAR(50) NOT NULL UNIQUE,
    Nome_Cliente VARCHAR(150) NOT NULL,
    CNPJ_CPF VARCHAR(20) NOT NULL,
    Segmento VARCHAR(50) NOT NULL,
    FK_Regiao INT NOT NULL,
    CONSTRAINT fk_cliente_regiao FOREIGN KEY (FK_Regiao) REFERENCES Dim_Regiao (SK_Regiao) ON DELETE RESTRICT
);

-- Dim_Fornecedor
CREATE TABLE Dim_Fornecedor (
    SK_Fornecedor SERIAL PRIMARY KEY,
    NK_Fornecedor VARCHAR(50) NOT NULL UNIQUE,
    Nome_Fornecedor VARCHAR(150) NOT NULL,
    CNPJ VARCHAR(20) NOT NULL,
    Score_Qualidade NUMERIC(4,2) CHECK (Score_Qualidade >= 0 AND Score_Qualidade <= 10),
    Tipo_Produto_Fornecido VARCHAR(100) NOT NULL,
    FK_Regiao INT NOT NULL,
    CONSTRAINT fk_fornecedor_regiao FOREIGN KEY (FK_Regiao) REFERENCES Dim_Regiao (SK_Regiao) ON DELETE RESTRICT
);

-- Dim_Equipamento_Processo
CREATE TABLE Dim_Equipamento_Processo (
    SK_Equipamento SERIAL PRIMARY KEY,
    NK_Equipamento VARCHAR(50) NOT NULL UNIQUE,
    Nome_Equipamento VARCHAR(150) NOT NULL,
    Linha_Producao VARCHAR(100) NOT NULL,
    Setor_Fabrica VARCHAR(100) NOT NULL,
    Status_Operacional VARCHAR(50) NOT NULL,
    Capacidade_Nominal NUMERIC(12,2) NOT NULL,
    Local_Armazenamento_Destino VARCHAR(150) NOT NULL
);

-- Dim_Canal_Vendas
CREATE TABLE Dim_Canal_Vendas (
    SK_Canal SERIAL PRIMARY KEY,
    NK_Canal VARCHAR(50) NOT NULL UNIQUE,
    Nome_Canal VARCHAR(100) NOT NULL,
    Tipo_Canal VARCHAR(50) NOT NULL,
    Regiao_Atuacao VARCHAR(100) NOT NULL,
    Responsavel_Canal VARCHAR(100) NOT NULL
);

-- Dim_Tipo_Manutencao
CREATE TABLE Dim_Tipo_Manutencao (
    SK_Tipo_Manutencao SERIAL PRIMARY KEY,
    Nome_Tipo VARCHAR(100) NOT NULL,
    Descricao TEXT,
    Periodicidade_Recomendada VARCHAR(50) NOT NULL,
    Nivel_Criticidade VARCHAR(50) NOT NULL
);

-- ==========================================
-- 3. CRIAÇÃO DAS TABELAS FATO (FACT)
-- ==========================================

-- Fato_Producao
CREATE TABLE Fato_Producao (
    FK_Tempo INT NOT NULL,
    FK_Produto INT NOT NULL,
    FK_Equipamento INT NOT NULL,
    Quantidade_Produzida INT NOT NULL,
    Quantidade_Aprovada INT NOT NULL,
    Quantidade_Defeituosa INT NOT NULL,
    Tempo_Producao_Minutos NUMERIC(10,2) NOT NULL,
    Tempo_Inatividade_Minutos NUMERIC(10,2) NOT NULL,
    Custo_Producao_Total NUMERIC(12,2) NOT NULL,
    
    PRIMARY KEY (FK_Tempo, FK_Produto, FK_Equipamento),
    CONSTRAINT fk_prod_tempo FOREIGN KEY (FK_Tempo) REFERENCES Dim_Tempo (SK_Tempo) ON DELETE RESTRICT,
    CONSTRAINT fk_prod_produto FOREIGN KEY (FK_Produto) REFERENCES Dim_Produto (SK_Produto) ON DELETE RESTRICT,
    CONSTRAINT fk_prod_equipamento FOREIGN KEY (FK_Equipamento) REFERENCES Dim_Equipamento_Processo (SK_Equipamento) ON DELETE RESTRICT
);

-- Fato_Vendas
CREATE TABLE Fato_Vendas (
    FK_Tempo INT NOT NULL,
    FK_Cliente INT NOT NULL,
    FK_Produto INT NOT NULL,
    FK_Canal INT NOT NULL,
    FK_Regiao INT NOT NULL,
    Quantidade_Vendida INT NOT NULL,
    Preco_Unitario NUMERIC(12,2) NOT NULL,
    Valor_Venda_Bruto NUMERIC(12,2) NOT NULL,
    Valor_Desconto NUMERIC(12,2) NOT NULL,
    Valor_Venda_Liquido NUMERIC(12,2) NOT NULL,
    Custo_Venda_Estimado NUMERIC(12,2) NOT NULL,
    Lucro_Venda NUMERIC(12,2) NOT NULL,
    
    PRIMARY KEY (FK_Tempo, FK_Cliente, FK_Produto, FK_Canal),
    CONSTRAINT fk_vendas_tempo FOREIGN KEY (FK_Tempo) REFERENCES Dim_Tempo (SK_Tempo) ON DELETE RESTRICT,
    CONSTRAINT fk_vendas_cliente FOREIGN KEY (FK_Cliente) REFERENCES Dim_Cliente (SK_Cliente) ON DELETE RESTRICT,
    CONSTRAINT fk_vendas_produto FOREIGN KEY (FK_Produto) REFERENCES Dim_Produto (SK_Produto) ON DELETE RESTRICT,
    CONSTRAINT fk_vendas_canal FOREIGN KEY (FK_Canal) REFERENCES Dim_Canal_Vendas (SK_Canal) ON DELETE RESTRICT,
    CONSTRAINT fk_vendas_regiao FOREIGN KEY (FK_Regiao) REFERENCES Dim_Regiao (SK_Regiao) ON DELETE RESTRICT
);

-- Fato_Compras_Insumos
CREATE TABLE Fato_Compras_Insumos (
    FK_Tempo INT NOT NULL,
    FK_Fornecedor INT NOT NULL,
    FK_Materia_Prima INT NOT NULL,
    Quantidade_Comprada NUMERIC(12,4) NOT NULL,
    Preco_Unitario_Compra NUMERIC(12,4) NOT NULL,
    Valor_Total_Compra NUMERIC(12,2) NOT NULL,
    Lead_Time_Dias INT NOT NULL,
    Atraso_Dias INT NOT NULL,
    Flag_Item_Conforme BOOLEAN NOT NULL,
    
    PRIMARY KEY (FK_Tempo, FK_Fornecedor, FK_Materia_Prima),
    CONSTRAINT fk_compras_tempo FOREIGN KEY (FK_Tempo) REFERENCES Dim_Tempo (SK_Tempo) ON DELETE RESTRICT,
    CONSTRAINT fk_compras_forn FOREIGN KEY (FK_Fornecedor) REFERENCES Dim_Fornecedor (SK_Fornecedor) ON DELETE RESTRICT,
    CONSTRAINT fk_compras_mp FOREIGN KEY (FK_Materia_Prima) REFERENCES Dim_Materia_Prima (SK_Materia_Prima) ON DELETE RESTRICT
);

-- Fato_Estoque_Snapshot
CREATE TABLE Fato_Estoque_Snapshot (
    SK_Estoque_Snapshot SERIAL PRIMARY KEY,
    FK_Tempo INT NOT NULL,
    FK_Produto INT, -- NULL se for Matéria-Prima pura
    FK_Materia_Prima INT, -- NULL se for Produto Acabado
    Quantidade_Saldo NUMERIC(14,4) NOT NULL,
    Custo_Unitario_Estoque NUMERIC(12,4) NOT NULL,
    Valor_Saldo_Estoque NUMERIC(14,2) NOT NULL,
    Tipo_Item VARCHAR(50) NOT NULL, -- 'Matéria-Prima', 'Em Processo', 'Produto Acabado'
    Localizacao_Armazem VARCHAR(100) NOT NULL,
    Dias_Sem_Movimentacao INT NOT NULL,
    
    CONSTRAINT fk_est_tempo FOREIGN KEY (FK_Tempo) REFERENCES Dim_Tempo (SK_Tempo) ON DELETE RESTRICT,
    CONSTRAINT fk_est_produto FOREIGN KEY (FK_Produto) REFERENCES Dim_Produto (SK_Produto) ON DELETE RESTRICT,
    CONSTRAINT fk_est_mp FOREIGN KEY (FK_Materia_Prima) REFERENCES Dim_Materia_Prima (SK_Materia_Prima) ON DELETE RESTRICT
);

-- Fato_Manutencao
CREATE TABLE Fato_Manutencao (
    FK_Tempo_Inicio INT NOT NULL,
    FK_Equipamento INT NOT NULL,
    FK_Tipo_Manutencao INT NOT NULL,
    FK_Fornecedor INT, -- NULL se for manutenção interna
    Numero_Ordem_Servico VARCHAR(50) NOT NULL,
    Tempo_Reparo_Horas NUMERIC(8,2) NOT NULL,
    Tempo_Inatividade_Horas NUMERIC(8,2) NOT NULL,
    Custo_Pecas_Substituidas NUMERIC(12,2) NOT NULL,
    Custo_Mao_Obra NUMERIC(12,2) NOT NULL,
    Custo_Total_Manutencao NUMERIC(12,2) NOT NULL,
    Descricao_Reparo TEXT,
    
    PRIMARY KEY (FK_Tempo_Inicio, FK_Equipamento, Numero_Ordem_Servico),
    CONSTRAINT fk_manut_tempo FOREIGN KEY (FK_Tempo_Inicio) REFERENCES Dim_Tempo (SK_Tempo) ON DELETE RESTRICT,
    CONSTRAINT fk_manut_equip FOREIGN KEY (FK_Equipamento) REFERENCES Dim_Equipamento_Processo (SK_Equipamento) ON DELETE RESTRICT,
    CONSTRAINT fk_manut_tipo FOREIGN KEY (FK_Tipo_Manutencao) REFERENCES Dim_Tipo_Manutencao (SK_Tipo_Manutencao) ON DELETE RESTRICT,
    CONSTRAINT fk_manut_forn FOREIGN KEY (FK_Fornecedor) REFERENCES Dim_Fornecedor (SK_Fornecedor) ON DELETE RESTRICT
);

-- Fato_Financeiro
CREATE TABLE Fato_Financeiro (
    SK_Financeiro SERIAL PRIMARY KEY,
    FK_Tempo INT NOT NULL,
    FK_Fornecedor INT, -- NULL se não for despesa com fornecedor
    Tipo_Lancamento VARCHAR(50) NOT NULL, -- 'Receita', 'Despesa Operacional', etc.
    Centro_Custo VARCHAR(100) NOT NULL,
    Valor_Transacao NUMERIC(14,2) NOT NULL,
    
    CONSTRAINT fk_fin_tempo FOREIGN KEY (FK_Tempo) REFERENCES Dim_Tempo (SK_Tempo) ON DELETE RESTRICT,
    CONSTRAINT fk_fin_forn FOREIGN KEY (FK_Fornecedor) REFERENCES Dim_Fornecedor (SK_Fornecedor) ON DELETE RESTRICT
);
