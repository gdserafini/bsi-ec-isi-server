DROP DATABASE IF EXISTS green_path_db;
CREATE DATABASE green_path_db
DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;

USE green_path_db;

CREATE TABLE LocalDescarte (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    referencia VARCHAR(100) NOT NULL,
    fk_TipoLocal_id INT,
    UNIQUE (id, nome)
);

CREATE TABLE Empresa (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nome_fantasia VARCHAR(100) NOT NULL,
    avatar MEDIUMBLOB DEFAULT NULL,
    cnpj VARCHAR(14) NOT NULL,
    razao_social VARCHAR(100) NOT NULL,
    fk_Usuario_id INT,
    fk_LocalDescarte_id INT,
    fk_SetorEmpresa_id INT,
    UNIQUE (id, nome_fantasia, cnpj, razao_social),
    CONSTRAINT check_cpf_digits CHECK(cnpj REGEXP '^[0-9]{14}$')
);

CREATE TABLE Residuo (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nome VARCHAR(100) NOT NULL,
    peso DECIMAL NOT NULL,
    quantidade INT NOT NULL,
    fk_TipoResiduo_id INT,
    UNIQUE (id, nome),
    CONSTRAINT check_values_res CHECK(
        peso >= 0 AND quantidade >=0
    )
);

CREATE TABLE Usuario (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
	cpf VARCHAR(100) NOT NULL,
    telefone VARCHAR(100) NOT NULL,
    senha VARCHAR(100) NOT NULL,
    avatar MEDIUMBLOB DEFAULT NULL,
    fk_TipoUsuario_id INT,
    UNIQUE (id, nome, email),
    CONSTRAINT check_email CHECK(
        email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.com$'
    )
);

CREATE TABLE TipoUsuario (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nome_tipo VARCHAR(100) NOT NULL,
    nivel INT NOT NULL,
    UNIQUE (id, nome_tipo),
    CONSTRAINT check_level_range CHECK(
        nivel >= 1 AND nivel <=3
    )
);

INSERT INTO `TipoUsuario` (`id`, `nome_tipo`, `nivel`) VALUES
(1, 'Administrador', 1),
(2, 'Usuário', 2),
(3, 'Empresa', 3);

CREATE TABLE ContatoEmpresa (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    ddd VARCHAR(3) NOT NULL,
    numero VARCHAR(9) NOT NULL,
    ramal VARCHAR(4) NOT NULL,
    UNIQUE (id, numero, ramal),
    CONSTRAINT check_tel_digits CHECK(
        ddd REGEXP '^[0-9]{2,3}$' AND numero REGEXP '^[0-9]{8,9}$')
);

CREATE TABLE Telefone (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    ddd VARCHAR(3) NOT NULL,
    numero VARCHAR(9) NOT NULL,
    fk_Usuario_id INT,
    UNIQUE (id, numero),
    CONSTRAINT check_tel_digits2 CHECK(
        ddd REGEXP '^[0-9]{2,3}$' AND numero REGEXP '^[0-9]{8,9}$')
);

CREATE TABLE SetorEmpresa (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nome_setor VARCHAR(100) NOT NULL,
    UNIQUE (id, nome_setor)
);

CREATE TABLE TipoResiduo (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nome_tipo VARCHAR(100) NOT NULL,
    classificacao VARCHAR(100) NOT NULL,
    UNIQUE (id, nome_tipo)
);

CREATE TABLE TipoLocal (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nome_tipo VARCHAR(100) NOT NULL,
    UNIQUE (nome_tipo, id)
);

CREATE TABLE RelatLocalResiduo (
    fk_LocalDescarte_id INT,
    fk_Residuo_id INT
);

CREATE TABLE RelatContatoEmpresa (
    fk_ContatoEmpresa_id INT NOT NULL,
    fk_Empresa_id INT NOT NULL
);
 
ALTER TABLE LocalDescarte ADD CONSTRAINT FK_LocalDescarte_2
    FOREIGN KEY (fk_TipoLocal_id)
    REFERENCES TipoLocal (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;
 
ALTER TABLE Empresa ADD CONSTRAINT FK_Empresa_2
    FOREIGN KEY (fk_Usuario_id)
    REFERENCES Usuario (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;
 
ALTER TABLE Empresa ADD CONSTRAINT FK_Empresa_3
    FOREIGN KEY (fk_LocalDescarte_id)
    REFERENCES LocalDescarte (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;
 
ALTER TABLE Empresa ADD CONSTRAINT FK_Empresa_4
    FOREIGN KEY (fk_SetorEmpresa_id)
    REFERENCES SetorEmpresa (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;
 
ALTER TABLE Residuo ADD CONSTRAINT FK_Residuo_2
    FOREIGN KEY (fk_TipoResiduo_id)
    REFERENCES TipoResiduo (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;
 
ALTER TABLE Usuario ADD CONSTRAINT FK_Usuario_2
    FOREIGN KEY (fk_TipoUsuario_id)
    REFERENCES TipoUsuario (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;
 
ALTER TABLE Telefone ADD CONSTRAINT FK_Telefone_2
    FOREIGN KEY (fk_Usuario_id)
    REFERENCES Usuario (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;
 
ALTER TABLE RelatLocalResiduo ADD CONSTRAINT FK_RelatLocalResiduo_1
    FOREIGN KEY (fk_LocalDescarte_id)
    REFERENCES LocalDescarte (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;
 
ALTER TABLE RelatLocalResiduo ADD CONSTRAINT FK_RelatLocalResiduo_2
    FOREIGN KEY (fk_Residuo_id)
    REFERENCES Residuo (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;
 
ALTER TABLE RelatContatoEmpresa ADD CONSTRAINT FK_RelatContatoEmpresa_1
    FOREIGN KEY (fk_ContatoEmpresa_id)
    REFERENCES ContatoEmpresa (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;
 
ALTER TABLE RelatContatoEmpresa ADD CONSTRAINT FK_RelatContatoEmpresa_2
    FOREIGN KEY (fk_Empresa_id)
    REFERENCES Empresa (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;