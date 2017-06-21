FROM phusion/baseimage

MAINTAINER li_ke@yahoo.com

# Environment
ENV SCALA_VERSION 2.11
ENV SBT_VERSION 0.13.0
ENV KAFKA_VERSION 0.8.2.2
ENV SPARK_VERSION 2.1.0
ENV HADOOP_VERSION 2.7
ENV SPARK_HOME /usr/local/spark

ENV HOME /usr/local
WORKDIR $HOME


# Install Java
RUN add-apt-repository ppa:webupd8team/java -y  && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    apt-get --allow-unauthenticated install -y  oracle-java8-installer && \
    apt-get clean

# Install Scala 
RUN wget https://downloads.typesafe.com/scala/${SCALA_VERSION}.11/scala-${SCALA_VERSION}.11.tgz && \
    tar -xvzf scala-${SCALA_VERSION}.11.tgz && \
    mv scala-${SCALA_VERSION}.11 scala && \
    rm scala-${SCALA_VERSION}.11.tgz

# Install SBT 
RUN wget https://dl.bintray.com/sbt/native-packages/sbt/${SBT_VERSION}/sbt-${SBT_VERSION}.tgz && \
    tar -xvzf sbt-${SBT_VERSION}.tgz && \
    rm sbt-${SBT_VERSION}.tgz


# Install Kafka
RUN wget http://mirrors.dotsrc.org/apache/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    tar -xvzf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    mv kafka_${SCALA_VERSION}-${KAFKA_VERSION} kafka && \
    rm kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz


# Install Spark
RUN cd /tmp && \
    wget http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar -xvzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /usr/local && \
    rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
RUN cd /usr/local && ln -s spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark

# Configure environment variables
ENV PATH $HOME/scala/bin:$HOME/sbt/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin:$HOME/kafka/bin:$PATH


# Spark Kafka Streaming
RUN cd /tmp && \
    wget http://repo1.maven.org/maven2/org/apache/spark/spark-streaming-kafka-0-8-assembly_${SCALA_VERSION}/${SPARK_VERSION}/spark-streaming-kafka-0-8-assembly_${SCALA_VERSION}-${SPARK_VERSION}.jar && \
    mv spark-streaming-kafka-0-8-assembly_${SCALA_VERSION}-${SPARK_VERSION}.jar /usr/local/spark/jars

# Deploy a spark streaming application on spark
ADD streaming.jar $HOME 


EXPOSE 2128 9092 4040

