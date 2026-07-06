-- Script para Inserção de Dados de Teste com Erros Propositados (Dirty Data)
-- Data Warehouse: AlfaMaq Manufatura S.A.
-- Máximo de 10 registros por tabela, mantendo integridade referencial (FKs).
-- ATENÇÃO: Contém dados em branco, "NA - Not available", strings vazias e nulos simulando erros de origem.

-- =========================================================================
-- 1. POPULANDO AS TABELAS DE DIMENSÃO (DIM)
-- =========================================================================

-- Dim_Regiao (10 Registros - Contém erros)
INSERT INTO Dim_Regiao (SK_Regiao, Cidade, Estado, Pais, Macroregiao) VALUES
(1, 'São Paulo', 'SP', 'Brasil', 'Sudeste'),
(2, 'Rio de Janeiro', 'RJ', 'Brasil', 'Sudeste'),
(3, 'Belo Horizonte', 'MG', 'Brasil', 'NA - Not available'), -- Erro: "NA - Not available"
(4, 'Porto Alegre', 'RS', 'Brasil', 'Sul'),
(5, 'Curitiba', 'PR', 'Brasil', 'Sul'),
(6, 'Recife', 'PE', 'Brasil', 'Nordeste'),
(7, 'Salvador', 'BA', 'Brasil', 'Nordeste'),
(8, 'Brasília', '  ', 'Brasil', 'Centro-Oeste'), -- Erro: Estado em branco ('  ')
(9, 'Houston', 'TX', 'Estados Unidos', 'North America'),
(10, 'Chicago', 'IL', 'Estados Unidos', 'North America')
ON CONFLICT (SK_Regiao) DO NOTHING;

-- Dim_Tempo (10 Registros)
INSERT INTO Dim_Tempo (SK_Tempo, Data, Dia, Mes, Ano, Trimestre, Semestre, Dia_Semana, Nome_Mes, Flag_Fim_Semana) VALUES
(20260601, '2026-06-01', 1, 6, 2026, 2, 1, 'Segunda-feira', 'Junho', FALSE),
(20260602, '2026-06-02', 2, 6, 2026, 2, 1, 'Terça-feira', 'Junho', FALSE),
(20260603, '2026-06-03', 3, 6, 2026, 2, 1, 'Quarta-feira', 'Junho', FALSE),
(20260604, '2026-06-04', 4, 6, 2026, 2, 1, 'Quinta-feira', 'Junho', FALSE),
(20260605, '2026-06-05', 5, 6, 2026, 2, 1, 'Sexta-feira', 'Junho', FALSE),
(20260606, '2026-06-06', 6, 6, 2026, 2, 1, 'Sábado', 'Junho', TRUE),
(20260607, '2026-06-07', 7, 6, 2026, 2, 1, 'Domingo', 'Junho', TRUE),
(20260608, '2026-06-08', 8, 6, 2026, 2, 1, 'Segunda-feira', 'Junho', FALSE),
(20260609, '2026-06-09', 9, 6, 2026, 2, 1, 'Terça-feira', 'Junho', FALSE),
(20260610, '2026-06-10', 10, 6, 2026, 2, 1, 'Quarta-feira', 'Junho', FALSE)
ON CONFLICT (SK_Tempo) DO NOTHING;

