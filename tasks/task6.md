# Step 5 - Data analytics engine

When building a data platform, how would you process non-tabular data such as images?
What about training AI models?

While SQL Analytics engines offer the possibility for data analysts to run SQL code on top of tabular data,
a general purpose data analytics engine offers users code to manipulate or process data.

In this tutorial, we will set up [Apache Spark](https://spark.apache.org/) as a data analytics engine and connect to it.

1. Set up a Spark Master node by adding the below code to docker-compose.yaml

```
  spark-master:
    hostname: spark-master
    container_name: spark-master
    image: bitnami/spark:3.5.1
    command: bin/spark-class org.apache.spark.deploy.master.Master
    volumes:
      - ./spark-apps:/opt/spark-apps
      - ./config/spark/spark-defaults.master.conf:/opt/bitnami/spark/conf/spark-defaults.conf
      - ./config/spark/hive-site.xml:/opt/bitnami/spark/conf/hive-site.xml
      - ./libs/spark-connect_2.12-3.5.1.jar:/opt/spark/jars/spark-connect_2.12-3.5.1.jar
      - ./spark-data:/opt/spark/work-dir/spark-warehouse/data:rw
    ports:
      - 4040:4040
      - 8080:8080
      - 7077:7077
      - 12000:12000
    networks:
      - platform-network
```


2. Set up a Spark worker node by adding the code below to docker-compose.yaml

```
  spark-worker-1:
    hostname: spark-worker-1
    container_name: spark-worker-1
    image: bitnami/spark:3.5.1
    volumes:
      - ./config/spark/spark-defaults.master.conf:/opt/bitnami/spark/conf/spark-defaults.conf
      - ./config/spark/hive-site.xml:/opt/bitnami/spark/conf/hive-site.xml
    command: bin/spark-class org.apache.spark.deploy.worker.Worker spark://spark-master:7077
    depends_on:
      - spark-master
    ports:
      - 4041:4040
      - 8081:8081
    environment:
      SPARK_MODE: worker
      SPARK_WORKER_CORES: 2
      SPARK_WORKER_MEMORY: 5g
      SPARK_MASTER_URL: spark://spark-master:7077
    networks:
      - platform-network
```

3. Set up Jupyter Notebooks in you docker-compose.yaml file
```
  jupyter:
    image: quay.io/jupyter/pyspark-notebook:spark-3.5.1
    volumes:
      - ./work:/home/jovyan/work
      - ./libs/hadoop-aws-3.3.4.jar:/usr/local/spark-3.5.1-bin-hadoop3/jars/hadoop-aws-3.3.4.jar
      - ./libs/aws-java-sdk-bundle-1.12.772.jar:/usr/local/spark-3.5.1-bin-hadoop3/jars/aws-java-sdk-bundle-1.12.772.jar
      - ./libs/delta-spark_2.12-3.2.0.jar:/usr/local/spark-3.5.1-bin-hadoop3/jars/delta-spark_2.12-3.2.0.jar
    ports:
      - 4042:4040
      - 8888:8888
      - 8000:8000
    container_name: jupyter_notebook
    command: "start-notebook.sh --NotebookApp.token="
    networks:
      - platform-network
```

4. `docker compose down`
5. `docker compose up` and wait for all services to boot up
6. Open Jupyter Notebook on [https://localhost:8888](https://localhost:8888)
7. Run 


If you are done, move on to [task 7](./task7.md)