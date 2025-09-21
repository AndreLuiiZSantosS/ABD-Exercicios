# Sistema de Agendamento de Laboratórios

Este projeto tem como objetivo desenvolver um sistema de agendamento de laboratórios para a Direção da DIATINF. O sistema permitirá que professores e alunos reservem laboratórios de forma eficiente, gerenciando as reservas e a retirada/entrega de chaves.

## Estrutura do Projeto

O projeto é organizado da seguinte forma:

- **docs/**: Contém a documentação do sistema, incluindo:
  - `elementos-conceituais.md`: Lista dos elementos conceituais do domínio do problema, com descrições detalhadas.
  - `modelo-conceitual.md`: Modelo conceitual do sistema, representando graficamente as entidades e seus relacionamentos.
  - `modelo-logico.md`: Modelo lógico do sistema, apresentando o Diagrama Entidade-Relacionamento (DER).
  - `modelo-fisico.md`: Modelo físico do banco de dados, com detalhes sobre a implementação das tabelas.

- **sql/**: Contém os scripts SQL necessários para a criação e manipulação do banco de dados, incluindo:
  - `criacao_banco.sql`: Script para a criação do banco de dados e das tabelas.
  - `insercao_dados.sql`: Script para popular as tabelas com dados fictícios.
  - `consultas.sql`: Script com consultas que demonstram o uso de JOINs, GROUP BY, HAVING, ORDER BY e WHERE.

## Instruções de Uso

1. **Criação do Banco de Dados**: Execute o script `sql/criacao_banco.sql` para criar o banco de dados e as tabelas necessárias.
2. **Inserção de Dados**: Após a criação do banco, execute o script `sql/insercao_dados.sql` para popular as tabelas com dados de teste.
3. **Consultas**: Utilize o script `sql/consultas.sql` para realizar consultas relevantes no banco de dados.

## Modelos

- [Modelo Conceitual](docs/modelo-conceitual.md)
- [Modelo Lógico](docs/modelo-logico.md)
- [Modelo Físico](docs/modelo-fisico.md)

## Imagens do Banco

Imagens do banco criado no PostgreSQL podem ser incluídas aqui para melhor visualização da estrutura.

## Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou pull requests.