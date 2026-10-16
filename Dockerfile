# Build stage runs on the CI runner's native arch (the jar is arch-independent)
FROM --platform=$BUILDPLATFORM eclipse-temurin:21-jdk AS builder
WORKDIR /app
COPY . .
RUN chmod +x ./mvnw && ./mvnw clean package -e -DskipTests

# Run stage (built for amd64 and arm64)
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8081
CMD ["java", "-jar", "app.jar"]
