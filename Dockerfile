# Stage 1 — Build the JAR using Maven
# CI-compatible: builds the JAR inside Docker, no pre-built artifacts needed.
# New Relic agent removed — requires paid license key, not needed for lab.
FROM            maven:3.9-eclipse-temurin-21 AS builder
WORKDIR         /build
COPY            pom.xml ./
# Dependencies cached separately — only re-downloads if pom.xml changes
RUN             mvn dependency:go-offline -q
COPY            src/ ./src/
RUN             mvn package -DskipTests -q

# Stage 2 — Lightweight runtime image
FROM            eclipse-temurin:21-jre
RUN             useradd -m java
USER            java
WORKDIR         /home/java
COPY            --from=builder /build/target/shipping-1.0.jar shipping.jar
COPY            run.sh /
ENTRYPOINT      [ "bash", "/run.sh" ]
