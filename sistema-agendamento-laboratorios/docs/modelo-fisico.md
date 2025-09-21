### Tabelas

#### Laboratórios
- **Nome da Tabela**: laboratorios
- **Colunas**:
  - id (INT, PK, AUTO_INCREMENT)
  - nome (VARCHAR(100), NOT NULL)
  - capacidade (INT, NOT NULL)
  - localizacao (VARCHAR(100), NOT NULL)

#### Professores
- **Nome da Tabela**: professores
- **Colunas**:
  - id (INT, PK, AUTO_INCREMENT)
  - nome (VARCHAR(100), NOT NULL)
  - departamento (VARCHAR(100), NOT NULL)

#### Reservas
- **Nome da Tabela**: reservas
- **Colunas**:
  - id (INT, PK, AUTO_INCREMENT)
  - laboratorio_id (INT, FK -> laboratorios.id, NOT NULL)
  - professor_id (INT, FK -> professores.id, NOT NULL)
  - data_reserva (DATETIME, NOT NULL)
  - duracao (INT, NOT NULL)  // duração em horas

#### Retiradas_Entregas_Chaves
- **Nome da Tabela**: retiradas_entregas_chaves
- **Colunas**:
  - id (INT, PK, AUTO_INCREMENT)
  - reserva_id (INT, FK -> reservas.id, NOT NULL)
  - data_retirada (DATETIME, NOT NULL)
  - data_entrega (DATETIME, NOT NULL)

#### Atividades_Extras
- **Nome da Tabela**: atividades_extras
- **Colunas**:
  - id (INT, PK, AUTO_INCREMENT)
  - laboratorio_id (INT, FK -> laboratorios.id, NOT NULL)
  - descricao (VARCHAR(255), NOT NULL)
  - data_atividade (DATETIME, NOT NULL)

### Índices e Restrições
- **Chaves Primárias**: Definidas para cada tabela através da coluna `id`.
- **Chaves Estrangeiras**: Implementadas nas tabelas `reservas`, `retiradas_entregas_chaves` e `atividades_extras` para garantir a integridade referencial.
- **Índices**: Criados em colunas frequentemente consultadas, como `data_reserva` e `laboratorio_id`, para otimizar o desempenho das consultas.

### Considerações Finais
Este modelo físico foi projetado para atender às necessidades do sistema de agendamento de laboratórios, garantindo a integridade dos dados e a eficiência nas operações de consulta e manipulação.