-- Dim_Produto (10 Registros - Contém erros)
INSERT INTO Dim_Produto (SK_Produto, NK_Produto, Nome_Produto, Descricao, Categoria, Subcategoria, Unidade_Medida, Preco_Sugerido, Custo_Padrao) VALUES
(1, 'PROD_01', 'Motor Elétrico Trifásico 5HP', 'Motor de alta performance para prensa', 'Motores', 'Trifásicos', 'Unidade', 1500.00, 900.00),
(2, 'PROD_02', 'Redutor de Velocidade R80', 'Redutor mecânico industrial de engrenagem', 'Transmissão', 'Redutores', 'Unidade', 850.00, 520.00),
(3, 'PROD_03', 'Prensa Hidráulica Compacta 10T', 'Prensa de bancada para pequenas estampas', 'Máquinas', 'Prensas', 'Unidade', 8900.00, 5400.00),
(4, 'PROD_04', 'Acoplamento Flexível A12', 'Acoplamento de alumínio para eixos rotativos', 'Transmissão', 'N/A', 'Unidade', 120.00, 65.00), -- Erro: Subcategoria "N/A"
(5, 'PROD_05', 'Bomba Hidráulica de Engrenagem', 'Bomba de alta pressão para óleo mineral', 'Sistemas Hidráulicos', 'Bombas', 'Unidade', 640.00, 380.00),
(6, 'PROD_06', 'Válvula Direcional Solenoide', '', 'Sistemas Pneumáticos', 'Válvulas', 'Unidade', 350.00, 210.00), -- Erro: Descrição vazia ('')
(7, 'PROD_07', 'Painel de Comando Elétrico PC-10', 'Painel com inversores de frequência e CLPs', 'Elétrica', 'Painéis', 'Unidade', 4200.00, 2600.00),
(8, 'PROD_08', 'Sensor Indutivo M18', 'Sensor de proximidade metálico industrial', 'Automação', 'Sensores', 'Unidade', 95.00, 48.00),
(9, 'PROD_09', 'Cilindro Pneumático ISO 6432', 'Cilindro de dupla ação de curso 100mm', 'Sistemas Pneumáticos', 'Cilindros', 'Unidade', 280.00, 160.00),
(10, 'PROD_10', 'Esteira Transportadora Modular 2M', 'Esteira com correia plástica para caixas', 'Movimentação', 'Esteiras', 'Unidade', 5200.00, 3100.00)
ON CONFLICT (NK_Produto) DO NOTHING;

-- Dim_Materia_Prima (10 Registros - Contém erros)
INSERT INTO Dim_Materia_Prima (SK_Materia_Prima, NK_Materia_Prima, Nome_Materia_Prima, Descricao, Categoria_Insumo, Unidade_Medida) VALUES
(1, 'MP_01', 'Chapa de Aço Carbono 1020', 'Chapa metálica espessura 3mm', 'Metais', 'Kg'),
(2, 'MP_02', 'Fio de Cobre Esmaltado 1.5mm', 'Fio para enrolamento de bobinas', 'ERR - CATEGORY NOT DEFINED', 'Metros'), -- Erro: Categoria inválida/desconhecida
(3, 'MP_03', 'Parafuso Allen M8x30', 'Fixador de aço inox classe 8.8', 'Fixadores', 'Unidade'),
(4, 'MP_04', 'Fluido Hidráulico mineral ISO68', 'Óleo lubrificante para sistemas de alta pressão', 'Químicos', 'Litros'),
(5, 'MP_05', '  ', 'Bloco bruto para usinagem CNC', 'Metais', 'Kg'), -- Erro: Nome em branco ('  ')
(6, 'MP_06', 'Cabo Elétrico Flexível 4mm²', 'Condutor de energy de cobre isolado', 'Elétrica', 'Metros'),
(7, 'MP_07', 'Rolamento de Esferas 6204-ZZ', 'Rolamento blindado com dupla placa de aço', 'Mecânicos', 'Unidade'),
(8, 'MP_08', 'Tinta Epóxi Cinza Industrial', 'Tinta de alta resistência para acabamento', 'Químicos', 'Litros'),
(9, 'MP_09', 'Eixo de Aço Retificado 20mm', 'Barra circular de aço carbono trefilado', 'Metais', 'Metros'),
(10, 'MP_10', 'Conector Elétrico Borne', 'Borne terminal de conexão rápida em trilho DIN', 'Elétrica', 'Unidade')
ON CONFLICT (NK_Materia_Prima) DO NOTHING;

