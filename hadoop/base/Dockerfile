FROM ubuntu:14.04

WORKDIR /root

# install openssh-server, wget, openjdk. 
RUN apt-get update && \
    apt-get install -y openssh-server wget openjdk-7-jdk

# install hadoop 2.7.2
RUN wget https://github.com/kiwenlau/compile-hadoop/releases/download/2.7.2/hadoop-2.7.2.tar.gz && \
    tar -xzvf hadoop-2.7.2.tar.gz && \
    mv hadoop-2.7.2 /usr/local/hadoop && \
    rm hadoop-2.7.2.tar.gz

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64 \
    HADOOP_HOME=/usr/local/hadoop

ENV PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

CMD [ "sh", "-c", "service ssh start; bash"]