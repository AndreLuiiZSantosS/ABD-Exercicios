-- Consultas SQL para o sistema de agendamento de laboratórios

-- 1. Listar todos os laboratórios disponíveis
SELECT l.id, l.nome
FROM laboratorios l
LEFT JOIN reservas r ON l.id = r.laboratorio_id AND r.data = CURRENT_DATE
WHERE r.id IS NULL;

-- 2. Reservas feitas por um professor específico
SELECT r.id, r.data, l.nome AS laboratorio_nome
FROM reservas r
JOIN laboratorios l ON r.laboratorio_id = l.id
WHERE r.professor_id = ?; -- Substituir ? pelo ID do professor

-- 3. Histórico de reservas de um laboratório específico
SELECT r.id, r.data, p.nome AS professor_nome
FROM reservas r
JOIN professores p ON r.professor_id = p.id
WHERE r.laboratorio_id = ?; -- Substituir ? pelo ID do laboratório

-- 4. Retiradas de chaves realizadas
SELECT r.id, r.data, l.nome AS laboratorio_nome, p.nome AS professor_nome
FROM retiradas_chaves r
JOIN laboratorios l ON r.laboratorio_id = l.id
JOIN professores p ON r.professor_id = p.id
ORDER BY r.data DESC;

-- 5. Contagem de reservas por laboratório
SELECT l.nome, COUNT(r.id) AS total_reservas
FROM laboratorios l
LEFT JOIN reservas r ON l.id = r.laboratorio_id
GROUP BY l.id
HAVING COUNT(r.id) > 0
ORDER BY total_reservas DESC;