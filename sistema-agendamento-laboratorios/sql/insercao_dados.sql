INSERT INTO Laboratorios (id, nome, capacidade, equipamento) VALUES
(1, 'Laboratório de Informática', 30, 'Computadores, Projetores'),
(2, 'Laboratório de Química', 20, 'Bancadas, Equipamentos de Segurança'),
(3, 'Laboratório de Física', 25, 'Experimentos, Equipamentos de Medição'),
(4, 'Laboratório de Biologia', 15, 'Microscópios, Culturas Celulares'),
(5, 'Laboratório de Matemática', 40, 'Calculadoras, Projetores');

INSERT INTO Professores (id, nome, departamento) VALUES
(1, 'Dr. João Silva', 'Ciências Exatas'),
(2, 'Profa. Maria Oliveira', 'Ciências Biológicas'),
(3, 'Dr. Carlos Pereira', 'Engenharia'),
(4, 'Profa. Ana Costa', 'Matemática'),
(5, 'Dr. Lucas Almeida', 'Física');

INSERT INTO Reservas (id, laboratorio_id, professor_id, data_reserva, horario_inicio, horario_fim) VALUES
(1, 1, 1, '2023-10-01', '08:00', '10:00'),
(2, 2, 2, '2023-10-02', '10:00', '12:00'),
(3, 3, 3, '2023-10-03', '14:00', '16:00'),
(4, 4, 4, '2023-10-04', '09:00', '11:00'),
(5, 5, 5, '2023-10-05', '13:00', '15:00');

INSERT INTO Retiradas_Entregas_Chaves (id, reserva_id, data_retirada, data_entrega) VALUES
(1, 1, '2023-10-01', '2023-10-01'),
(2, 2, '2023-10-02', '2023-10-02'),
(3, 3, '2023-10-03', '2023-10-03'),
(4, 4, '2023-10-04', '2023-10-04'),
(5, 5, '2023-10-05', '2023-10-05');

INSERT INTO Atividades_Extras (id, nome, descricao, data) VALUES
(1, 'Workshop de Programação', 'Aprenda a programar em Python', '2023-10-10'),
(2, 'Experimentos de Química', 'Atividades práticas de química', '2023-10-15'),
(3, 'Física em Ação', 'Demonstrações práticas de física', '2023-10-20'),
(4, 'Matemática Criativa', 'Atividades lúdicas de matemática', '2023-10-25'),
(5, 'Biologia em Campo', 'Visita a um laboratório de biologia', '2023-10-30');