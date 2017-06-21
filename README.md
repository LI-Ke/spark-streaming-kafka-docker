<h1>dockerize Spark Streaming and Kafka</h1>

<h2>Preparation</h2>

<p>To run a <b>sbt</b> projet concerning spark streaming and kafka in a docker container is not easy. Here I will show you clearly to do it!</p>

<p>Firstly, you should make a executable jar file with the dependencies of <b>"spark streaming kafka"</b> but without dependencies of "spark core", "spark sql" and "spark streaming". Do do this, you can see the build.sbt file and the configuration files projet directory.</p>

<h2>Dockerizing the application</h2>

<h3>Container</h3>

<p>Do into this project where you can find the Dockerfile. Run the following command to build an image, named <b>streaming</b>, of the container<br></p>

```docker build -t streaming .```



<p>Launch this container<br></p>

```docker run --rm -i -t streaming```


<h3>Kafka</h3>

<p>Open another terminal, run this command to find the running container id<br>
<b>docker ps</b></p>

<p>Go into the running container<br>
<b>docker exec -it "container_id" bash</b></p>

<p>Launch zookeeper<br>
<b>kafka/bin/zookeeper-server-start.sh kafka/config/zookeeper.properties</b></p>

<p>Open another terminal to launch kafka<br>
<b>docker exec -it "container_id" bash</b><br>
<b>kafka/bin/zookeeper-server-start.sh kafka/config/zookeeper.properties</b></p>


<p>Open another terminal to create a topic<br>
<b>docker exec -it "container_id" bash</b><br>
<b>kafka/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic S-1i</b></p>

<h3>Spark</h3>
<p>Open another terminal to run the spark streaming application<br>
<b>docker exec -it "container_id" bash</b><br>
<b>spark-submit --master local --class sparkStreaming.DirectKafkaRDF streaming.jar kafka:9092 S-1i</b></p>

