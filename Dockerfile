FROM            redhat/ubi9 AS newrelic_source
WORKDIR         /opt
RUN             dnf install unzip -y
RUN             curl -O https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip
RUN             unzip newrelic-java.zip


FROM            redhat/ubi9
RUN             dnf install java-21-openjdk -y
RUN             useradd java
USER            java
WORKDIR         /home/java
COPY            target/shipping-1.0.jar shipping.jar
COPY            --from=newrelic_source /opt/newrelic/ /home/java/newrelic/
COPY            run.sh /
ENTRYPOINT      [ "bash", "/run.sh" ]

####
