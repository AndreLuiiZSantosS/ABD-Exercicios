-- Remover tabelas se já existirem (ordem inversa das dependências)
DROP TABLE IF EXISTS itens_pedido CASCADE;
DROP TABLE IF EXISTS pedido CASCADE;
DROP TABLE IF EXISTS produto CASCADE;
DROP TABLE IF EXISTS usuario CASCADE;

-- Remover tipos personalizados se existirem
DROP TYPE IF EXISTS status_pedido_enum CASCADE;

-- ==========================================
-- TIPOS PERSONALIZADOS
-- ==========================================

-- Criar ENUM para status do pedido
CREATE TYPE status_pedido_enum AS ENUM (
    'pendente', 
    'confirmado', 
    'processando', 
    'enviado', 
    'entregue', 
    'cancelado'
);

-- ==========================================
-- TABELA: USUARIO
-- ==========================================
CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    endereco TEXT,
    data_nascimento DATE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE
);

-- ==========================================
-- TABELA: PRODUTO
-- ==========================================
CREATE TABLE produto (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    descricao TEXT,
    categoria VARCHAR(50),
    preco DECIMAL(10,2) NOT NULL CHECK (preco >= 0),
    quantidade_estoque INTEGER DEFAULT 0 CHECK (quantidade_estoque >= 0),
    peso DECIMAL(8,3),
    dimensoes VARCHAR(50),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE
);

-- ==========================================
-- TABELA: PEDIDO
-- ==========================================
CREATE TABLE pedido (
    id_pedido SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_pedido status_pedido_enum DEFAULT 'pendente',
    valor_total DECIMAL(12,2) DEFAULT 0.00 CHECK (valor_total >= 0),
    endereco_entrega TEXT NOT NULL,
    observacoes TEXT,
    data_entrega_prevista DATE,
    data_entrega_real DATE,
    
    -- Chave estrangeira
    CONSTRAINT fk_pedido_usuario FOREIGN KEY (id_usuario) 
        REFERENCES usuario(id_usuario) ON DELETE RESTRICT
);

-- ==========================================
-- TABELA: ITENS_PEDIDO
-- ==========================================
CREATE TABLE itens_pedido (
    id_item SERIAL PRIMARY KEY,
    id_pedido INTEGER NOT NULL,
    id_produto INTEGER NOT NULL,
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario >= 0),
    subtotal DECIMAL(12,2) GENERATED ALWAYS AS (quantidade * preco_unitario) STORED,
    
    -- Chaves estrangeiras
    CONSTRAINT fk_itens_pedido FOREIGN KEY (id_pedido) 
        REFERENCES pedido(id_pedido) ON DELETE CASCADE,
    CONSTRAINT fk_itens_produto FOREIGN KEY (id_produto) 
        REFERENCES produto(id_produto) ON DELETE RESTRICT,
    
    -- Índice único para evitar duplicação de produto no mesmo pedido
    CONSTRAINT unique_pedido_produto UNIQUE (id_pedido, id_produto)
);

-- Inserir usuários
INSERT INTO usuario (nome, email, telefone, endereco, data_nascimento) VALUES
('João Silva', 'joao.silva@email.com', '(11) 99999-1111', 'Rua A, 123, São Paulo - SP', '1990-05-15'),
('Maria Santos', 'maria.santos@email.com', '(11) 99999-2222', 'Av. B, 456, São Paulo - SP', '1985-08-20'),
('Pedro Oliveira', 'pedro.oliveira@email.com', '(11) 99999-3333', 'Rua C, 789, São Paulo - SP', '1992-12-10');

-- Inserir produtos
INSERT INTO produto (nome, descricao, categoria, preco, quantidade_estoque, peso) VALUES
('Smartphone Galaxy', 'Smartphone Android com 128GB', 'Eletrônicos', 1200.00, 50, 0.200),
('Notebook Dell', 'Notebook Intel i5, 8GB RAM, 256GB SSD', 'Informática', 2500.00, 20, 2.100),
('Tênis Nike Air', 'Tênis esportivo para corrida', 'Calçados', 350.00, 100, 0.800),
('Livro Python', 'Livro sobre programação em Python', 'Livros', 89.90, 30, 0.500),
('Mouse Gamer', 'Mouse óptico para jogos', 'Informática', 120.00, 75, 0.150);

-- Inserir pedidos
INSERT INTO pedido (id_usuario, endereco_entrega, observacoes) VALUES
(1, 'Rua A, 123, São Paulo - SP', 'Entregar no período da manhã'),
(2, 'Av. B, 456, São Paulo - SP', 'Apartamento 302'),
(1, 'Rua A, 123, São Paulo - SP', 'Presente de aniversário');

