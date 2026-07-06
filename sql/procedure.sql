-- Carrega dim_data com datas passadas e futuras
CREATE OR REPLACE PROCEDURE public.Dim_Tempo()
LANGUAGE plpgsql
AS $$
DECLARE
    v_data_atual DATE := '2026-01-01';
    v_data_final DATE := '2031-12-31';
BEGIN
    -- Loop para gerar e inserir as datas
    WHILE v_data_atual <= v_data_final LOOP
        INSERT INTO public.Dim_Tempo (Dia, Mes, Ano, Data)
        VALUES (
            EXTRACT(DAY FROM v_data_atual),
            EXTRACT(MONTH FROM v_data_atual),
            EXTRACT(YEAR FROM v_data_atual),
            v_data_atual
        );
        
        -- Incrementa a data 
        v_data_atual := v_data_atual + INTERVAL '1 day';
    END LOOP;
END;
$$;

-- Executa a SP
CALL public.Dim_Tempo();

-- Carrega tabela FATO
CREATE OR REPLACE PROCEDURE dw.sp_carrega_tabela_fato()
LANGUAGE plpgsql
AS $$
DECLARE
    i INT := 1;
    v_sk_produto INT;
    v_sk_canal INT;
    v_sk_data INT;
    v_sk_cliente INT;
BEGIN
    WHILE i <= 1000 LOOP
        -- Seleciona IDs aleatórios válidos das tabelas de dimensão
        v_sk_produto := (SELECT sk_produto FROM dw.dim_produto ORDER BY RANDOM() LIMIT 1);
        v_sk_canal := (SELECT sk_canal FROM dw.dim_canal ORDER BY RANDOM() LIMIT 1);
        v_sk_data := (SELECT sk_data FROM dw.dim_data WHERE ano <= 2025 ORDER BY RANDOM() LIMIT 1);
        v_sk_cliente := (SELECT sk_cliente FROM dw.dim_cliente ORDER BY RANDOM() LIMIT 1);

        BEGIN
            -- Tenta inserir um registro com uma combinação única de chaves
            INSERT INTO dw.fato_venda (sk_produto, sk_canal, sk_data, sk_cliente, quantidade, valor_venda)
            VALUES (
                v_sk_produto,
                v_sk_canal,
                v_sk_data,
                v_sk_cliente,
                FLOOR(1 + RANDOM() * 125),   -- Quantidade
                ROUND(CAST(RANDOM() * 1000 AS numeric), 2)  -- Valor: Aleatório até 1000 com duas casas decimais
            );
            i := i + 1;  -- Incrementa o contador apenas em caso de sucesso
        EXCEPTION WHEN unique_violation THEN
            -- Se ocorrer um erro de violação de unicidade, continua o loop sem incrementar 'i'
            CONTINUE;
        END;
    END LOOP;
END;
$$;

-- Executa a SP
CALL dw.sp_carrega_tabela_fato();