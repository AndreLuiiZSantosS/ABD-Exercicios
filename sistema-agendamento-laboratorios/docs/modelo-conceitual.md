# Modelo Conceitual do Sistema de Agendamento de Laboratórios

O modelo conceitual do sistema de agendamento de laboratórios é uma representação gráfica das entidades e seus relacionamentos, com base nos elementos conceituais definidos. As principais entidades do sistema incluem:

## Entidades

1. **Laboratório**
   - Descrição: Representa os laboratórios disponíveis para agendamento.
   - Atributos: ID do Laboratório, Nome, Capacidade, Equipamentos Disponíveis.

2. **Professor**
   - Descrição: Representa os professores que podem agendar os laboratórios.
   - Atributos: ID do Professor, Nome, Departamento, E-mail.

3. **Reserva**
   - Descrição: Representa as reservas feitas pelos professores para utilização dos laboratórios.
   - Atributos: ID da Reserva, ID do Laboratório, ID do Professor, Data e Hora de Início, Data e Hora de Término.

4. **Retirada/Entrega de Chave**
   - Descrição: Representa o processo de retirada e entrega das chaves dos laboratórios.
   - Atributos: ID da Retirada, ID da Reserva, Data e Hora da Retirada, Data e Hora da Entrega.

5. **Atividade Extra**
   - Descrição: Representa atividades adicionais que podem ser realizadas nos laboratórios.
   - Atributos: ID da Atividade, Descrição, ID do Laboratório, Data e Hora.

## Relacionamentos

- **Professor - Reserva**: Um professor pode fazer várias reservas, mas cada reserva é feita por um único professor. (1:N)
- **Laboratório - Reserva**: Um laboratório pode ter várias reservas, mas cada reserva é para um único laboratório. (1:N)
- **Reserva - Retirada/Entrega de Chave**: Cada reserva pode ter uma retirada e entrega de chave associada. (1:1)
- **Laboratório - Atividade Extra**: Um laboratório pode ter várias atividades extras, mas cada atividade extra é realizada em um único laboratório. (1:N)

## Diagrama

[Inserir Diagrama do Modelo Conceitual Aqui]

Este modelo conceitual serve como base para o desenvolvimento do modelo lógico e físico do banco de dados, garantindo que todas as entidades e relacionamentos necessários para o sistema de agendamento de laboratórios sejam considerados.