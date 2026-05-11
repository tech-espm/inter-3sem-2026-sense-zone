use sensezone;

CREATE TABLE local (
    id_local INT PRIMARY KEY,
    nome_local VARCHAR(100) NOT NULL,
    tipo_local VARCHAR(50) NOT NULL,
    andar_local INT NOT NULL
);

INSERT INTO local (id_local, nome_local, tipo_local, andar_local) VALUES
(1, 'Loja 1', 'Loja', 1),
(2, 'Loja 2', 'Loja', 1),
(3, 'Loja 3', 'Loja', 1),
(4, 'Restaurante 4', 'Restaurante', 2),
(5, 'Restaurante 5', 'Restaurante', 2);

CREATE TABLE leituras_sensor (
    id BIGINT PRIMARY KEY,
    id_local INT NOT NULL,
    pessoas_entrando INT NOT NULL,   -- Quantidade de pessoas que entraram na leitura
    pessoas_saindo INT NOT NULL,     -- Quantidade de pessoas que saíram na leitura
    data_leitura DATETIME NOT NULL   -- Momento exato que o sensor enviou o dado
);

-- Query de consolidação de pessoas presentes no local por dia do mês e por hora, para o heatmap de visão explodida por presença com N colunas e 24 linhas
-- A presença é dada por uma coluna virtual, gerada via código, onde:
-- presenca[i] = max(0, presenca[i - 1] + total_entrada[i] - total_saida[i])
-- exceto presenca[0], que vale 0
-- (Consolidado i deve ser reiniciado para 0 na mudança de dia)
select date_format(date(data_leitura), '%d/%m/%Y') dia, extract(hour from data_leitura) hora, sum(pessoas_entrando) total_entrada, sum(pessoas_saindo) total_saida
from leituras_sensor
where data_leitura between '2026-05-01 00:00:00' and '2026-05-11 23:59:59'
and id_local = 2
group by dia, hora
order by dia, hora;

-- Query de consolidação de pessoas presentes por local no andar por dia do mês e por hora, para o heatmap de visão explodida por presença com N colunas e 24 linhas
-- A presença é dada por uma coluna virtual, gerada via código, onde:
-- presenca[i] = max(0, presenca[i - 1] + total_entrada[i] - total_saida[i])
-- exceto presenca[0], que vale 0
-- (Consolidado i deve ser reiniciado para 0 na mudança de dia)
select date_format(date(s.data_leitura), '%d/%m/%Y') dia, extract(hour from s.data_leitura) hora, sum(s.pessoas_entrando) total_entrada, sum(s.pessoas_saindo) total_saida
from leituras_sensor s
inner join local l on l.id_local = s.id_local
where s.data_leitura between '2026-05-01 00:00:00' and '2026-05-11 23:59:59'
and l.andar_local = 1
group by dia, hora
order by dia, hora;
