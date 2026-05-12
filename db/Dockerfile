FROM          docker.io/redhat/ubi9
RUN           dnf install mysql -y
RUN           useradd roboshop
USER          roboshop
WORKDIR       /home/roboshop
COPY          app-user.sql master-data.sql schema.sql run.sh /home/roboshop/
ENTRYPOINT    [ "bash", "run.sh" ]


