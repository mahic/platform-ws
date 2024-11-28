# Step 2 - Storage

When building a data platform, we need to have some storage.

A pretty common storage solution for data platforms is object storage.
There exists many S3-compabible object storage solutions such as [Ceph](https://ceph.io/en/), and Ceph is known to be able to scale [pretty nicely to speeds of 1 TiB/s](https://ceph.io/en/news/blog/2024/ceph-a-journey-to-1tibps/)

In this task we will set up [MinIO](https://min.io/), an Open Source S3-compatible service to serve our needs as a lightweight object storage.

1. Add below code to Docker Compose file

```
  minio:
    hostname: minio
    container_name: minio
    image: 'minio/minio:latest'
    ports:
      - '9000:9000'
      - '9001:9001'
    volumes:
      - ./data/s3:/data
    environment:
      MINIO_ROOT_USER: accesskey
      MINIO_ROOT_PASSWORD: secretkey
    command: server /data --console-address :9001
    networks:
      - platform-network

  createbuckets:
    hostname: createbuckets
    container_name: createbuckets
    image: minio/mc:latest
    depends_on:
      - minio
    entrypoint: >
      /bin/sh -c "
      /usr/bin/mc alias set myminio http://minio:9000 accesskey secretkey;
      /usr/bin/mc mb myminio/platform;
      /usr/bin/mc mb myminio/bucket1;
      /usr/bin/mc mb myminio/bucket2;
      "
    networks:
      - platform-network
```

2. `docker compose down`
3. `docker compose up` and wait for all services to boot up
4. Go to [https://s3.platform.local:9001](https://s3.platform.local:9001) and log in with accesskey/secretkey
5. Verify that there are three buckets created called `platform`, `bucket1`and `bucket2`

If you are done, move on to [task 3](./task3.md)