-- Dim_Cliente (10 Registros - Contém erros)
INSERT INTO Dim_Cliente (SK_Cliente, NK_Cliente, Nome_Cliente, CNPJ_CPF, Segmento, FK_Regiao) VALUES
(1, 'CLI_01', 'Metalúrgica Nova Era Ltda', '12.345.678/0001-90', 'Parceiro Industrial', 1),
(2, 'CLI_02', 'Distribuidora Sul de Máquinas', '98.765.432/0001-10', 'Distribuidor', 4),
(3, 'CLI_03', 'Fábrica de Implementos Agrícolas Centro', '45.879.123/0002-88', 'Parceiro Industrial', 8),
(4, 'CLI_04', 'Comércio de Peças Industriais Curitiba', '22.333.444/0001-55', 'Distribuidor', 5),
(5, 'CLI_05', 'Usina Hidrelétrica do Nordeste', '77.888.999/0003-44', 'Parceiro Industrial', 6),
(6, 'CLI_06', 'Construções e Montagens Salvador', '33.444.555/0001-22', 'Cliente Final', 7),
(7, 'CLI_07', 'Auto Peças ABC Paulista', 'N/A', 'Distribuidor', 1), -- Erro: CNPJ inválido como "N/A"
(8, 'CLI_08', 'Mineradora Vertentes S.A.', '66.555.444/0001-77', 'Cliente Final', 3),
(9, 'CLI_09', 'Texas Manufacturing Corp', 'US-998877665', 'Parceiro Industrial', 9),
(10, 'CLI_10', 'Midwest Industrial Supplies', 'US-112233445', '  ', 10) -- Erro: Segmento em branco ('  ')
ON CONFLICT (NK_Cliente) DO NOTHING;

-- Dim_Fornecedor (10 Registros - Contém erros)
INSERT INTO Dim_Fornecedor (SK_Fornecedor, NK_Fornecedor, Nome_Fornecedor, CNPJ, Score_Qualidade, Tipo_Produto_Fornecido, FK_Regiao) VALUES
(1, 'FOR_01', 'Gerdau Aços Especiais S.A.', '33.641.058/0001-50', 9.50, 'Chapas metálicas', 1),
(2, 'FOR_02', 'Pirelli Cabos e Fios Elétricos', '44.888.777/0001-90', 8.90, 'Componentes elétricos', 2),
(3, 'FOR_03', 'Wurth Fixadores e Ferramentas', '55.999.666/0002-40', 9.20, 'Parafusos e Fixadores', 5),
(4, 'FOR_04', 'Ipiranga Produtos Químicos', '22.111.444/0003-90', 8.50, 'NA - Not available', 1), -- Erro: Tipo fornecido "NA - Not available"
(5, 'FOR_05', 'SKF Rolamentos do Brasil', '11.555.222/0001-80', 9.80, 'Rolamentos e Eixos', 5),
(6, 'FOR_06', 'WEG Motores e Automação', '00.123.456/0001-00', 9.70, 'Motores e Inversores', 4),
(7, 'FOR_07', 'Siemens Automação Industrial', '99.888.777/0001-11', 9.60, 'Componentes eletrônicos', 1),
(8, 'FOR_08', 'Serviços de Manutenção CNC Sul', '55.444.333/0001-66', NULL, 'Serviços Técnicos', 4), -- Erro: Score_Qualidade nulo
(9, 'FOR_09', 'Alcoa Alumínios S.A.', '88.777.666/0002-22', 9.10, 'Metais', 3),
(10, 'FOR_10', 'Global Materials USA', 'US-88776655', 9.00, 'Chapas metálicas', 9)
ON CONFLICT (NK_Fornecedor) DO NOTHING;

