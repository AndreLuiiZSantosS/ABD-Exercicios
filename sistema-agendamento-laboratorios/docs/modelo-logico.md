# Modelo Lógico do Sistema de Agendamento de Laboratórios

## Tabelas e Relacionamentos

### Tabela: Laboratório
- **id_laboratorio** (PK): Identificador único do laboratório.
- **nome**: Nome do laboratório.
- **capacidade**: Capacidade máxima do laboratório.
- **equipamentos**: Equipamentos disponíveis no laboratório.

### Tabela: Professor
- **id_professor** (PK): Identificador único do professor.
- **nome**: Nome do professor.
- **departamento**: Departamento ao qual o professor pertence.

### Tabela: Reserva
- **id_reserva** (PK): Identificador único da reserva.
- **id_laboratorio** (FK): Identificador do laboratório reservado.
- **id_professor** (FK): Identificador do professor que fez a reserva.
- **data_hora_inicio**: Data e hora de início da reserva.
- **data_hora_fim**: Data e hora de fim da reserva.

### Tabela: Retirada_Entrega_Chave
- **id_retirada_entrega** (PK): Identificador único da retirada/entrega de chave.
- **id_laboratorio** (FK): Identificador do laboratório.
- **id_professor** (FK): Identificador do professor.
- **data_hora_retirada**: Data e hora da retirada da chave.
- **data_hora_entrega**: Data e hora da entrega da chave.

### Tabela: Atividade_Extra
- **id_atividade** (PK): Identificador único da atividade extra.
- **id_laboratorio** (FK): Identificador do laboratório onde a atividade será realizada.
- **descricao**: Descrição da atividade extra.
- **data_hora**: Data e hora da atividade extra.

## Relacionamentos
- Um **Laboratório** pode ter várias **Reservas**.
- Um **Professor** pode fazer várias **Reservas**.
- Um **Laboratório** pode ter várias **Retiradas/Entregas de Chave**.
- Um **Professor** pode realizar várias **Retiradas/Entregas de Chave**.
- Um **Laboratório** pode ter várias **Atividades Extras**.