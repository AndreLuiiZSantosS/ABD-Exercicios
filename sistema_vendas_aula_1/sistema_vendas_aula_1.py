import os
import sys
import psycopg2
from psycopg2 import sql

DB_CONFIG = {
    'host': 'localhost',
    'user': 'postgres',
    'password': 'postgres',
    'database': 'sistema_vendas'
}

class SistemaVendasCLI:
    def __init__(self):
        self.conexao = None
        print("Sistema de Vendas - CLI Inicializado")
        print("=" * 50)
    
    def conectar_banco(self):
        try:
            self.conexao = psycopg2.connect(
                host=DB_CONFIG['host'],
                user=DB_CONFIG['user'],
                password=DB_CONFIG['password'],
                database=DB_CONFIG['database']
            )
            
            print("Conectando ao banco PostgreSQL...")
            self.conexao.autocommit = True
            print("Conexão estabelecida com sucesso!")
            return True
        except psycopg2.Error as e:
            print(f"Erro ao conectar ao PostgreSQL: {e}")
            return False
        except Exception as e:
            print(f"Erro inesperado: {e}")
            return False
    
    def desconectar_banco(self):
        if self.conexao:
            self.conexao.close()
            print("Conexão com o banco de dados encerrada.")
                        
    def executar_consulta(self, sql: str, descricao: str) -> None:
        if not self.conexao:
            print("Sem conexão ativa.")
            return
        
        try:
            with self.conexao.cursor() as cursor:
                print(f"\n=== {descricao} ===")
                cursor.execute(sql)
                
                if cursor.description:
                    colunas = [desc[0] for desc in cursor.description]
                    registros = cursor.fetchall()
                    
                    print(" | ".join(colunas))
                    print("-" * 50)
                    
                    for linha in registros:
                        print(" | ".join(str(c) for c in linha))
                    
                    if not registros:
                        print("Nenhum resultado encontrado.")
                else:
                    print("Consulta executada com sucesso.")
        except psycopg2.Error as e:
            print(f"Erro ao executar consulta: {e}")
    
    # ========================================
    # FUNCOES COM CONSULTAS SQL
    # ========================================
    
    def consulta_01_usuarios_ativos(self):
        sql = """
        SELECT id, nome, email, telefone
        FROM usuarios
        WHERE ativo = TRUE;
        """
        self.executar_consulta(sql, "1. Listagem de Usuários Ativos")
    
    def consulta_02_produtos_categoria(self):
        sql = """
        SELECT categoria, nome, preco
        FROM produto
        ORDER BY categoria, nome;
        """
        self.executar_consulta(sql, "2. Catálogo de Produtos por Categoria")
    
    def consulta_03_pedidos_status(self):
        sql = """
        SELECT status, COUNT(*) AS total_pedidos
        FROM pedido
        GROUP BY status;
        """
        self.executar_consulta(sql, "3. Contagem de Pedidos por Status")
    
    def consulta_04_estoque_baixo(self):
        sql = """
        SELECT id, nome, estoque
        FROM produto
        WHERE estoque < 5;
        """
        self.executar_consulta(sql, "4. Alerta de Estoque Baixo")
    
    def consulta_05_pedidos_recentes(self):
        sql = """
        SELECT p.id, p.data, u.nome AS cliente, p.status
        FROM pedido p
        JOIN usuarios u ON u.id = p.id_usuario
        WHERE p.data >= NOW() - INTERVAL '30 days'
        ORDER BY p.data DESC;
        """
        self.executar_consulta(sql, "5. Histórico de Pedidos Recentes")
    
    def consulta_06_produtos_caros_categoria(self):
        sql = """
        SELECT DISTINCT ON (categoria) categoria, nome, preco
        FROM produto
        ORDER BY categoria, preco DESC;
        """
        self.executar_consulta(sql, "6. Produtos Mais Caros por Categoria")
    
    def consulta_07_contatos_incompletos(self):
        sql = """
        SELECT id, nome, email
        FROM usuarios
        WHERE ativo = TRUE AND (telefone IS NULL OR telefone = '');
        """
        self.executar_consulta(sql, "7. Clientes com Dados Incompletos")
    
    def consulta_08_pedidos_enviados(self):
        sql = """
        SELECT id, id_usuario, data, status
        FROM pedido
        WHERE status = 'Enviado';
        """
        self.executar_consulta(sql, "8. Pedidos Pendentes de Entrega")
    
    def consulta_09_detalhamento_pedido(self):
        sql = """
        SELECT p.id AS pedido_id, u.nome AS cliente, pr.nome AS produto, ip.quantidade, ip.preco
        FROM pedido p
        JOIN usuarios u ON u.id = p.id_usuario
        JOIN itens_pedido ip ON ip.id_pedido = p.id
        JOIN produto pr ON pr.id = ip.id_produto;
        """
        self.executar_consulta(sql, "9. Detalhamento Completo de Pedidos")
    
    def consulta_10_ranking_produtos(self):
        sql = """
        SELECT pr.nome, pr.categoria, SUM(ip.quantidade) AS total_vendido
        FROM itens_pedido ip
        JOIN produto pr ON pr.id = ip.id_produto
        GROUP BY pr.id, pr.nome, pr.categoria
        ORDER BY total_vendido DESC;
        """
        self.executar_consulta(sql, "10. Ranking dos Produtos Mais Vendidos")
    
    def consulta_11_clientes_sem_compras(self):
        sql = """
        SELECT u.id, u.nome, u.email
        FROM usuarios u
        WHERE u.ativo = TRUE
        AND NOT EXISTS (
            SELECT 1 FROM pedido p WHERE p.id_usuario = u.id
        );
        """
        self.executar_consulta(sql, "11. Análise de Clientes Sem Compras")
    
    def consulta_12_estatisticas_cliente(self):
        sql = """
        SELECT u.id, u.nome,
               COUNT(p.id) AS total_pedidos,
               AVG(p.total) AS valor_medio_pedido,
               SUM(p.total) AS valor_total_gasto
        FROM usuarios u
        JOIN pedido p ON p.id_usuario = u.id
        GROUP BY u.id, u.nome;
        """
        self.executar_consulta(sql, "12. Estatísticas de Compras por Cliente")
    
    def consulta_13_relatorio_mensal(self):
        sql = """
        SELECT TO_CHAR(p.data, 'MM/YYYY') AS periodo,
               COUNT(DISTINCT p.id) AS qtd_pedidos,
               COUNT(DISTINCT ip.id_produto) AS produtos_diferentes,
               SUM(p.total) AS faturamento
        FROM pedido p
        JOIN itens_pedido ip ON ip.id_pedido = p.id
        GROUP BY periodo
        ORDER BY periodo;
        """
        self.executar_consulta(sql, "13. Relatório Mensal de Vendas")
    
    def consulta_14_produtos_nao_vendidos(self):
        sql = """
        SELECT pr.id, pr.nome, pr.categoria
        FROM produto pr
        WHERE pr.ativo = TRUE
        AND NOT EXISTS (
            SELECT 1 FROM itens_pedido ip WHERE ip.id_produto = pr.id
        );
        """
        self.executar_consulta(sql, "14. Produtos que Nunca Foram Vendidos")
    
    def consulta_15_ticket_medio_categoria(self):
        sql = """
        SELECT pr.categoria,
               AVG(ip.preco * ip.quantidade) AS ticket_medio
        FROM pedido p
        JOIN itens_pedido ip ON ip.id_pedido = p.id
        JOIN produto pr ON pr.id = ip.id_produto
        WHERE p.status != 'Cancelado'
        GROUP BY pr.categoria;
        """
        self.executar_consulta(sql, "15. Análise de Ticket Médio por Categoria")
    
    # ========================================
    # MENUS 
    # ======================================== 
    def menu_exercicios(self):
        while True:            
            print("=" * 40)
            print("1. Listagem de Usuários Ativos")
            print("2. Catálogo de Produtos por Categoria")
            print("3. Contagem de Pedidos por Status")
            print("4. Alerta de Estoque Baixo")
            print("5. Histórico de Pedidos Recentes")
            print("6. Produtos Mais Caros por Categoria")
            print("7. Clientes com Dados Incompletos")
            print("8. Pedidos Pendentes de Entrega")
            print("9. Detalhamento Completo de Pedidos")
            print("10. Ranking dos Produtos Mais Vendidos")
            print("11. Análise de Clientes Sem Compras")
            print("12. Estatísticas de Compras por Cliente")
            print("13. Relatório Mensal de Vendas")
            print("14. Produtos que Nunca Foram Vendidos")
            print("15. Análise de Ticket Médio por Categoria")            
            print("0. Voltar ao Menu Principal")
            print("=" * 40)
            
            opcao = input("Escolha uma opção: ").strip()
            
            if opcao == "1":
                self.consulta_01_usuarios_ativos()
            elif opcao == "2":
                self.consulta_02_produtos_categoria()
            elif opcao == "3":
                self.consulta_03_pedidos_status()
            elif opcao == "4":
                self.consulta_04_estoque_baixo()
            elif opcao == "5":
                self.consulta_05_pedidos_recentes()
            elif opcao == "6":
                self.consulta_06_produtos_caros_categoria()
            elif opcao == "7":
                self.consulta_07_contatos_incompletos()
            elif opcao == "8":
                self.consulta_08_pedidos_enviados()
            elif opcao == "9":
                self.consulta_09_detalhamento_pedido()
            elif opcao == "10":
                self.consulta_10_ranking_produtos()
            elif opcao == "11":
                self.consulta_11_clientes_sem_compras()
            elif opcao == "12":
                self.consulta_12_estatisticas_cliente()
            elif opcao == "13":
                self.consulta_13_relatorio_mensal()
            elif opcao == "14":
                self.consulta_14_produtos_nao_vendidos()
            elif opcao == "15":
                self.consulta_15_ticket_medio_categoria()                
            elif opcao == "0":
                break
            else:
                print("Opção inválida!")
            
            input("\nPressione ENTER para continuar...")

def main():
    cli = SistemaVendasCLI()
    if cli.conectar_banco():
        try:
            cli.menu_exercicios()
        finally:
            cli.desconectar_banco()
    else:
        print("Falha ao conectar ao banco de dados.")
        sys.exit(1)

if __name__ == "__main__":
    main()
