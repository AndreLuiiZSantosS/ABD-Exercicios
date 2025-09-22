CREATE TABLE Laboratorio (
    lab_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    capacidade INT NOT NULL,
    computadores_funcionais INT NOT NULL,
    status VARCHAR(20) NOT NULL
);

CREATE TABLE Professor (
    professor_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    curso VARCHAR(100)
);

CREATE TABLE Aluno (
    aluno_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    curso VARCHAR(100),
    periodo_referencia INT,
    periodo_atual INT
);

CREATE TABLE Disciplina (
    disciplina_id SERIAL PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE,
    nome VARCHAR(150) NOT NULL,
    carga_horaria INT,
    periodo_referencia INT,
    tipo VARCHAR(20) -- 'Obrigatória' | 'Optativa'
);

CREATE TABLE PedidoRenovacaoMatricula (
    id SERIAL PRIMARY KEY,
    aluno_id INT REFERENCES Aluno(aluno_id),
    disciplina_id INT REFERENCES Disciplina(disciplina_id),
    status VARCHAR(20),
    aprovacao_coordenador BOOLEAN DEFAULT FALSE,
    data_status TIMESTAMP,
    observacao TEXT
);

CREATE TABLE Turma (
    turma_id SERIAL PRIMARY KEY,
    codigo VARCHAR(50),
    periodo INT,
    turno VARCHAR(10)
);

CREATE TABLE Horario (
    horario_id SERIAL PRIMARY KEY,
    numero INT,
    hora_inicio TIME,
    hora_fim TIME
);

CREATE TABLE AlocacaoDisciplinaTurma (
    id SERIAL PRIMARY KEY,
    disciplina_id INT REFERENCES Disciplina(disciplina_id),
    turma_id INT REFERENCES Turma(turma_id),
    professor_id INT REFERENCES Professor(professor_id),
    laboratorio_id INT REFERENCES Laboratorio(lab_id),
    dia_semana VARCHAR(10),
    horario_inicio INT, 
    horario_fim INT
);

CREATE TABLE Reserva (
    reserva_id SERIAL PRIMARY KEY,
    professor_id INT REFERENCES Professor(professor_id),
    laboratorio_id INT REFERENCES Laboratorio(lab_id),
    data_inicio TIMESTAMP,
    data_fim TIMESTAMP,
    qtd_alunos INT,
    tipo VARCHAR(20)
);

CREATE TABLE RetiradaEntregaChave (
    id SERIAL PRIMARY KEY,
    reserva_id INT REFERENCES Reserva(reserva_id),
    laboratorio_id INT REFERENCES Laboratorio(lab_id),
    data_retirada TIMESTAMP,
    data_entrega TIMESTAMP,
    responsavel VARCHAR(100)
);

CREATE TABLE AtividadeExtra (
    id SERIAL PRIMARY KEY,
    laboratorio_id INT REFERENCES Laboratorio(lab_id),
    tipo VARCHAR(50),
    titulo VARCHAR(200),
    organizador VARCHAR(100),
    data_hora TIMESTAMP,
    participantes_estimados INT,
    necessita_aprovacao BOOLEAN DEFAULT FALSE
);

CREATE TABLE ListaEspera (
    id SERIAL PRIMARY KEY,
    pedido_id INT REFERENCES PedidoRenovacaoMatricula(id),
    posicao INT,
    created_at TIMESTAMP DEFAULT now()
);

-- ========================
-- 2) INSERÇÃO DE DADOS 
-- ========================

-- Laboratórios 
INSERT INTO Laboratorio(nome, descricao, capacidade, computadores_funcionais, status) VALUES
('Laboratório 1', 'Laboratório 1', 40, 35, 'Ocupado'),
('Laboratório 2', 'Laboratório 2', 30, 30, 'Disponível'),
('Laboratório 3', 'Laboratório 3', 25, 25, 'Disponível'),
('Laboratório 4', 'Laboratório 4', 20, 20, 'Disponível'),
('Laboratório 5', 'Laboratório 5', 35, 33, 'Disponível'),
('Laboratório 6', 'Laboratório 6', 30, 28, 'Ocupado'),
('Laboratório 7', 'Laboratório 7', 25, 25, 'Ocupado'),
('Laboratório 8', 'Laboratório 8', 40, 40, 'Ocupado'),
('Laboratório 11', 'Laboratório 11', 30, 30, 'Ocupado'),
('Laboratório 12', 'Laboratório 12', 25, 25, 'Ocupado'),
('Laboratório 13', 'Laboratório 13', 25, 20, 'Disponível');


-- Professores
INSERT INTO Professor(nome, curso) VALUES
('Marilia Aranha', 'TADS'),
('Fabiano Papaiz', 'TADS'),
('Gracon Lima', 'TADS'),
('Placido Neto', 'TADS'),
('Robinson Alves', 'TADS'),
('Anna Cecilia', 'TADS');

