# Step 5 - Visualization

When building a data platform, it is silly to just analyze data. You need to visualize it as well.

In this tutorial, we will set up [Metabase](https://www.metabase.com/) and connect to it.

1. Set up Metabase

```
  metabase:
    build: 
      context: .
      dockerfile: ./containers/metabase/Dockerfile
    container_name: metabase-trino
    hostname: metabase-trino
    environment:
      - JAVA_OPTS=-XX:MaxRAMPercentage=90
    volumes: 
    - /dev/urandom:/dev/random:ro
    ports:
     - 3000:3000
    networks: 
      - platform-network
    healthcheck:
      test: curl --fail -I http://localhost:3000/api/health || exit 1
      interval: 15s
      timeout: 5s
      retries: 5
    depends_on:
      postgres-data1-trino:
        condition: service_healthy
    cpus: 2
    mem_limit: 512m
  setup-trino:
    image: bash:5.1.16
    container_name: setup-trino
    volumes:
      - $PWD/containers/metabase/metabase-setup.sh:/tmp/metabase-setup.sh
    networks:
      - platform-network
    depends_on:
      metabase:
        condition: service_healthy
      trino:
        condition: service_healthy
    command: sh /tmp/metabase-setup.sh metabase-trino:3000
    cpus: 1
    mem_limit: 128m
```

2. `docker compose down`
3. `docker compose up` and wait for all services to boot up
4. Open Metabase GUI on [https://localhost:3000](https://localhost:3000)
7. Set up a connection to Trino and explore data in Trino

If you are done, take 5.

Then we'll reconvene in 5 minutes to gather our thoughts, and also discuss what we have learned and [what we haven't covered](./work_notcovered.md).