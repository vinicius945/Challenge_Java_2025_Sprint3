# 🚗 Gestão de Frota API

API de Gestão de Frotas. Projeto desenvolvido com **Spring Boot** usando boas práticas de arquitetura REST, DTOs, mapeadores, cache, paginação e banco de dados **H2 em memória**.

---

## 📦 Tecnologias utilizadas

- ✅ Java 21
- ✅ Spring Boot 3.4.5
- ✅ Spring Data JPA
- ✅ Spring Web
- ✅ Banco de dados H2 (em memória)
- ✅ Hibernate Validator
- ✅ Maven
- ✅ Cache com `@Cacheable`
- ✅ DTO + Entity + Mapper
- ✅ Paginação com `Pageable`

---

## 🧱 Estrutura da API

A API está dividida em dois recursos principais:

### 🏍️ Motos (`/motos`)
- **GET** `/motos`: Lista todas as motos com paginação e filtro por placa.
- **POST** `/motos`: Cadastra uma nova moto.
- **PUT** `/motos/{id}`: Atualiza uma moto existente.
- **DELETE** `/motos/{id}`: Remove uma moto pelo ID.

### 🅿️ Pátios (`/patios`)
- **GET** `/patios`: Lista todos os pátios.
- **POST** `/patios`: Cadastra um novo pátio.
- **PUT** `/patios/{id}`: Atualiza um pátio existente.
- **DELETE** `/patios/{id}`: Remove um pátio pelo ID.

---

## 🗃️ Banco de dados H2

- A aplicação utiliza banco de dados em memória (H2).
- A tabela é criada automaticamente pelo JPA.
- Dados iniciais podem ser inseridos automaticamente com o arquivo `import.sql`.

### 🛠️ Inserindo dados automaticamente

Crie o arquivo `src/main/resources/import.sql` com dados como:

```sql
INSERT INTO patio (nome, endereco, telefone) VALUES ('Pátio Butantã', 'Av. Valdemar Ferreira, 136 – Butantã, São Paulo – SP, 05501-010', 1131818188);
INSERT INTO patio (nome, endereco, telefone) VALUES ('Pátio Limão', 'Av. Prof. Celestino Bourroul, 363 – Limão, São Paulo – SP, 02710-000', 1131818188);

INSERT INTO moto (marca, modelo, placa, ano, numero_iot, patio_id) VALUES ('HONDA', 'POP', 'TMJ9E65', 2025, 98527, 1);
INSERT INTO moto (marca, modelo, placa, ano, numero_iot, patio_id) VALUES ('TVS', 'SPORT', 'SVS8H56', 2024, 91452, 2);
INSERT INTO moto (marca, modelo, placa, ano, numero_iot, patio_id) VALUES ('HONDA', 'POP', 'SUY1I63', 2023, 79636, 1);
INSERT INTO moto (marca, modelo, placa, ano, numero_iot, patio_id) VALUES ('TVS', 'SPORT', 'SWO7J61', 2024, 88320, 2);
INSERT INTO moto (marca, modelo, placa, ano, numero_iot, patio_id) VALUES ('VMOTO', 'VS1', 'SWM8B74', 2024, 89041, 1);
```

---

## 🔎 Acessando o H2 Console

- 🌐 URL: http://localhost:8080/h2-console
- JDBC URL: `jdbc:h2:mem:gestaofrota`
- User: `sa`
- Password: *(deixe em branco)*

---

## 🚀 Como executar o projeto

1. Clone o repositório:
- `git clone https://github.com/olucso/challenge-sprint-1-java-advanced.git`
- `cd gestao-frota`

2. Compile e rode o projeto:
- `./mvnw spring-boot:run`

3. Acesse os endpoints via Postman ou navegador:
- `http://localhost:8080/motos`
- `http://localhost:8080/patios`

---

## 📖 Boas práticas aplicadas

- ✅ Separação clara entre `Entity`, `DTO`, `Mapper` e `Service`
- ✅ Uso de `@Valid` para validações de entrada
- ✅ Lógica de atualização segura com `findById` + `save`
- ✅ Mensagens de erro claras com `EntityNotFoundException`
- ✅ Cache com `@Cacheable` no serviço de listagem
- ✅ Paginação e filtros por query

---

## 👨‍💻 Autores
Desenvolvido pelo grupo LTAKN:
- RM: 557937  –  Enzo Prado Soddano
- RM: 556564  –  Lucas Resende Lima
- RM: 559183  –  Vinicius Prates Altafini
