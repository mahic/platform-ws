# Step 5 - Analytics query engine

When building a data platform, usually you would need a tool to query your data.
There is a plethora of such tools such as [PrestoDB](https://prestodb.io/), [Trino](https://trino.io/), [StarRocks](https://www.starrocks.io/), [ClickHouse](https://clickhouse.com/) as well as a [large Apache community](https://projects.apache.org/projects.html?category#big-data)

In this tutorial, we will set up Trino](https://trino.io/)

1. Go to Keycloak and create a new OIDC client in the master realm. This will be used to configure Trino authentication
```
Client ID: trino
Client Secret: 1ouEjqXiwJ0GnGaa5xMtRaHt5HiXFfaO
```

2. We need some generated data. Add the code below to your docker-compose.yaml file

```
  postgres-data1-trino:
    image: metabase/qa-databases:postgres-sample-12
    container_name: postgres-data1-trino
    hostname: postgres-data1
    networks: 
      - platform-network
    cpus: 1
    mem_limit: 128m
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U metabase -d sample"]
      interval: 10s
      timeout: 5s
      retries: 5
    command: -c log_statement=all
  mysql-data1-trino:
    image: metabase/qa-databases:mysql-sample-8
    container_name: mysql-data1-trino
    hostname: mysql-data1
    ports:
    - 3306:3306
    networks: 
      - platform-network
    cpus: 1
    mem_limit: 512m
    command: --general-log=1
```

3. Then, we need to set up the Trino service. Add the below code to the docker-compose.yaml
```
  trino:
    build: 
      context: .
      dockerfile: ./containers/trino/Dockerfile
    container_name: trino-server
    hostname: trino-server
    user: root
    volumes: 
    - /$PWD/configs/trino/config.properties:/etc/trino/config.properties
    - /$PWD/configs/trino/jvm.properties:/etc/trino/jvm.properties
    - /$PWD/configs/trino/log.properties:/etc/trino/log.properties
    - /$PWD/certs/platform.local.pem:/etc/trino/tls.pem
    - /$PWD/configs/trino/postgres.properties:/etc/trino/catalog/postgres.properties
    - /$PWD/configs/trino/mysql.properties:/etc/trino/catalog/mysql.properties
    - /$PWD/configs/trino/delta1.properties:/etc/trino/catalog/delta1.properties
    - /$PWD/configs/trino/delta2.properties:/etc/trino/catalog/delta2.properties
    networks:
      - platform-network
    ports:
      - 8085:8085
      - 8444:8444
    depends_on:
      - keycloak_web
    healthcheck:
      test: /usr/lib/trino/bin/health-check
      interval: 30s
      timeout: 30s
      retries: 5
      start_period: 30s
```

4. `docker compose down`
5. `docker compose up` and wait for all services to boot up
6. Open DBeaver, set up a new connection to the Trino service.
```
Main -> Hostname: trino.platform.local
Main -> Port: 8444

Driver properties -> SSL: true
Driver properties -> externalAuthentication: true
Driver properties -> externalAuthenticationTokenCache: MEMORY
Driver properties -> Add custom user property called "SSLVerification" with the value "NONE"
```
7. Connect to Trino
8. Make a query `SELECT COUNT(*) FROM tpch.tiny.orders`

If you are done, move on to [task 6](./task6.md)