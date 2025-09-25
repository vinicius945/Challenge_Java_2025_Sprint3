# Stage 1: build com JDK 21 + Maven
FROM eclipse-temurin:21-jdk AS build

# Instala Maven
RUN apt-get update && apt-get install -y maven

WORKDIR /app

# Copia os arquivos do projeto
COPY pom.xml .
COPY src ./src

# Compila o projeto sem rodar testes
RUN mvn clean install -DskipTests

# Stage 2: imagem final mais leve
FROM eclipse-temurin:21-jdk-jammy

WORKDIR /app
EXPOSE 8080

# Copia o JAR gerado do stage de build
COPY --from=build /app/target/Challenge_Java_2025_Sprint3-0.0.1-SNAPSHOT.jar app.jar

# Comando para rodar a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]