-- Dim_Equipamento_Processo (10 Registros - Contém erros)
INSERT INTO Dim_Equipamento_Processo (SK_Equipamento, NK_Equipamento, Nome_Equipamento, Linha_Producao, Setor_Fabrica, Status_Operacional, Capacidade_Nominal, Local_Armazenamento_Destino) VALUES
(1, 'EQP_01', 'Torno Mecânico CNC Romi T240', 'Linha de Usinagem 1', 'Usinagem', 'Operativo', 50.00, 'Armazém Central - Setor Usinagem'),
(2, 'EQP_02', 'Centro de Usinagem Vertical Discovery', 'Linha de Usinagem 2', 'Usinagem', 'Operativo', 30.00, 'Armazém Central - Setor Usinagem'),
(3, 'EQP_03', 'Prensa Hidráulica 100 Toneladas', 'Linha de Estamparia A', 'Estamparia', 'Operativo', 120.00, 'Almoxarifado Norte - Setor Metalúrgico'),
(4, 'EQP_04', 'Robô de Solda Robotizada Kuka', 'Linha de Soldagem Automática', 'Solda', 'Operativo', 80.00, 'Galpão Industrial 2 (WIP)'),
(5, 'EQP_05', 'Cabine de Pintura Eletrostática Tecno', 'Linha de Acabamento', 'Pintura', 'ERR - STATUS UNKNOWN', 60.00, 'Armazém Logístico - Setor Pintura'), -- Erro: Status desconhecido
(6, 'EQP_06', 'Dobradeira de Chapas CNC Newton', 'Linha de Estamparia B', 'Estamparia', 'Operativo', 90.00, 'Galpão Industrial 2 (WIP)'),
(7, 'EQP_07', 'Bobinadeira Automática WEG-10', 'Linha de Motores Eletromecânicos', 'Montagem Elétrica', 'Operativo', 40.00, 'Doca de Expedição Sul'),
(8, 'EQP_08', 'Linha de Montagem de Motores Semi-Auto', 'Linha de Montagem A', 'Montagem Final', 'Operativo', 25.00, 'Doca de Expedição Sul'),
(9, 'EQP_09', 'Forno de Tratamento Térmico Combust', 'Linha de Tratamento Metalúrgico', 'Tratamento Térmico', 'Operativo', 15.00, '  '), -- Erro: Local de armazenamento vazio ('  ')
(10, 'EQP_10', 'Injetora de Plástico Sandretto 250T', 'Linha de Componentes Plásticos', 'Injeção', 'Operativo', 110.00, 'Almoxarifado Norte - Setor Plásticos')
ON CONFLICT (NK_Equipamento) DO NOTHING;

-- Dim_Canal_Vendas (5 Registros - Contém erros)
INSERT INTO Dim_Canal_Vendas (SK_Canal, NK_Canal, Nome_Canal, Tipo_Canal, Regiao_Atuacao, Responsavel_Canal) VALUES
(1, 'CAN_01', 'Portal E-commerce B2B', 'Digital', 'Nacional', 'Fernanda Souza'),
(2, 'CAN_02', 'Equipe de Venda Direta Interna', 'Físico', 'Regional Sudeste', 'Roberto Oliveira'),
(3, 'CAN_03', 'Rede de Distribuidores Autorizados', 'Representante', 'Nacional', 'Carlos Henrique'),
(4, 'CAN_04', 'Representação Comercial Internacional', 'Representante', 'América Latina', 'NA - Not available'), -- Erro: Responsável indefinido
(5, 'CAN_05', 'Televendas Corporativo', 'Digital', 'Regional Sul e Sudeste', 'Patricia Lima')
ON CONFLICT (NK_Canal) DO NOTHING;

-- Dim_Tipo_Manutencao (5 Registros - Contém erros)
INSERT INTO Dim_Tipo_Manutencao (SK_Tipo_Manutencao, Nome_Tipo, Descricao, Periodicidade_Recomendada, Nivel_Criticidade) VALUES
(1, 'Preventiva (Programada)', 'Inspeção, lubrificação e troca de componentes conforme cronograma', 'Mensal', 'Média'),
(2, 'Corretiva (Urgente)', 'Reparo emergencial devido a falha inesperada com parada de máquina', 'Não Aplicável', 'Alta'),
(3, 'Preditiva (Sensores)', 'Análise de vibração e temperatura via telemetria para prevenção', 'Semestral', 'Baixa'),
(4, 'Calibração', 'Ajuste de instrumentos de medição e precisão geométrica', '  ', 'Média'), -- Erro: Periodicidade vazia
(5, 'Lubrificação Geral', 'Aplicação de óleo e graxa nos pontos mecânicos rotativos', 'Semanal', 'Baixa')
ON CONFLICT (SK_Tipo_Manutencao) DO NOTHING;


