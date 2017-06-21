# dockerize Spark Streaming and Kafka

<h1>Preparation<h1/>

<p>To run a <b>sbt<b/> projet concerning spark streaming and kafka in a docker container is not easy. Here I will show you clearly to do it!<p/>

<p>Firstly, you should make a executable jar file with the dependencies of <b>"spark streaming kafka"</b> but without dependencies of "spark core", "spark sql" and "spark streaming". Do do this, you can see the build.sbt file and the configuration files projet directory.<p/>

<h1>Dockerizing the application<h1/>

<h2>Container<h2/>

<p>Do into this project where you can find the Dockerfile. Run the following command to build an image, named <b>streaming<b/>, of the container<p/>
docker build -t streaming .

<p>Launch this container<p/>
docker run --rm -i -t streaming

<h2>Kafka<h2/>

<p>Open another terminal, run this command to find the running container id<p/>
docker ps

<p>Go into the running container<p/>
docker exec -it "container_id" 

<p>Launch zookeeper<p/>
kafka/bin/zookeeper-server-start.sh kafka/config/zookeeper.properties

<p>Open another terminal to launch kafka<p/>
docker exec -it "container_id" <br>
kafka/bin/zookeeper-server-start.sh kafka/config/zookeeper.properties


<p>Open another terminal to create a topic<p/>
docker exec -it "container_id" <br>
kafka/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic S-1i


<p>Open another terminal to run the spark streaming application<p/>
docker exec -it "container_id" <br>
spark-submit --master local --class sparkStreaming.DirectKafkaRDF streaming.jar kafka:9092 S-1i

