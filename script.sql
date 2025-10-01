-- Cria a tabela de Usuários
CREATE TABLE CH_TB_USER (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL
);

-- Cria a tabela de Pátios
CREATE TABLE CH_TB_PATIO (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200) NOT NULL,
    telefone VARCHAR(20) NOT NULL
);

-- Cria a tabela de Motos e define a chave estrangeira para Pátio
CREATE TABLE CH_TB_MOTO (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    placa VARCHAR(10) NOT NULL UNIQUE,
    ano INT NOT NULL,
    numero_iot BIGINT NULL,
    patio_id BIGINT NOT NULL,
    CONSTRAINT FK_MOTO_PATIO FOREIGN KEY (patio_id) 
        REFERENCES CH_TB_PATIO (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);