-- =========================================================================
-- 2. POPULANDO AS TABELAS FATO (FACT)
-- =========================================================================

-- Fato_Producao (10 Registros)
INSERT INTO Fato_Producao (FK_Tempo, FK_Produto, FK_Equipamento, Quantidade_Produzida, Quantidade_Aprovada, Quantidade_Defeituosa, Tempo_Producao_Minutos, Tempo_Inatividade_Minutos, Custo_Producao_Total) VALUES
(20260601, 1, 8, 20, 18, 2, 480.00, 30.00, 18000.00),
(20260601, 2, 1, 50, 49, 1, 400.00, 0.00, 26000.00),
(20260602, 3, 3, 5, 5, 0, 480.00, 60.00, 27000.00),
(20260602, 4, 2, 150, 147, 3, 360.00, 15.00, 9750.00),
(20260603, 5, 10, 80, 76, 4, 450.00, 20.00, 30400.00),
(20260603, 6, 10, 120, 119, 1, 420.00, 10.00, 25200.00),
(20260604, 7, 7, 8, 8, 0, 480.00, 0.00, 20800.00),
(20260605, 8, 2, 300, 298, 2, 380.00, 0.00, 14400.00),
(20260605, 9, 9, 45, 43, 2, 480.00, 45.00, 7200.00),
(20260608, 10, 8, 3, 3, 0, 480.00, 0.00, 9300.00);

-- Fato_Vendas (10 Registros)
INSERT INTO Fato_Vendas (FK_Tempo, FK_Cliente, FK_Produto, FK_Canal, FK_Regiao, Quantidade_Vendida, Preco_Unitario, Valor_Venda_Bruto, Valor_Desconto, Valor_Venda_Liquido, Custo_Venda_Estimado, Lucro_Venda) VALUES
(20260601, 1, 1, 2, 1, 10, 1500.00, 15000.00, 500.00, 14500.00, 9000.00, 5500.00),
(20260602, 2, 2, 3, 4, 30, 850.00, 25500.00, 1000.00, 24500.00, 15600.00, 8900.00),
(20260603, 3, 3, 2, 8, 2, 8900.00, 17800.00, 0.00, 17800.00, 10800.00, 7000.00),
(20260604, 4, 4, 3, 5, 100, 120.00, 12000.00, 600.00, 11400.00, 6500.00, 4900.00),
(20260605, 5, 5, 2, 6, 15, 640.00, 9600.00, 300.00, 9300.00, 5700.00, 3600.00),
(20260605, 6, 6, 1, 7, 25, 350.00, 8750.00, 250.00, 8500.00, 5250.00, 3250.00),
(20260608, 7, 7, 5, 1, 4, 4200.00, 16800.00, 800.00, 16000.00, 10400.00, 5600.00),
(20260609, 8, 8, 2, 3, 150, 95.00, 14250.00, 250.00, 14000.00, 7200.00, 6800.00),
(20260610, 9, 9, 4, 9, 20, 280.00, 5600.00, 100.00, 5500.00, 3200.00, 2300.00),
(20260610, 10, 10, 3, 10, 1, 5200.00, 5200.00, 200.00, 5000.00, 3100.00, 1900.00);

-- Fato_Compras_Insumos (10 Registros)
INSERT INTO Fato_Compras_Insumos (FK_Tempo, FK_Fornecedor, FK_Materia_Prima, Quantidade_Comprada, Preco_Unitario_Compra, Valor_Total_Compra, Lead_Time_Dias, Atraso_Dias, Flag_Item_Conforme) VALUES
(20260601, 1, 1, 1500.0000, 8.5000, 12750.00, 5, 0, TRUE),
(20260602, 2, 2, 800.0000, 4.2000, 3360.00, 6, 1, TRUE),
(20260603, 3, 3, 5000.0000, 0.4500, 2250.00, 3, 0, TRUE),
(20260604, 4, 4, 200.0000, 12.0000, 2400.00, 4, 0, FALSE),
(20260605, 5, 7, 100.0000, 28.0000, 2800.00, 7, 2, TRUE),
(20260605, 6, 6, 1200.0000, 6.1000, 7320.00, 5, 0, TRUE),
(20260608, 7, 10, 500.0000, 3.5000, 1750.00, 8, 1, TRUE),
(20260608, 9, 5, 600.0000, 14.5000, 8700.00, 6, 0, TRUE),
(20260609, 10, 1, 2000.0000, 8.2000, 16400.00, 10, 2, TRUE),
(20260610, 3, 3, 3000.0000, 0.4200, 1260.00, 3, 0, TRUE);

