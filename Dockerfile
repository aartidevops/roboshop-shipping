# Stage 1 — Download New Relic Java agent
FROM            redhat/ubi9 AS newrelic_source
WORKDIR         /opt
RUN             dnf install unzip curl -y
RUN             curl -O https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip
RUN             unzip newrelic-java.zip

# Stage 2 — Build the JAR using Maven
# Previously expected pre-built JAR from local machine (target/shipping-1.0.jar)
# which breaks in CI. Maven builds it inside Docker instead.
FROM            maven:3.9-eclipse-temurin-21 AS builder
WORKDIR         /build
COPY            pom.xml ./
# Download dependencies first (cached layer — only re-runs if pom.xml changes)
RUN             mvn dependency:go-offline -q
COPY            src/ ./src/
RUN             mvn package -DskipTests -q

# Stage 3 — Runtime image
FROM            redhat/ubi9
RUN             dnf install java-21-openjdk -y
RUN             useradd java
USER            java
WORKDIR         /home/java
COPY            --from=builder /build/target/shipping-1.0.jar shipping.jar
COPY            --from=newrelic_source /opt/newrelic/ /home/java/newrelic/
COPY            run.sh /
ENTRYPOINT      [ "bash", "/run.sh" ]
