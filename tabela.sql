CREATE TABLE local (
    id_local INT PRIMARY KEY AUTO_INCREMENT,
    nome_local VARCHAR(100) NOT NULL,
    tipo_local VARCHAR(50) NOT NULL,
    andar_local INT NOT NULL
);

CREATE TABLE leituras_sensor (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
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
where data_leitura between '2025-03-03 00:00:00' and '2025-03-14 23:59:59'
and id_local = 2
group by dia, hora
order by dia, hora;

-- Query de consolidação de pessoas presentes por local no andar por dia do mês e por hora, para o heatmap de visão explodida por presença com N colunas e 24 linhas
-- A presença é dada por uma coluna virtual, gerada via código, onde:
-- presenca[i] = max(0, presenca[i - 1] + total_entrada[i] - total_saida[i])
-- exceto presenca[0], que vale 0
-- (Consolidado i deve ser reiniciado para 0 na mudança de dia)
select date_format(date(data_leitura), '%d/%m/%Y') dia, extract(hour from data_leitura) hora, sum(pessoas_entrando) total_entrada, sum(pessoas_saindo) total_saida, id_local
from leituras_sensor
where data_leitura between '2025-03-03 00:00:00' and '2025-03-14 23:59:59'
and andar_local = 1
group by id_local, dia, hora
order by id_local, dia, hora;

-- Query de consolidação de pessoas presentes no andar por dia do mês e por hora, para o heatmap de visão explodida por presença com N colunas e 24 linhas
-- A presença é dada por uma coluna virtual, gerada via código, onde:
-- presenca[i] = max(0, presenca[i - 1] + total_entrada[i] - total_saida[i])
-- exceto presenca[0], que vale 0
-- (Consolidado i deve ser reiniciado para 0 na mudança de dia)
select date_format(date(s.data_leitura), '%d/%m/%Y') dia, extract(hour from s.data_leitura) hora, sum(s.pessoas_entrando) total_entrada, sum(s.pessoas_saindo) total_saida, l.andar_local
from leituras_sensor s
inner join local l on l.id_local = s.id_local
where s.data_leitura between '2025-03-03 00:00:00' and '2025-03-14 23:59:59'
group by dia, hora, l.andar_local
order by dia, hora, l.andar_local;