-- Fato_Estoque_Snapshot (10 Registros)
INSERT INTO Fato_Estoque_Snapshot (FK_Tempo, FK_Produto, FK_Materia_Prima, Quantidade_Saldo, Custo_Unitario_Estoque, Valor_Saldo_Estoque, Tipo_Item, Localizacao_Armazem, Dias_Sem_Movimentacao) VALUES
(20260601, 1, NULL, 50.0000, 900.0000, 45000.00, 'Produto Acabado', 'Armazém Central - Setor Usinagem', 2),
(20260601, NULL, 1, 4500.0000, 8.5000, 38250.00, 'Matéria-Prima', 'Almoxarifado de Insumos', 0),
(20260602, 2, NULL, 35.0000, 520.0000, 18200.00, 'Produto Acabado', 'Armazém Central - Setor Usinagem', 5),
(20260602, NULL, 2, 1200.0000, 4.2000, 5040.00, 'Matéria-Prima', 'Almoxarifado de Insumos', 1),
(20260603, 3, NULL, 8.0000, 5400.0000, 43200.00, 'Produto Acabado', 'Almoxarifado Norte - Setor Metalúrgico', 10),
(20260603, NULL, 3, 15000.0000, 0.4500, 6750.00, 'Matéria-Prima', 'Almoxarifado de Insumos', 15),
(20260604, 4, NULL, 220.0000, 65.0000, 14300.00, 'Produto Acabado', 'Galpão Industrial 2 (WIP)', 0),
(20260605, NULL, 4, 340.0000, 12.0000, 4080.00, 'Matéria-Prima', 'Almoxarifado de Insumos', 3),
(20260608, 10, NULL, 5.0000, 3100.0000, 15500.00, 'Produto Acabado', 'Doca de Expedição Sul', 8),
(20260610, NULL, 5, 800.0000, 14.5000, 11600.00, 'Matéria-Prima', 'Almoxarifado de Insumos', 4);

-- Fato_Manutencao (10 Registros)
INSERT INTO Fato_Manutencao (FK_Tempo_Inicio, FK_Equipamento, FK_Tipo_Manutencao, FK_Fornecedor, Numero_Ordem_Servico, Tempo_Reparo_Horas, Tempo_Inatividade_Horas, Custo_Pecas_Substituidas, Custo_Mao_Obra, Custo_Total_Manutencao, Descricao_Reparo) VALUES
(20260601, 1, 1, NULL, 'OS-2026-001', 3.00, 3.00, 120.00, 150.00, 270.00, 'Limpeza geral e lubrificação dos eixos do torno'),
(20260602, 2, 1, NULL, 'OS-2026-002', 4.50, 4.50, 80.00, 220.00, 300.00, 'Calibração dos sensores do centro de usinagem'),
(20260602, 3, 2, 8, 'OS-2026-003', 8.00, 24.00, 1400.00, 1200.00, 2600.00, 'Vazamento hidráulico - Troca das vedações do pistão principal por fornecedor externo'),
(20260603, 4, 3, NULL, 'OS-2026-004', 2.00, 0.00, 0.00, 100.00, 100.00, 'Análise de vibração preditiva no braço mecânico'),
(20260604, 5, 1, NULL, 'OS-2026-005', 6.00, 6.00, 340.00, 300.00, 640.00, 'Substituição preventiva de bicos pulverizadores'),
(20260605, 6, 2, NULL, 'OS-2026-006', 3.50, 8.00, 190.00, 180.00, 370.00, 'Dobradeira travada - Ajuste do alinhamento geométrico'),
(20260608, 7, 5, NULL, 'OS-2026-007', 1.00, 1.00, 30.00, 50.00, 80.00, 'Lubrificação dos rolamentos da bobinadeira'),
(20260608, 8, 2, 8, 'OS-2026-008', 5.00, 12.00, 450.00, 600.00, 1050.00, 'Falha elétrica no CLP - Reposição de relés e reapertos feita por assistência técnica'),
(20260609, 9, 4, NULL, 'OS-2026-009', 12.00, 36.00, 600.00, 500.00, 1100.00, 'Calibração de termopares e resistências do forno'),
(20260610, 10, 1, NULL, 'OS-2026-010', 4.00, 4.00, 150.00, 200.00, 350.00, 'Manutenção preventiva da rosca injetora de plásticos')
ON CONFLICT (FK_Tempo_Inicio, FK_Equipamento, Numero_Ordem_Servico) DO NOTHING;