-- Alunos
INSERT INTO Aluno(nome, curso, periodo_referencia, periodo_atual) VALUES
('Andre Luiz', 'TADS', 2, 4),
('Lucas Tales', 'TADS', 4, 4),
('Manoel Pinto', 'TADS', 4, 4),
('Marcos', 'TADS', 4, 5);

-- Disciplinas obrigatórias
INSERT INTO Disciplina(codigo, nome, carga_horaria, periodo_referencia, tipo) VALUES
('TEC.0005','Metodologia do Trabalho Científico',30,1,'Obrigatória'),
('TEC.0023','Desenvolvimento de Sistemas Distribuídos',90,5,'Obrigatória'),
('TEC.0024','Processo de Software',60,5,'Obrigatória'),
('TEC.0025','Arquitetura de Software',60,5,'Obrigatória'),
('TEC.0026','Programação e Administração de Banco de Dados',60,5,'Obrigatória'),
('TEC.0027','Estrutura de Dados Não-Lineares',60,6,'Obrigatória'),

-- Disciplinas optativas
INSERT INTO Disciplina(codigo, nome, carga_horaria, tipo) VALUES
('TEC.0075','Aplicações com Interfaces Ricas',60,'Optativa'),
('TEC.0077','Desenvolvimento de Jogos',60,'Optativa');

-- Seminários
INSERT INTO Disciplina(codigo, nome, carga_horaria, periodo_referencia, tipo) VALUES
('TEC.0033','Seminário de Orientação ao Projeto de Desenvolvimento de Sistema Distribuído',125,4,'Obrigatória');

-- Turmas
INSERT INTO Turma(codigo, periodo, turno) VALUES
('TADS-1M',1,'Manhã'),
('TADS-2M',2,'Manhã');

-- Horários 
INSERT INTO Horario(numero, hora_inicio, hora_fim) VALUES
(1,'07:00','07:45'), (2,'07:45','08:30'),
(3,'09:00','09:45'), (4,'09:45','10:30'),
(5,'10:30','11:15'), (6,'11:15','12:00');

-- Alocação de disciplinas em turmas e laboratórios
INSERT INTO AlocacaoDisciplinaTurma(disciplina_id, turma_id, professor_id, laboratorio_id, dia_semana, horario_inicio, horario_fim)
VALUES
( (SELECT disciplina_id FROM Disciplina WHERE codigo='TEC.0023'), (SELECT turma_id FROM Turma WHERE codigo='TADS-1M'), (SELECT professor_id FROM Professor WHERE nome='Fabiano Papaiz'), (SELECT lab_id FROM Laboratorio WHERE nome='Laboratório 1'), 'Seg', 1, 2),
( (SELECT disciplina_id FROM Disciplina WHERE codigo='TEC.0026'), (SELECT turma_id FROM Turma WHERE codigo='TADS-2M'), (SELECT professor_id FROM Professor WHERE nome='Anna Cecilia'), (SELECT lab_id FROM Laboratorio WHERE nome='Laboratório 6'), 'Ter', 3, 4);


-- Reservas de exemplo
INSERT INTO Reserva(professor_id, laboratorio_id, data_inicio, data_fim, qtd_alunos, tipo) VALUES
( (SELECT professor_id FROM Professor WHERE nome='Fabiano Papaiz'), (SELECT lab_id FROM Laboratorio WHERE nome='Laboratório 1'), '2025-09-22 08:00','2025-09-22 10:00',35,'Aula'),
( (SELECT professor_id FROM Professor WHERE nome='Gracon Lima'), (SELECT lab_id FROM Laboratorio WHERE nome='Laboratório 6'), '2025-09-23 14:00','2025-09-23 16:00',28,'AtividadeExtra'),
( (SELECT professor_id FROM Professor WHERE nome='Placido Neto'), (SELECT lab_id FROM Laboratorio WHERE nome='Laboratório 2'), '2025-09-24 10:00', '2025-09-24 12:00', 25, 'Aula');

-- Retirada/Entrega de Chave
INSERT INTO RetiradaEntregaChave(reserva_id, laboratorio_id, data_retirada, data_entrega, responsavel)
VALUES ( (SELECT reserva_id FROM Reserva ORDER BY reserva_id LIMIT 1), (SELECT lab_id FROM Laboratorio WHERE nome='Laboratório 8'), '2025-09-22 07:00','2025-09-22 08:20','Marilia Aranha'),
( (SELECT reserva_id FROM Reserva ORDER BY reserva_id DESC LIMIT 1), (SELECT lab_id FROM Laboratorio WHERE nome='Laboratório 1'), '2025-09-23 10:30','2025-09-23 12:00','Gracon Lima');

