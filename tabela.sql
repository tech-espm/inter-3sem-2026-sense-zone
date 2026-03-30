CREATE TABLE sensor (
    id_sensor INT PRIMARY KEY AUTO_INCREMENT,
    nome_sensor VARCHAR(60),
    tipo_sensor VARCHAR(50),
    status_sensor VARCHAR(20),
    id_local INT,
    FOREIGN KEY (id_local) REFERENCES local(id_local)
 );

CREATE TABLE leituras_sensor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_local VARCHAR(50) NOT NULL, -- Pode ser 'Bloco A', 'Portao Principal', etc.
    pessoas_entrando INT NOT NULL,   -- Quantidade de pessoas que entraram na leitura
    pessoas_saindo INT NOT NULL,     -- Quantidade de pessoas que saíram na leitura
    data_leitura DATETIME NOT NULL   -- Momento exato que o sensor enviou o dado
);

CREATE TABLE local (
    id_local INT PRIMARY KEY AUTO_INCREMENT,
    nome_local VARCHAR(100) NOT NULL,
    tipo_local VARCHAR(50),
    andar_local INT			
);