-- Fato_Financeiro (10 Registros)
INSERT INTO Fato_Financeiro (SK_Financeiro, FK_Tempo, FK_Fornecedor, Tipo_Lancamento, Centro_Custo, Valor_Transacao) VALUES
(1, 20260601, NULL, 'Receita', 'Comercial', 14500.00),
(2, 20260602, 1, 'Despesa Operacional', 'Industrial', -12750.00),
(3, 20260603, 8, 'Despesa Operacional', 'Industrial', -2600.00),
(4, 20260604, NULL, 'Despesa Operacional', 'Administrativo', -4200.00),
(5, 20260605, NULL, 'Folha Pagamento', 'Industrial', -32000.00),
(6, 20260605, NULL, 'Receita', 'Comercial', 24500.00),
(7, 20260608, NULL, 'Folha Pagamento', 'Administrativo', -15000.00),
(8, 20260609, 2, 'Despesa Operacional', 'Industrial', -3360.00),
(9, 20260610, NULL, 'Receita', 'Comercial', 17800.00),
(10, 20260610, 5, 'Despesa Operacional', 'Industrial', -2800.00)
ON CONFLICT (SK_Financeiro) DO NOTHING;


-- =========================================================================
-- 3. ALINHAMENTO/SINCRONIZAÇÃO DAS SEQUÊNCIAS DAS SURROGATE KEYS (SERIAL)
-- =========================================================================
SELECT setval(pg_get_serial_sequence('dim_regiao', 'sk_regiao'), COALESCE(max(SK_Regiao), 1)) FROM Dim_Regiao;
SELECT setval(pg_get_serial_sequence('dim_produto', 'sk_produto'), COALESCE(max(SK_Produto), 1)) FROM Dim_Produto;
SELECT setval(pg_get_serial_sequence('dim_materia_prima', 'sk_materia_prima'), COALESCE(max(SK_Materia_Prima), 1)) FROM Dim_Materia_Prima;
SELECT setval(pg_get_serial_sequence('dim_cliente', 'sk_cliente'), COALESCE(max(SK_Cliente), 1)) FROM Dim_Cliente;
SELECT setval(pg_get_serial_sequence('dim_fornecedor', 'sk_fornecedor'), COALESCE(max(SK_Fornecedor), 1)) FROM Dim_Fornecedor;
SELECT setval(pg_get_serial_sequence('dim_equipamento_processo', 'sk_equipamento'), COALESCE(max(SK_Equipamento), 1)) FROM Dim_Equipamento_Processo;
SELECT setval(pg_get_serial_sequence('dim_canal_vendas', 'sk_canal'), COALESCE(max(SK_Canal), 1)) FROM Dim_Canal_Vendas;
SELECT setval(pg_get_serial_sequence('dim_tipo_manutencao', 'sk_tipo_manutencao'), COALESCE(max(SK_Tipo_Manutencao), 1)) FROM Dim_Tipo_Manutencao;
SELECT setval(pg_get_serial_sequence('fato_financeiro', 'sk_financeiro'), COALESCE(max(SK_Financeiro), 1)) FROM Fato_Financeiro;