-- Pedido de renovação + lista de espera
INSERT INTO PedidoRenovacaoMatricula(aluno_id, disciplina_id, status, aprovacao_coordenador, data_status) VALUES
( (SELECT aluno_id FROM Aluno WHERE nome='Andre Luiz'), (SELECT disciplina_id FROM Disciplina WHERE codigo='TEC.0023'), 'pendente', FALSE, now()),
( (SELECT aluno_id FROM Aluno WHERE nome='Marcos'), (SELECT disciplina_id FROM Disciplina WHERE codigo='TEC.0024'), 'confirmado', TRUE, now());

-- Adiciona o pedido pendente à lista de espera
INSERT INTO ListaEspera(pedido_id, posicao) VALUES
( (SELECT id FROM PedidoRenovacaoMatricula WHERE status='pendente' LIMIT 1), 1);

-- Atividades Extras
INSERT INTO AtividadeExtra(laboratorio_id, tipo, titulo, organizador, data_hora, participantes_estimados, necessita_aprovacao) VALUES
((SELECT lab_id FROM Laboratorio WHERE nome='Laboratório 3'), 'Reunião', 'Reunião de Planejamento Semestral', 'Marilia Aranha', '2025-09-25 10:00', 15, FALSE),
((SELECT lab_id FROM Laboratorio WHERE nome='Laboratório 5'), 'Curso', 'Curso de Git e GitHub', 'Gracon Lima', '2025-09-26 14:00', 20, TRUE),
((SELECT lab_id FROM Laboratorio WHERE nome='Laboratório 2'), 'Palestra', 'Palestra sobre Segurança da Informação', 'Fabiano Papaiz', '2025-09-27 09:00', 30, TRUE);

-- 1) Listar todos os laboratórios disponíveis
SELECT lab_id, nome, capacidade, computadores_funcionais, status
FROM Laboratorio
WHERE status ILIKE 'Disponível';

-- 2) Listar todas as reservas feitas por um professor (JOIN)
SELECT r.reserva_id, p.nome AS professor, l.nome AS laboratorio, r.data_inicio, r.data_fim, r.qtd_alunos
FROM Reserva r
JOIN Professor p ON r.professor_id = p.professor_id
JOIN Laboratorio l ON r.laboratorio_id = l.lab_id
WHERE p.nome = 'Placido Neto'
ORDER BY r.data_inicio DESC;

-- 3) Histórico de reservas e retiradas de chaves de um laboratório específico (JOIN + ORDER BY)
SELECT r.reserva_id, r.data_inicio, r.data_fim, r.tipo, re.data_retirada, re.data_entrega, p.nome AS professor
FROM Reserva r
LEFT JOIN RetiradaEntregaChave re ON re.reserva_id = r.reserva_id
JOIN Professor p ON r.professor_id = p.professor_id
WHERE r.laboratorio_id = (SELECT lab_id FROM Laboratorio WHERE nome='Laboratório 1')
ORDER BY r.data_inicio DESC;

-- 4) Número total de reservas feitas por cada professor em um determinado período (GROUP BY, HAVING)
SELECT p.nome, COUNT(*) AS total_reservas
FROM Reserva r
JOIN Professor p ON r.professor_id = p.professor_id
WHERE r.data_inicio BETWEEN '2025-09-01' AND '2025-09-30'
GROUP BY p.nome
HAVING COUNT(*) > 0
ORDER BY total_reservas DESC;

-- 5) Número total de reservas feitas para cada laboratório em um período (GROUP BY)
SELECT l.nome AS laboratorio, COUNT(*) AS total_reservas
FROM Reserva r
JOIN Laboratorio l ON r.laboratorio_id = l.lab_id
WHERE r.data_inicio BETWEEN '2025-09-01' AND '2025-09-30'
GROUP BY l.nome
ORDER BY total_reservas DESC;

-- 6) Reservas que excederam a capacidade do laboratório (WHERE + JOIN)
SELECT r.reserva_id, l.nome AS laboratorio, r.qtd_alunos, l.capacidade
FROM Reserva r
JOIN Laboratorio l ON r.laboratorio_id = l.lab_id
WHERE r.qtd_alunos > l.capacidade;

-- 7) Alunos pendentes por disciplina (JOIN + ORDER BY)
SELECT d.codigo, d.nome AS disciplina, COUNT(p.id) AS pedidos_pendentes
FROM PedidoRenovacaoMatricula p
JOIN Disciplina d ON p.disciplina_id = d.disciplina_id
WHERE p.status = 'pendente'
GROUP BY d.codigo, d.nome
ORDER BY pedidos_pendentes DESC;