-- Inserir itens dos pedidos
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 1200.00),  -- João comprou 1 Smartphone
(1, 5, 2, 120.00),   -- João comprou 2 Mouses
(2, 2, 1, 2500.00),  -- Maria comprou 1 Notebook
(2, 3, 1, 350.00),   -- Maria comprou 1 Tênis
(3, 4, 3, 89.90);    -- João comprou 3 Livros

-- Listar todos os usuários ativos
SELECT id_usuario, nome, email, telefone
FROM usuario
WHERE ativo = TRUE;

-- Listar produtos, seus preços e quantidade no estoque por ordem alfabética de seus nomes
SELECT nome, preco, quantidade_estoque 
FROM produto 
ORDER BY nome;

-- Listar quantos pedidos existem e qual o seu status
SELECT status_pedido, COUNT(*) AS total
FROM pedido
GROUP BY status_pedido;

-- Alerta de estoque baixo
SELECT nome, quantidade_estoque 
FROM produto 
WHERE quantidade_estoque < 30 
ORDER BY quantidade_estoque;

-- Listar histórico de pedidos recentes nos últimos 60 dias
SELECT id_pedido, data_pedido, valor_total, status_pedido 
FROM pedido 
WHERE data_pedido >= CURRENT_DATE - INTERVAL '60 days'
ORDER BY data_pedido DESC;

-- Listar itens mais caros em cada categoria
SELECT DISTINCT ON (categoria) categoria, nome, preco
FROM produto
ORDER BY categoria, preco DESC;

-- Listar clientes com dados de contato incompletos
SELECT id_usuario, nome, email, telefone
FROM usuario
WHERE ativo = TRUE
  AND (telefone IS NULL OR telefone = '');

-- Listar entregas pendentes
SELECT p.id_pedido, u.nome AS cliente, u.email, u.telefone, p.endereco_entrega
FROM pedido p
JOIN usuario u ON p.id_usuario = u.id_usuario
WHERE p.status_pedido = 'enviado';

-- Listar detalhes do pedido
SELECT p.id_pedido, u.nome AS cliente, u.email, u.telefone, i.id_produto, pr.nome AS produto, i.quantidade, i.preco_unitario, i.subtotal
FROM pedido p
JOIN usuario u ON p.id_usuario = u.id_usuario
JOIN itens_pedido i ON i.id_pedido = p.id_pedido
JOIN produto pr ON pr.id_produto = i.id_produto 
WHERE p.id_pedido = 1;

-- Listar ranking de produtos mais vendidos
SELECT pr.nome, pr.categoria, SUM(ip.quantidade) AS total_vendido
FROM itens_pedido ip
JOIN produto pr ON pr.id_produto = ip.id_produto
GROUP BY pr.id_produto, pr.nome, pr.categoria
ORDER BY total_vendido DESC;

-- Listar análise de clientes sem compras
SELECT u.id_usuario, u.nome, u.email, u.telefone
FROM usuario u
LEFT JOIN pedido p ON u.id_usuario = p.id_usuario
WHERE p.id_pedido IS NULL
  AND u.ativo = TRUE;

-- Listar estatísticas de compras por cliente
SELECT u.id_usuario, u.nome, COUNT(DISTINCT p.id_pedido) AS total_pedidos, COALESCE(AVG(p.valor_total), 0) AS valor_medio_pedido, COALESCE(SUM(p.valor_total), 0) AS valor_total_gasto
FROM usuario u
JOIN pedido p ON u.id_usuario = p.id_usuario
GROUP BY u.id_usuario, u.nome
ORDER BY valor_total_gasto DESC;

-- Listar relatório mensal de vendas
SELECT 
  TO_CHAR(p.data_pedido, 'YYYY-MM') AS periodo,
  COUNT(DISTINCT p.id_pedido) AS total_pedidos,
  COUNT(DISTINCT ip.id_produto) AS produtos_diferentes,
  COALESCE(SUM(ip.subtotal), 0) AS faturamento_total
FROM pedido p
JOIN itens_pedido ip ON p.id_pedido = ip.id_pedido
WHERE p.status_pedido != 'cancelado'
GROUP BY periodo
ORDER BY periodo;

-- Listar produtos que nunca foram vendidos
SELECT pr.id_produto, pr.nome, pr.categoria, pr.preco
FROM produto pr
LEFT JOIN itens_pedido ip ON pr.id_produto = ip.id_produto
WHERE ip.id_produto IS NULL
  AND pr.ativo = TRUE;

-- Listar análise de ticket médio por categoria
SELECT
  pr.categoria,
  COALESCE(AVG(p.valor_total), 0) AS ticket_medio
FROM pedido p
JOIN itens_pedido ip ON p.id_pedido = ip.id_pedido
JOIN produto pr ON pr.id_produto = ip.id_produto
WHERE p.status_pedido != 'cancelado'
GROUP BY pr.categoria
ORDER BY ticket_medio DESC;