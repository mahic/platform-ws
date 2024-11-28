# Step 4 - Metadata catalogs

When building a data platform, when operating on tabular data across many different tools such as Iceberg, Jupyter, Spark, Trino, there is a need for users to be able to see the same data across these tools.

This is usually handled by a tool that can manage metadata such as catalog, schema, table, column, function, partition and clustering information. These tools are called **metadata catalogs**.

Some of these tools are [Unity Catalog](https://www.unitycatalog.io/), [Apache Polaris](https://github.com/apache/polaris) and [Apache Hive Metastore](https://hive.apache.org/). Some Open Table formats such as [Apache Iceberg](https://iceberg.apache.org/) have their own metastore implementations based on REST or JDBC.

In this task we will set up [Apache Hive Metastore](https://hive.apache.org/), an Open Source service to serve our needs as a metadata catalog. A brief explanation of Hive Metastore can be found [here](https://blog.devgenius.io/hive-metastore-a9dc9e139cf2)

1. Firstly, Hive Metastore needs a database to store its data. Add the below code to the docker-compose.yaml file

```
  postgres:
    hostname: postgres
    container_name: postgres
    image: postgres:11
    ports:
      - 5432:5432
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: admin
      POSTGRES_DB: xv
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U admin -d metastore_db"]
      interval: 1s
      timeout: 10s
      retries: 10
    volumes:
      - ./data/postgres/keycloak:/var/lib/postgresql/data
    networks:
      - platform-network
```

2. Then, we need to set up the Hive Metastore Service. Add the below code to the docker-compose.yaml
```
  hive-metastore:
    hostname: hive-metastore
    container_name: hive-metastore
    build: 
      context: .
      dockerfile: ./containers/hive/Dockerfile
    ports:
      - 9083:9083
    environment:
      SERVICE_NAME: metastore
      DB_DRIVER: postgres
      HIVE_CUSTOM_CONF_DIR: /opt/hive/conf
    volumes:
      - ./configs/hive/hive-site.xml:/opt/hive/conf/hive-site.xml
      - ./configs/hive/entrypoint.sh:/opt/hive/conf/entrypoint.sh
      - ./libs/hadoop-aws-3.2.4.jar:/opt/hive/lib/hadoop-aws-3.2.4.jar
      - ./libs/aws-java-sdk-bundle-1.12.772.jar:/opt/hive/lib/aws-java-sdk-bundle-1.12.772.jar
    depends_on:
      createbuckets:
        condition: service_started
      postgres:
        condition: service_healthy
    networks:
      - platform-network
```

3. `docker compose down`
4. `docker compose up` and wait for all services to boot up
5. Download and install [DBeaver](https://dbeaver.io/download/). DBeaver is a tool we will use in later tasks as well.
6. Open DBeaver, set up a new connection to the Postgres database created in step 1.
```
Hostname: localhost
Port: 5433
Database: metastore_db
Username/password: admin/admin
```
7. Connect to the database
8. Verify that the schema for the Hive Metastore Service is installed. 
The schema should have a list of tables that Hive Schematool generates when Hive boots up

If you are done, move on to [task 5](./task5.md)