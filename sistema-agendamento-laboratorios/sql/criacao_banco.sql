CREATE DATABASE sistema_agendamento_laboratorios;

\c sistema_agendamento_laboratorios;

CREATE TABLE Laboratorio (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    capacidade INT NOT NULL,
    recursos TEXT
);

CREATE TABLE Professor (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    departamento VARCHAR(100)
);

CREATE TABLE Reserva (
    id SERIAL PRIMARY KEY,
    laboratorio_id INT REFERENCES Laboratorio(id),
    professor_id INT REFERENCES Professor(id),
    data_reserva DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    CONSTRAINT chk_hora CHECK (hora_inicio < hora_fim)
);

CREATE TABLE Retirada_Entrega_Chave (
    id SERIAL PRIMARY KEY,
    reserva_id INT REFERENCES Reserva(id),
    data_retirada DATE NOT NULL,
    data_entrega DATE,
    observacoes TEXT
);

CREATE TABLE Atividade_Extra (
    id SERIAL PRIMARY KEY,
    laboratorio_id INT REFERENCES Laboratorio(id),
    descricao TEXT NOT NULL,
    data DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    CONSTRAINT chk_hora_atividade CHECK (hora_inicio < hora_fim)
);