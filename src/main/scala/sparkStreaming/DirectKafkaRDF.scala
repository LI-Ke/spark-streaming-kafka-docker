package sparkStreaming

/**
  * Created by LI Ke on 10/05/2017.
  */
import kafka.serializer.StringDecoder
import org.apache.spark.streaming._
import org.apache.spark.streaming.kafka._
import org.apache.spark.SparkConf
import org.apache.spark.sql.SparkSession

object DirectKafkaRDF {
  def main(args: Array[String]): Unit = {
    println("Hello Spark Streaming!")
    val sparkConf = new SparkConf().setAppName("DirectKafkaWordCount").setMaster("local[*]")
    val ssc = new StreamingContext(sparkConf, Seconds(1))
    val sparkSession = SparkSession.builder.master("local[*]").appName("Receiver").getOrCreate()
    import sparkSession.implicits._

    val brokers = "localhost:9092"
    val topics = "S-1i"
    // Create direct kafka stream with brokers and topics
    val topicsSet = topics.split(",").toSet
    val kafkaParams = Map[String, String]("metadata.broker.list" -> brokers)
    val messages = KafkaUtils.createDirectStream[String, String, StringDecoder, StringDecoder](
      ssc, kafkaParams, topicsSet)

    // Get the lines, split them into words, count the words and print
    val lines = messages.map(_._2)
    val words = lines.map(_.split(" ")).foreachRDD{rdd =>
      {
        val df = rdd.map(x => (x(0),x(1),x(2))).toDF("s","p","o")
        df.show(20)
      }
    }
    // Start the computation
    ssc.start()
    ssc.awaitTermination()
  }
}
