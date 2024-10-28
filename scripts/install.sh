
#!/bin/bash

export DOCKER_CLI_HINTS=false
export CURL_SSL_BACKEND=secure-transport 

# Install certificates
echo "\n\nInstalling certificates...\n\n"
sudo security add-trusted-cert \
  -d \
  -r trustRoot \
  -k /Library/Keychains/System.keychain \
  ./certs/platform.local.crt
echo -e "\n\nCertificates installed successfully!\n\n"



# Setting up HOSTS file
echo "\n\nSetting up HOSTS file...\n\n"
echo "127.0.0.1  platform.local" | sudo tee -a /etc/hosts > /dev/null
echo "127.0.0.1  auth.platform.local" | sudo tee -a /etc/hosts > /dev/null
echo "127.0.0.1  trino.platform.local" | sudo tee -a /etc/hosts > /dev/null
echo "127.0.0.1  airflow.platform.local" | sudo tee -a /etc/hosts > /dev/null
echo "127.0.0.1  airbyte.platform.local" | sudo tee -a /etc/hosts > /dev/null
echo "127.0.0.1  metabase.platform.local" | sudo tee -a /etc/hosts > /dev/null
echo "127.0.0.1  metabase.platform.local" | sudo tee -a /etc/hosts > /dev/null
echo -e "\n\nHOSTS file configured successfully!\n\n"

cat /etc/hosts

# Download libs
echo -e "\n\nDownloading libs...\n\n"
curl https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.2.4/hadoop-aws-3.2.4.jar --output ./libs/hadoop-aws-3.2.4.jar
curl https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.4/hadoop-aws-3.3.4.jar --output ./libs/hadoop-aws-3.3.4.jar
curl https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.4/hadoop-aws-3.3.6.jar --output ./libs/hadoop-aws-3.3.6.jar
curl https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.772/aws-java-sdk-bundle-1.12.772.jar --output ./libs/aws-java-sdk-bundle-1.12.772.jar
curl https://repo1.maven.org/maven2/org/apache/spark/spark-connect_2.12/3.5.1/spark-connect_2.12-3.5.1.jar --output ./libs/spark-connect_2.12-3.5.1.jar
curl https://repo1.maven.org/maven2/io/delta/delta-spark_2.12/3.2.0/delta-spark_2.12-3.2.0.jar --output ./libs/delta-spark_2.12-3.2.0.jar  
curl https://repo1.maven.org/maven2/io/delta/delta-spark_2.13/4.0.0rc1/delta-spark_2.13-4.0.0rc1.jar --output ./libs/delta-spark_2.13-4.0.0rc1.jar  
echo -e "\n\nLibs downloaded successfully!\n\n"




# Download Docker containers
echo "\n\nDownloading Docker containers...\n\n"
docker pull apache/airflow:2.10.2
docker pull apache/hive:4.0.1
docker pull apache/hive:3.1.3
docker pull apache/spark:4.0.0-preview2
docker pull eclipse-temurin:11-jre-focal
docker pull quay.io/jupyter/pyspark-notebook:spark-3.5.1
docker pull quay.io/jupyter/scipy-notebook:latest
docker pull godatadriven/unity-catalog
docker pull minio/minio
docker pull minio/mc
docker pull postgres:11
docker pull postgres:13
docker pull postgres:16.2
docker pull hashicorp/vault
docker pull redis:7.2-bookworm
docker pull bitnami/spark:3.5.1
docker pull airbyte/init:1.1.0
docker pull airbyte/source-postgres:1.1.0
docker pull airbyte/destination-postgres:1.1.0e
docker pull airbyte/webapp:1.1.0
docker pull airbyte/bootloader:1.1.0
docker pull airbyte/db:1.1.0
docker pull airbyte/scheduler:1.1.0
docker pull airbyte/worker:1.1.0
docker pull airbyte/server:1.1.0
docker pull bash:5.1.16
docker pull metabase/qa-databases:postgres-sample-12
docker pull metabase/qa-databases:mysql-sample-8
docker pull docker.elastic.co/elasticsearch/elasticsearch:7.17.8
docker pull metabase/qa-databases:mongo-sample-5.0
docker pull quay.io/keycloak/keycloak:26.0.1
docker pull meltano/meltano:latest
docker pull prefecthq/prefect:3.0.11.dev10-python3.11-conda
docker pull node
docker pull trinodb/trino:459

echo -e "\n\nDocker containers downloaded successfully!\n\n"





echo -e "\n\n\n"
echo "#######################################################"
echo "######    Installation completed successfully!   ######"
echo "#######################################################"